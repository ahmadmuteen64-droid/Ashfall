#!/usr/bin/env node
// AshFall Voxel Lab — MCP Server (stdio transport, zero dependencies)
// Provides programmatic access to the material database and simulation engine.
// Usage: node web/mcp/server.js   (spawned by Claude Code as an MCP server)

const fs = require('fs');
const path = require('path');
const readline = require('readline');

const WEB_DIR = path.resolve(__dirname, '..');
const DB_PATH = path.join(WEB_DIR, 'db.json');
const SCENARIOS_DIR = path.join(WEB_DIR, 'scenarios');

// ── LocalStorage polyfill backed by db.json ──────────────────────
let _store = {};
try {
  const raw = fs.readFileSync(DB_PATH, 'utf8');
  _store = JSON.parse(raw);
} catch (e) { /* first run — no persisted DB yet */ }

function _flushStore() {
  if (!fs.existsSync(path.dirname(DB_PATH))) fs.mkdirSync(path.dirname(DB_PATH), { recursive: true });
  fs.writeFileSync(DB_PATH, JSON.stringify(_store, null, 2));
}

global.localStorage = {
  getItem(key) { return _store.hasOwnProperty(key) ? _store[key] : null; },
  setItem(key, value) { _store[key] = String(value); _flushStore(); },
  removeItem(key) { delete _store[key]; _flushStore(); },
  clear() { _store = {}; _flushStore(); },
  get length() { return Object.keys(_store).length; },
  key(n) { return Object.keys(_store)[n] || null; },
};

// ── Load data.js + sim.js (same concat-and-eval pattern as test.js) ──
// Must be wrapped in a function — top-level eval in a CJS module runs in
// strict-ish mode where function declarations don't leak between eval invocations.
function _loadLib() {
  const code = fs.readFileSync(path.join(WEB_DIR, 'data.js'), 'utf8')
    + '\n' + fs.readFileSync(path.join(WEB_DIR, 'sim.js'), 'utf8')
    + '\n;({ DB, PhaseState, getPhaseAt, transitionTargetId, VoxelSim, buildDemoScene, AIR, PHASE_LABELS });';
  return eval(code);
}
const { DB, PhaseState, getPhaseAt, transitionTargetId, VoxelSim, buildDemoScene, AIR, PHASE_LABELS } = _loadLib();

// ── Active simulation instance ────────────────────────────────────
let sim = new VoxelSim(16);

// ── JSON-RPC 2.0 helpers ──────────────────────────────────────────
function send(id, result) {
  const msg = { jsonrpc: '2.0', id, result };
  process.stdout.write(JSON.stringify(msg) + '\n');
}

function sendError(id, code, message) {
  const msg = { jsonrpc: '2.0', id, error: { code, message } };
  process.stdout.write(JSON.stringify(msg) + '\n');
}

function toolResult(id, data) {
  send(id, { content: [{ type: 'text', text: typeof data === 'string' ? data : JSON.stringify(data, null, 2) }] });
}

function toolError(id, message) {
  sendError(id, -32602, message);
}

// ── After any DB mutation, persist ────────────────────────────────
function dbMutated() {
  DB.save();       // writes to localStorage polyfill → flushes to db.json
  _notifyBridge();
}

// ── WebSocket bridge client (best-effort, non-blocking) ──────────
const net = require('net');
const crypto = require('crypto');
const BRIDGE_PORT = 9138;
const WS_GUID = '258EAFA5-E914-47DA-95CA-C5AB0DC85B11';
let _bridgeSocket = null, _bridgeBuf = Buffer.alloc(0);

function _wsSend(socket, payload) {
  const buf = Buffer.from(payload, 'utf8');
  const len = buf.length;
  let header;
  if (len < 126) {
    header = Buffer.alloc(2);
    header[0] = 0x81; header[1] = 0x80 | len; // FIN+text, masked
  } else {
    header = Buffer.alloc(4);
    header[0] = 0x81; header[1] = 0x80 | 126;
    header.writeUInt16BE(len, 2);
  }
  const mask = crypto.randomBytes(4);
  const masked = Buffer.alloc(len);
  for (let i = 0; i < len; i++) masked[i] = buf[i] ^ mask[i % 4];
  socket.write(Buffer.concat([header, mask, masked]));
}

function _connectBridge() {
  if (_bridgeSocket) return;
  try {
    _bridgeSocket = net.createConnection({ host: '127.0.0.1', port: BRIDGE_PORT }, () => {
      // HTTP upgrade handshake
      const key = crypto.randomBytes(16).toString('base64');
      _bridgeSocket.write(
        'GET / HTTP/1.1\r\n' +
        'Host: 127.0.0.1:' + BRIDGE_PORT + '\r\n' +
        'Upgrade: websocket\r\n' +
        'Connection: Upgrade\r\n' +
        'Sec-WebSocket-Key: ' + key + '\r\n' +
        'Sec-WebSocket-Version: 13\r\n\r\n'
      );
    });
    _bridgeSocket.on('data', (chunk) => {
      _bridgeBuf = Buffer.concat([_bridgeBuf, chunk]);
      // Check for HTTP 101 response
      const str = _bridgeBuf.toString();
      const hdrEnd = str.indexOf('\r\n\r\n');
      if (hdrEnd >= 0) {
        if (str.includes('101')) {
          _wsSend(_bridgeSocket, JSON.stringify({ type: 'hello', role: 'mcp' }));
        } else {
          _bridgeSocket.destroy(); _bridgeSocket = null;
        }
        _bridgeBuf = Buffer.alloc(0);
      }
    });
    _bridgeSocket.on('error', () => { _bridgeSocket = null; });
    _bridgeSocket.on('close', () => { _bridgeSocket = null; });
  } catch (e) { _bridgeSocket = null; }
}

function _notifyBridge() {
  if (_bridgeSocket && !_bridgeSocket.destroyed) {
    try {
      _wsSend(_bridgeSocket, JSON.stringify({
        type: 'db_updated',
        db: { version: 2, materials: DB.materials, reactions: DB.reactions }
      }));
    } catch (e) { /* bridge gone */ }
  }
}

setTimeout(_connectBridge, 100);

// ── Tool definitions (JSON Schema input schemas) ──────────────────
const TOOLS = [
  // ── Material CRUD (5) ──
  {
    name: 'list_materials',
    description: 'List all non-deleted materials in the database with full properties.',
    inputSchema: { type: 'object', properties: {}, required: [] },
  },
  {
    name: 'get_material',
    description: 'Get full details for a single material by ID.',
    inputSchema: {
      type: 'object',
      properties: { id: { type: 'string', description: 'Material ID (e.g. "stone", "water")' } },
      required: ['id'],
    },
  },
  {
    name: 'create_material',
    description: 'Create a new material. ID must be unique. Returns the created material.',
    inputSchema: {
      type: 'object',
      properties: {
        id:          { type: 'string', description: 'Unique identifier (e.g. "copper_ore")' },
        name:        { type: 'string', description: 'Display name' },
        category:    { type: 'string', enum: ['earth','mineral','organic','constructed','water','special','custom'], default: 'custom' },
        color:       { type: 'string', description: 'Hex color, e.g. "#a56cc7"' },
        opacity:     { type: 'number', minimum: 0, maximum: 1, default: 1 },
        phase:       { type: 'integer', enum: [0, 1, 2], default: 0, description: '0=SOLID, 1=LIQUID, 2=GAS' },
        defaultTemp: { type: 'number', default: 20 },
        conductivity:{ type: 'number', minimum: 0, maximum: 1, default: 0.5 },
        density:     { type: 'number', minimum: 0, default: 1.0 },
        meltPoint:   { description: 'Melting point °C. null = does not melt' },
        boilPoint:   { description: 'Boiling point °C. null = does not boil' },
        freezePoint: { description: 'Freezing point °C. null = does not freeze' },
        onMelt:      { type: 'string', default: '', description: 'Material ID to become on melting' },
        onBoil:      { type: 'string', default: '', description: 'Material ID to become on boiling' },
        onFreeze:    { type: 'string', default: '', description: 'Material ID to become on freezing' },
        flammable:   { type: 'boolean', default: false },
        ignition:    { type: 'number', default: 300, description: 'Ignition temperature °C' },
        burnLife:    { type: 'number', default: 120, description: 'Ticks material burns for' },
        burnResult:  { type: 'string', default: 'ash', description: 'Material left after burning' },
        granular:    { type: 'boolean', default: false, description: 'Falls like sand' },
        elecCond:    { type: 'number', minimum: 0, maximum: 1, default: 0.1, description: 'Electrical conductivity 0-1' },
        desc:        { type: 'string', default: 'Describe this material…' },
      },
      required: ['id'],
    },
  },
  {
    name: 'edit_material',
    description: 'Edit one or more properties of an existing material. The id field cannot be changed.',
    inputSchema: {
      type: 'object',
      properties: {
        id:          { type: 'string' },
        name:        { type: 'string' },
        category:    { type: 'string', enum: ['earth','mineral','organic','constructed','water','special','custom'] },
        color:       { type: 'string' },
        opacity:     { type: 'number', minimum: 0, maximum: 1 },
        phase:       { type: 'integer', enum: [0, 1, 2] },
        defaultTemp: { type: 'number' },
        conductivity:{ type: 'number', minimum: 0, maximum: 1 },
        density:     { type: 'number', minimum: 0 },
        meltPoint:   { description: 'null = N/A' },
        boilPoint:   { description: 'null = N/A' },
        freezePoint: { description: 'null = N/A' },
        onMelt:      { type: 'string' },
        onBoil:      { type: 'string' },
        onFreeze:    { type: 'string' },
        flammable:   { type: 'boolean' },
        ignition:    { type: 'number' },
        burnLife:    { type: 'number' },
        burnResult:  { type: 'string' },
        granular:    { type: 'boolean' },
        elecCond:    { type: 'number', minimum: 0, maximum: 1 },
        desc:        { type: 'string' },
      },
      required: ['id'],
    },
  },
  {
    name: 'delete_material',
    description: 'Soft-delete a custom material by ID. Built-in materials (non-custom category) cannot be deleted.',
    inputSchema: {
      type: 'object',
      properties: { id: { type: 'string' } },
      required: ['id'],
    },
  },

  // ── Reaction CRUD (3) ──
  {
    name: 'list_reactions',
    description: 'List all reactions with their array indices.',
    inputSchema: { type: 'object', properties: {}, required: [] },
  },
  {
    name: 'create_reaction',
    description: 'Create a new reaction. For contact reactions, both A and B are required. For heat reactions, only A and minTemp matter.',
    inputSchema: {
      type: 'object',
      properties: {
        kind:     { type: 'string', enum: ['contact', 'heat'], description: '"contact" = A touches B triggers; "heat" = A at minTemp triggers' },
        a:        { type: 'string', description: 'Subject material ID' },
        b:        { type: 'string', default: '', description: 'Trigger material ID (for contact reactions)' },
        minTemp:  { description: 'Minimum temperature threshold. null = no temp requirement' },
        chance:   { type: 'number', minimum: 0, maximum: 1, default: 1, description: 'Probability per tick. 1 = instant' },
        resultA:  { type: 'string', default: '', description: 'Material A becomes this (empty = air)' },
        resultB:  { type: 'string', default: '', description: 'Material B becomes this (empty = air, for contact)' },
        note:     { type: 'string', default: '', description: 'Human-readable description' },
      },
      required: ['kind', 'a'],
    },
  },
  {
    name: 'delete_reaction',
    description: 'Delete a reaction by its array index (from list_reactions).',
    inputSchema: {
      type: 'object',
      properties: { index: { type: 'integer', minimum: 0, description: 'Reaction index in the list' } },
      required: ['index'],
    },
  },

  // ── Simulation (10) ──
  {
    name: 'sim_reset',
    description: 'Create a new empty simulation volume. Preserves ambient temperature from the previous sim.',
    inputSchema: {
      type: 'object',
      properties: { n: { type: 'integer', minimum: 4, maximum: 24, default: 16, description: 'Grid side length (n x n x n)' } },
      required: [],
    },
  },
  {
    name: 'sim_set_cell',
    description: 'Place a material (or clear) a single cell at coordinates.',
    inputSchema: {
      type: 'object',
      properties: {
        x:     { type: 'integer', description: 'X coordinate (0 to n-1)' },
        y:     { type: 'integer', description: 'Y coordinate (0 to n-1)' },
        z:     { type: 'integer', description: 'Z coordinate (0 to n-1)' },
        matId: { type: 'string', description: 'Material ID. Pass "" or "air" to clear the cell.' },
      },
      required: ['x', 'y', 'z'],
    },
  },
  {
    name: 'sim_fill_rect',
    description: 'Fill a cuboid region (inclusive bounds) with a material or clear it.',
    inputSchema: {
      type: 'object',
      properties: {
        x1:    { type: 'integer' }, y1: { type: 'integer' }, z1: { type: 'integer' },
        x2:    { type: 'integer' }, y2: { type: 'integer' }, z2: { type: 'integer' },
        matId: { type: 'string', description: 'Material ID, or ""/null to clear' },
      },
      required: ['x1', 'y1', 'z1', 'x2', 'y2', 'z2'],
    },
  },
  {
    name: 'sim_advance',
    description: 'Advance the simulation by N ticks. Returns before/after stats. Cap: 10,000 ticks per call.',
    inputSchema: {
      type: 'object',
      properties: { ticks: { type: 'integer', minimum: 1, maximum: 10000, default: 1 } },
      required: [],
    },
  },
  {
    name: 'sim_get_state',
    description: 'Dump the full simulation grid. Returns every non-air cell with position, material, temp, and phase.',
    inputSchema: { type: 'object', properties: {}, required: [] },
  },
  {
    name: 'sim_get_cell',
    description: 'Get detailed info about a single cell: material, temperature, phase, burning status.',
    inputSchema: {
      type: 'object',
      properties: {
        x: { type: 'integer' }, y: { type: 'integer' }, z: { type: 'integer' },
      },
      required: ['x', 'y', 'z'],
    },
  },
  {
    name: 'sim_get_stats',
    description: 'Aggregate statistics: material counts, phase distribution, average temperature, burning cells.',
    inputSchema: { type: 'object', properties: {}, required: [] },
  },
  {
    name: 'sim_set_ambient',
    description: 'Set the ambient (background) temperature. Air cells are pinned to this value.',
    inputSchema: {
      type: 'object',
      properties: { temp: { type: 'number', description: 'Ambient temperature in °C' } },
      required: ['temp'],
    },
  },
  {
    name: 'sim_strike',
    description: 'Apply heat gun, freeze gun, or electric zap at a specific cell.',
    inputSchema: {
      type: 'object',
      properties: {
        x:     { type: 'integer' },
        y:     { type: 'integer' },
        z:     { type: 'integer' },
        type:  { type: 'string', enum: ['heat', 'freeze', 'zap'], description: 'heat: +900°C; freeze: -900°C; zap: lightning arc' },
        power: { type: 'number', description: 'Override default power (heat/freeze: °C delta; zap: base joules)' },
      },
      required: ['x', 'y', 'z', 'type'],
    },
  },
  {
    name: 'sim_load_demo',
    description: 'Load the built-in demo scene: stone floor, water basin, lava pool, ice block, tree with fuse, floating sand, snow.',
    inputSchema: { type: 'object', properties: {}, required: [] },
  },

  // ── Scenarios (4) ──
  {
    name: 'scenario_save',
    description: 'Save the current database (materials + reactions) and simulation state to a named scenario file.',
    inputSchema: {
      type: 'object',
      properties: { name: { type: 'string', description: 'Scenario name. Use letters, numbers, underscores, hyphens.' } },
      required: ['name'],
    },
  },
  {
    name: 'scenario_load',
    description: 'Load a saved scenario, restoring the database and simulation state.',
    inputSchema: {
      type: 'object',
      properties: { name: { type: 'string' } },
      required: ['name'],
    },
  },
  {
    name: 'scenario_list',
    description: 'List all saved scenarios.',
    inputSchema: { type: 'object', properties: {}, required: [] },
  },
  {
    name: 'scenario_delete',
    description: 'Delete a saved scenario.',
    inputSchema: {
      type: 'object',
      properties: { name: { type: 'string' } },
      required: ['name'],
    },
  },

  // ── Export (1) ──
  {
    name: 'export_godot_json',
    description: 'Export all materials and reactions in Godot .tres-compatible JSON format (field names match voxel_type.gd).',
    inputSchema: { type: 'object', properties: {}, required: [] },
  },
];

// ── Tool handler dispatch ─────────────────────────────────────────
function handleToolCall(id, params) {
  const { name, arguments: args = {} } = params || {};
  try {
    switch (name) {
      // ── Materials ──
      case 'list_materials':
        return toolResult(id, DB.materials.filter(m => !m.deleted));

      case 'get_material': {
        const m = DB.byId(args.id);
        if (!m) return toolError(id, `Material not found: ${args.id}`);
        return toolResult(id, m);
      }

      case 'create_material': {
        if (DB.byId(args.id)) return toolError(id, `Material ID already exists: ${args.id}`);
        if (!/^[a-z][a-z0-9_]*$/.test(args.id)) return toolError(id, `Invalid ID "${args.id}". Use lowercase letters, digits, underscores (must start with letter).`);
        const m = {
          id: args.id,
          name: args.name || 'New Material',
          category: args.category || 'custom',
          color: args.color || '#a56cc7',
          opacity: args.opacity ?? 1,
          phase: args.phase ?? PhaseState.SOLID,
          defaultTemp: args.defaultTemp ?? 20,
          conductivity: args.conductivity ?? 0.5,
          density: args.density ?? 1.0,
          meltPoint: args.meltPoint !== undefined ? args.meltPoint : null,
          boilPoint: args.boilPoint !== undefined ? args.boilPoint : null,
          freezePoint: args.freezePoint !== undefined ? args.freezePoint : null,
          onMelt: args.onMelt || '',
          onBoil: args.onBoil || '',
          onFreeze: args.onFreeze || '',
          flammable: args.flammable || false,
          ignition: args.ignition ?? 300,
          burnLife: args.burnLife ?? 120,
          burnResult: args.burnResult || 'ash',
          granular: args.granular || false,
          elecCond: args.elecCond ?? 0.1,
          desc: args.desc || 'Describe this material…',
        };
        DB.materials.push(m);
        DB.refresh();
        dbMutated();
        return toolResult(id, m);
      }

      case 'edit_material': {
        const m = DB.byId(args.id);
        if (!m) return toolError(id, `Material not found: ${args.id}`);
        const editable = ['name','category','color','opacity','phase','defaultTemp','conductivity',
          'density','meltPoint','boilPoint','freezePoint','onMelt','onBoil','onFreeze',
          'flammable','ignition','burnLife','burnResult','granular','elecCond','desc'];
        for (const key of editable) {
          if (args.hasOwnProperty(key)) m[key] = args[key];
        }
        DB.refresh();
        dbMutated();
        return toolResult(id, m);
      }

      case 'delete_material': {
        const m = DB.byId(args.id);
        if (!m) return toolError(id, `Material not found: ${args.id}`);
        if (m.category !== 'custom') return toolError(id, `Cannot delete built-in material "${args.id}" (category: ${m.category}). Only custom materials can be deleted.`);
        const mi = DB.indexOf(args.id);
        m.deleted = true;
        DB.refresh();
        sim.purgeMaterialIndex(mi);
        dbMutated();
        return toolResult(id, { deleted: args.id });
      }

      // ── Reactions ──
      case 'list_reactions':
        return toolResult(id, DB.reactions.map((r, i) => ({ index: i, ...r })));

      case 'create_reaction': {
        const r = {
          kind: args.kind,
          a: args.a,
          b: args.b || '',
          minTemp: args.minTemp !== undefined ? args.minTemp : null,
          chance: args.chance ?? 1,
          resultA: args.resultA || '',
          resultB: args.resultB || '',
          note: args.note || '',
        };
        if (r.kind === 'contact' && !r.b) return toolError(id, 'Contact reactions require a "b" material.');
        DB.reactions.push(r);
        dbMutated();
        return toolResult(id, { index: DB.reactions.length - 1, ...r });
      }

      case 'delete_reaction': {
        const i = args.index;
        if (i < 0 || i >= DB.reactions.length) return toolError(id, `Reaction index out of range: ${i} (have ${DB.reactions.length})`);
        const removed = DB.reactions[i];
        DB.reactions.splice(i, 1);
        dbMutated();
        return toolResult(id, { deleted: removed });
      }

      // ── Simulation ──
      case 'sim_reset': {
        const n = args.n || 16;
        const ambient = sim.ambient;
        sim = new VoxelSim(Math.min(24, Math.max(4, n)));
        sim.ambient = ambient;
        return toolResult(id, { n: sim.n, tickCount: 0, ambient: sim.ambient });
      }

      case 'sim_set_cell': {
        const matId = (!args.matId || args.matId === 'air') ? null : args.matId;
        if (matId && !DB.byId(matId)) return toolError(id, `Material not found: ${matId}`);
        sim.setCell(args.x, args.y, args.z, matId);
        return toolResult(id, sim.cellInfo(args.x, args.y, args.z));
      }

      case 'sim_fill_rect': {
        const { x1, y1, z1, x2, y2, z2 } = args;
        const matId = (!args.matId || args.matId === 'air') ? null : args.matId;
        if (matId && !DB.byId(matId)) return toolError(id, `Material not found: ${matId}`);
        let filled = 0;
        const [sx, ex] = [Math.min(x1, x2), Math.max(x1, x2)];
        const [sy, ey] = [Math.min(y1, y2), Math.max(y1, y2)];
        const [sz, ez] = [Math.min(z1, z2), Math.max(z1, z2)];
        for (let y = sy; y <= ey; y++)
          for (let z = sz; z <= ez; z++)
            for (let x = sx; x <= ex; x++) {
              sim.setCell(x, y, z, matId);
              filled++;
            }
        return toolResult(id, { cells_filled: filled });
      }

      case 'sim_advance': {
        const ticks = args.ticks || 1;
        const before = _gatherStats();
        const tickBefore = sim.tickCount;
        for (let t = 0; t < ticks; t++) sim.tick();
        const after = _gatherStats();
        return toolResult(id, {
          ticks_run: ticks,
          tick: sim.tickCount,
          before: { tick: tickBefore, materialCounts: before.materialCounts, avgTemp: before.avgTemp },
          after: { tick: sim.tickCount, materialCounts: after.materialCounts, avgTemp: after.avgTemp },
          changes: _diffStats(before, after),
        });
      }

      case 'sim_get_state': {
        const cells = [];
        for (let y = 0; y < sim.n; y++)
          for (let z = 0; z < sim.n; z++)
            for (let x = 0; x < sim.n; x++) {
              const mi = sim.get(x, y, z);
              if (mi === AIR) continue;
              const m = DB.materials[mi];
              const t = sim.temp[sim.idx(x, y, z)];
              cells.push({
                x, y, z,
                matId: m.id,
                temp: Math.round(t * 10) / 10,
                phase: PHASE_LABELS[getPhaseAt(m, t)],
                burning: sim.burn[sim.idx(x, y, z)] > 0,
              });
            }
        return toolResult(id, { n: sim.n, tick: sim.tickCount, ambient: sim.ambient, cellCount: cells.length, cells });
      }

      case 'sim_get_cell':
        return toolResult(id, sim.cellInfo(args.x, args.y, args.z));

      case 'sim_get_stats':
        return toolResult(id, _gatherStats());

      case 'sim_set_ambient': {
        sim.ambient = args.temp;
        return toolResult(id, { ambient: sim.ambient });
      }

      case 'sim_strike': {
        const { x, y, z, type, power } = args;
        if (!sim.inBounds(x, y, z)) return toolError(id, `Cell (${x},${y},${z}) out of bounds (grid ${sim.n}x${sim.n}x${sim.n})`);
        if (sim.get(x, y, z) === AIR) return toolError(id, `Cell (${x},${y},${z}) is air — strike has no effect`);

        let result;
        switch (type) {
          case 'heat':
            sim.addHeat(x, y, z, power || 900);
            result = { type: 'heat', temp: Math.round(sim.temp[sim.idx(x, y, z)] * 10) / 10 };
            break;
          case 'freeze':
            sim.addHeat(x, y, z, -(power || 900));
            result = { type: 'freeze', temp: Math.round(sim.temp[sim.idx(x, y, z)] * 10) / 10 };
            break;
          case 'zap': {
            const affected = sim.zap(x, y, z, power || 1500);
            result = { type: 'zap', affected_cells: affected.length, affected };
            break;
          }
          default:
            return toolError(id, `Unknown strike type: ${type}`);
        }
        return toolResult(id, result);
      }

      case 'sim_load_demo': {
        buildDemoScene(sim);
        return toolResult(id, { demo_loaded: true, ..._gatherStats() });
      }

      // ── Scenarios ──
      case 'scenario_save': {
        const name = args.name.replace(/[^a-zA-Z0-9_-]/g, '_');
        if (!name) return toolError(id, 'Invalid scenario name');
        if (!fs.existsSync(SCENARIOS_DIR)) fs.mkdirSync(SCENARIOS_DIR, { recursive: true });

        const matArr = [];
        for (let i = 0; i < sim.mat.length; i++) matArr.push(sim.mat[i]);
        const tmpArr = [];
        for (let i = 0; i < sim.temp.length; i++) tmpArr.push(Math.round(sim.temp[i] * 10) / 10);
        const brnArr = [];
        for (let i = 0; i < sim.burn.length; i++) brnArr.push(sim.burn[i]);

        const data = {
          metadata: { name, savedAt: new Date().toISOString(), version: 1 },
          db: { version: 2, materials: DB.materials, reactions: DB.reactions },
          sim: { n: sim.n, ambient: sim.ambient, tickCount: sim.tickCount, mat: matArr, temp: tmpArr, burn: brnArr },
        };
        fs.writeFileSync(path.join(SCENARIOS_DIR, `${name}.json`), JSON.stringify(data, null, 2));
        return toolResult(id, { saved: name, tick: sim.tickCount, materialCount: DB.materials.filter(m => !m.deleted).length });
      }

      case 'scenario_load': {
        const name = args.name.replace(/[^a-zA-Z0-9_-]/g, '_');
        const filePath = path.join(SCENARIOS_DIR, `${name}.json`);
        if (!fs.existsSync(filePath)) return toolError(id, `Scenario not found: ${name}`);

        const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));

        // Restore DB
        DB.materials = data.db.materials;
        DB.reactions = data.db.reactions;
        DB.refresh();
        dbMutated();

        // Restore sim
        const d = data.sim;
        sim = new VoxelSim(d.n);
        sim.ambient = d.ambient;
        sim.tickCount = d.tickCount;
        sim.mat.set(d.mat.slice(0, sim.mat.length));
        sim.temp.set(d.temp.slice(0, sim.temp.length));
        sim.burn.set(d.burn.slice(0, sim.burn.length));

        return toolResult(id, { loaded: name, ..._gatherStats() });
      }

      case 'scenario_list': {
        if (!fs.existsSync(SCENARIOS_DIR)) return toolResult(id, []);
        const files = fs.readdirSync(SCENARIOS_DIR)
          .filter(f => f.endsWith('.json'))
          .map(f => {
            const fp = path.join(SCENARIOS_DIR, f);
            const stat = fs.statSync(fp);
            return { name: f.replace('.json', ''), size: stat.size, savedAt: stat.mtime.toISOString() };
          });
        return toolResult(id, files);
      }

      case 'scenario_delete': {
        const name = args.name.replace(/[^a-zA-Z0-9_-]/g, '_');
        const filePath = path.join(SCENARIOS_DIR, `${name}.json`);
        if (!fs.existsSync(filePath)) return toolError(id, `Scenario not found: ${name}`);
        fs.unlinkSync(filePath);
        return toolResult(id, { deleted: name });
      }

      // ── Export ──
      case 'export_godot_json':
        return toolResult(id, DB.exportJSON());

      default:
        return toolError(id, `Unknown tool: ${name}`);
    }
  } catch (e) {
    sendError(id, -32603, `Internal error: ${e.message}\n${e.stack}`);
  }
}

// ── Stats helpers ──────────────────────────────────────────────────
function _gatherStats() {
  let total = 0, airCount = 0, sumTemp = 0, tempCount = 0, minTemp = Infinity, maxTemp = -Infinity, burning = 0;
  const counts = {};
  const phases = { Solid: 0, Liquid: 0, Gas: 0 };
  for (let y = 0; y < sim.n; y++) for (let z = 0; z < sim.n; z++) for (let x = 0; x < sim.n; x++) {
    total++;
    const mi = sim.get(x, y, z);
    if (mi === AIR) { airCount++; continue; }
    const m = DB.materials[mi];
    const i = sim.idx(x, y, z);
    const t = sim.temp[i];
    counts[m.id] = (counts[m.id] || 0) + 1;
    sumTemp += t; tempCount++;
    if (t < minTemp) minTemp = t;
    if (t > maxTemp) maxTemp = t;
    if (sim.burn[i] > 0) burning++;
    phases[PHASE_LABELS[getPhaseAt(m, t)]]++;
  }
  return {
    n: sim.n, tick: sim.tickCount, ambient: sim.ambient,
    totalCells: total, airCells: airCount, filledCells: total - airCount,
    materialCounts: counts,
    phaseDistribution: phases,
    avgTemp: tempCount ? Math.round(sumTemp / tempCount * 10) / 10 : sim.ambient,
    minTemp: minTemp === Infinity ? sim.ambient : Math.round(minTemp * 10) / 10,
    maxTemp: maxTemp === -Infinity ? sim.ambient : Math.round(maxTemp * 10) / 10,
    burningCells: burning,
  };
}

function _diffStats(before, after) {
  const diffs = {};
  const allKeys = new Set([...Object.keys(before.materialCounts), ...Object.keys(after.materialCounts)]);
  for (const k of allKeys) {
    const d = (after.materialCounts[k] || 0) - (before.materialCounts[k] || 0);
    if (d !== 0) diffs[k] = d > 0 ? `+${d}` : `${d}`;
  }
  return { materialDeltas: diffs, avgTempDelta: Math.round((after.avgTemp - before.avgTemp) * 10) / 10 };
}

// ── JSON-RPC 2.0 main loop ────────────────────────────────────────
const rl = readline.createInterface({ input: process.stdin, terminal: false });

rl.on('line', (line) => {
  let req;
  try { req = JSON.parse(line); } catch (e) {
    sendError(null, -32700, 'Parse error');
    return;
  }
  const { jsonrpc, id, method, params } = req;
  if (jsonrpc !== '2.0') { sendError(id, -32600, 'Invalid Request: jsonrpc must be "2.0"'); return; }

  switch (method) {
    case 'initialize':
      send(id, {
        protocolVersion: '2024-11-05',
        capabilities: { tools: {} },
        serverInfo: { name: 'ashfall-voxel-lab', version: '1.0.0' },
      });
      break;
    case 'notifications/initialized':
      // No response for notifications
      break;
    case 'tools/list':
      send(id, { tools: TOOLS });
      break;
    case 'tools/call':
      handleToolCall(id, params);
      break;
    case 'ping':
      send(id, {});
      break;
    default:
      sendError(id, -32601, `Method not found: ${method}`);
  }
});

rl.on('close', () => { /* Claude Code closed stdin — exit gracefully */ process.exit(0); });
