// AshFall — Voxel Lab: Material & Reaction Database
// Mirrors data/voxel/types/*.tres, plus web-only sim fields (color, ignition, granular...).
// Threshold fields use null = "not applicable" (NOT 0 — water really freezes at 0°C).

const PhaseState = Object.freeze({ SOLID: 0, LIQUID: 1, GAS: 2 });
const PHASE_LABELS = ['Solid', 'Liquid', 'Gas'];
const PHASE_COLORS = ['#c9a87c', '#60a5fa', '#cbd5e1'];

const DEFAULT_MATERIALS = [
  // ── Earth ───────────────────────────────────────
  { id: 'dirt', name: 'Dirt', category: 'earth', color: '#7a5230', opacity: 1,
    phase: PhaseState.SOLID, defaultTemp: 20, conductivity: 0.3, density: 1.3,
    meltPoint: null, boilPoint: null, freezePoint: null,
    onMelt: '', onBoil: '', onFreeze: '',
    flammable: false, ignition: 300, burnLife: 120, burnResult: 'ash', granular: false,
    desc: 'Loose earth. Combines with water into mud.' },
  { id: 'sand', name: 'Sand', category: 'earth', color: '#dfc98a', opacity: 1,
    phase: PhaseState.SOLID, defaultTemp: 20, conductivity: 0.25, density: 1.5,
    meltPoint: null, boilPoint: null, freezePoint: null,
    onMelt: '', onBoil: '', onFreeze: '',
    flammable: false, ignition: 300, burnLife: 120, burnResult: 'ash', granular: true,
    desc: 'Falls and piles. Vitrifies into glass under extreme heat.' },
  { id: 'gravel', name: 'Gravel', category: 'earth', color: '#9a9186', opacity: 1,
    phase: PhaseState.SOLID, defaultTemp: 20, conductivity: 0.35, density: 1.7,
    meltPoint: 1300, boilPoint: null, freezePoint: null,
    onMelt: 'lava', onBoil: '', onFreeze: '',
    flammable: false, ignition: 300, burnLife: 120, burnResult: 'ash', granular: true,
    desc: 'Loose rock fragments. Unstable footing.' },
  { id: 'mud', name: 'Mud', category: 'earth', color: '#5d4630', opacity: 1,
    phase: PhaseState.SOLID, defaultTemp: 20, conductivity: 0.35, density: 1.6,
    meltPoint: null, boilPoint: null, freezePoint: null,
    onMelt: '', onBoil: '', onFreeze: '',
    flammable: false, ignition: 300, burnLife: 120, burnResult: 'ash', granular: false,
    desc: 'Wet earth. Bakes into brick under heat.' },

  // ── Mineral ─────────────────────────────────────
  { id: 'stone', name: 'Stone', category: 'mineral', color: '#8a8f98', opacity: 1,
    phase: PhaseState.SOLID, defaultTemp: 20, conductivity: 0.6, density: 2.5,
    meltPoint: 1200, boilPoint: null, freezePoint: null,
    onMelt: 'lava', onBoil: '', onFreeze: '',
    flammable: false, ignition: 300, burnLife: 120, burnResult: 'ash', granular: false,
    desc: 'Common grey stone. The bones of the Ark.' },
  { id: 'crystal', name: 'Crystal', category: 'mineral', color: '#7ee0e6', opacity: 0.85,
    phase: PhaseState.SOLID, defaultTemp: 20, conductivity: 0.8, density: 2.2,
    meltPoint: 800, boilPoint: null, freezePoint: null,
    onMelt: '', onBoil: '', onFreeze: '',
    flammable: false, ignition: 300, burnLife: 120, burnResult: 'ash', granular: false,
    desc: 'Resonant crystal. Humming with ancient energy.' },
  { id: 'obsidian', name: 'Obsidian', category: 'mineral', color: '#241f31', opacity: 1,
    phase: PhaseState.SOLID, defaultTemp: 20, conductivity: 0.2, density: 3.0,
    meltPoint: 1600, boilPoint: null, freezePoint: null,
    onMelt: 'lava', onBoil: '', onFreeze: '',
    flammable: false, ignition: 300, burnLife: 120, burnResult: 'ash', granular: false,
    desc: 'Volcanic glass. Razor-sharp edges.' },
  { id: 'volcanic', name: 'Volcanic Rock', category: 'mineral', color: '#3a3335', opacity: 1,
    phase: PhaseState.SOLID, defaultTemp: 200, conductivity: 0.7, density: 2.8,
    meltPoint: 2000, boilPoint: null, freezePoint: null,
    onMelt: 'lava', onBoil: '', onFreeze: '',
    flammable: false, ignition: 300, burnLife: 120, burnResult: 'ash', granular: false,
    desc: 'Dark basalt. Born of fire.' },
  { id: 'lava', name: 'Lava', category: 'mineral', color: '#ff5a1f', opacity: 1,
    phase: PhaseState.LIQUID, defaultTemp: 1000, conductivity: 0.7, density: 2.8,
    meltPoint: null, boilPoint: null, freezePoint: 700,
    onMelt: '', onBoil: '', onFreeze: 'volcanic',
    flammable: false, ignition: 300, burnLife: 120, burnResult: 'ash', granular: false,
    desc: 'Molten rock. Crusts over into volcanic rock as it cools.' },
  { id: 'glass', name: 'Glass', category: 'mineral', color: '#bfe3ea', opacity: 0.5,
    phase: PhaseState.SOLID, defaultTemp: 20, conductivity: 0.4, density: 2.4,
    meltPoint: 1700, boilPoint: null, freezePoint: null,
    onMelt: 'lava', onBoil: '', onFreeze: '',
    flammable: false, ignition: 300, burnLife: 120, burnResult: 'ash', granular: false,
    desc: 'Vitrified sand. Transparent and brittle.' },

  // ── Organic ─────────────────────────────────────
  { id: 'grass', name: 'Grass Block', category: 'organic', color: '#4c9e3f', opacity: 1,
    phase: PhaseState.SOLID, defaultTemp: 20, conductivity: 0.2, density: 0.9,
    meltPoint: null, boilPoint: null, freezePoint: null,
    onMelt: '', onBoil: '', onFreeze: '',
    flammable: true, ignition: 280, burnLife: 80, burnResult: 'dirt', granular: false,
    desc: 'Living topsoil. Burns down to bare dirt.' },
  { id: 'wood', name: 'Wood', category: 'organic', color: '#8b5a2b', opacity: 1,
    phase: PhaseState.SOLID, defaultTemp: 20, conductivity: 0.15, density: 0.6,
    meltPoint: null, boilPoint: null, freezePoint: null,
    onMelt: '', onBoil: '', onFreeze: '',
    flammable: true, ignition: 300, burnLife: 240, burnResult: 'ash', granular: false,
    desc: 'Timber from the ancient groves. Burns long and hot.' },
  { id: 'leaves', name: 'Leaves', category: 'organic', color: '#3f7d2e', opacity: 1,
    phase: PhaseState.SOLID, defaultTemp: 20, conductivity: 0.1, density: 0.3,
    meltPoint: null, boilPoint: null, freezePoint: null,
    onMelt: '', onBoil: '', onFreeze: '',
    flammable: true, ignition: 260, burnLife: 50, burnResult: '', granular: false,
    desc: 'Dense canopy foliage. Flashes away when burnt.' },
  { id: 'moss', name: 'Moss', category: 'organic', color: '#5e8c4a', opacity: 1,
    phase: PhaseState.SOLID, defaultTemp: 20, conductivity: 0.1, density: 0.5,
    meltPoint: null, boilPoint: null, freezePoint: null,
    onMelt: '', onBoil: '', onFreeze: '',
    flammable: true, ignition: 280, burnLife: 100, burnResult: 'ash', granular: false,
    desc: 'Ancient moss. Soft and absorbent.' },
  { id: 'ash', name: 'Ash', category: 'organic', color: '#5c5c5c', opacity: 1,
    phase: PhaseState.SOLID, defaultTemp: 20, conductivity: 0.15, density: 0.4,
    meltPoint: null, boilPoint: null, freezePoint: null,
    onMelt: '', onBoil: '', onFreeze: '',
    flammable: false, ignition: 300, burnLife: 120, burnResult: 'ash', granular: true,
    desc: 'Burnt remains. Light and powdery.' },

  // ── Constructed ─────────────────────────────────
  { id: 'brick', name: 'Brick', category: 'constructed', color: '#b0533b', opacity: 1,
    phase: PhaseState.SOLID, defaultTemp: 20, conductivity: 0.4, density: 2.0,
    meltPoint: 1500, boilPoint: null, freezePoint: null,
    onMelt: 'lava', onBoil: '', onFreeze: '',
    flammable: false, ignition: 300, burnLife: 120, burnResult: 'ash', granular: false,
    desc: 'Fired clay brick. Baked mud, echo of a lost civilization.' },
  { id: 'ruined_stone', name: 'Ruined Stone', category: 'constructed', color: '#6f7376', opacity: 1,
    phase: PhaseState.SOLID, defaultTemp: 20, conductivity: 0.5, density: 2.3,
    meltPoint: 1100, boilPoint: null, freezePoint: null,
    onMelt: 'lava', onBoil: '', onFreeze: '',
    flammable: false, ignition: 300, burnLife: 120, burnResult: 'ash', granular: false,
    desc: 'Weathered stone. Crumbling but dignified.' },

  // ── Water cycle ─────────────────────────────────
  { id: 'ice', name: 'Ice', category: 'water', color: '#aee3f5', opacity: 0.8,
    phase: PhaseState.SOLID, defaultTemp: -5, conductivity: 0.9, density: 0.9,
    meltPoint: 5, boilPoint: null, freezePoint: null,
    onMelt: 'water', onBoil: '', onFreeze: '',
    flammable: false, ignition: 300, burnLife: 120, burnResult: 'ash', granular: false,
    desc: 'Frozen water. Cold to the touch.' },
  { id: 'snow', name: 'Snow', category: 'water', color: '#f3f8fb', opacity: 1,
    phase: PhaseState.SOLID, defaultTemp: -10, conductivity: 0.3, density: 0.2,
    meltPoint: 2, boilPoint: null, freezePoint: null,
    onMelt: 'water', onBoil: '', onFreeze: '',
    flammable: false, ignition: 300, burnLife: 120, burnResult: 'ash', granular: true,
    desc: 'Fresh powder. Silences footsteps.' },
  { id: 'water', name: 'Water', category: 'water', color: '#3b82f6', opacity: 0.6,
    phase: PhaseState.LIQUID, defaultTemp: 15, conductivity: 0.8, density: 1.0,
    meltPoint: null, boilPoint: 100, freezePoint: 0,
    onMelt: '', onBoil: 'steam', onFreeze: 'ice',
    flammable: false, ignition: 300, burnLife: 120, burnResult: 'ash', granular: false,
    desc: 'Flows, freezes, boils. Essential for life.' },
  { id: 'steam', name: 'Steam', category: 'water', color: '#d7dee6', opacity: 0.35,
    phase: PhaseState.GAS, defaultTemp: 120, conductivity: 0.3, density: 0.1,
    meltPoint: null, boilPoint: 100, freezePoint: null,
    onMelt: '', onBoil: '', onFreeze: 'water',
    flammable: false, ignition: 300, burnLife: 120, burnResult: 'ash', granular: false,
    desc: 'Rises while hot, condenses back to water as it cools.' },

  // ── Special ─────────────────────────────────────
  { id: 'bedrock', name: 'Bedrock', category: 'special', color: '#14181f', opacity: 1,
    phase: PhaseState.SOLID, defaultTemp: 20, conductivity: 0.0, density: 999,
    meltPoint: null, boilPoint: null, freezePoint: null,
    onMelt: '', onBoil: '', onFreeze: '',
    flammable: false, ignition: 300, burnLife: 120, burnResult: 'ash', granular: false,
    desc: 'The unbreakable, un-heatable foundation of the Ark.' },
];

// Electrical conductivity per material (0–1) — how well the ⚡ zap arcs through it.
const ELEC_DEFAULTS = {
  water: 0.9, crystal: 0.8, lava: 0.6, mud: 0.55, ice: 0.35, moss: 0.3,
  snow: 0.25, grass: 0.25, dirt: 0.2, steam: 0.15, leaves: 0.1, gravel: 0.1,
  volcanic: 0.1, glass: 0, obsidian: 0, bedrock: 0,
};
for (const m of DEFAULT_MATERIALS) m.elecCond = ELEC_DEFAULTS[m.id] ?? 0.05;

// Reactions — the emergent-gameplay layer.
//   kind 'contact': cell A touching cell B  → A becomes resultA, B becomes resultB ('' = air).
//   kind 'heat':    cell A at temp ≥ minTemp → A becomes resultA. (No B involved.)
//   chance: probability per tick (1 = instant, small values = slow growth/erosion).
const DEFAULT_REACTIONS = [
  { kind: 'contact', a: 'dirt',   b: 'water', minTemp: null, chance: 1,    resultA: 'mud',      resultB: '',      note: 'Dirt absorbs water into mud' },
  { kind: 'contact', a: 'lava',   b: 'water', minTemp: null, chance: 1,    resultA: 'volcanic', resultB: 'steam', note: 'Water quenches lava' },
  { kind: 'contact', a: 'lava',   b: 'ice',   minTemp: null, chance: 1,    resultA: 'volcanic', resultB: 'steam', note: 'Lava flash-boils ice' },
  { kind: 'contact', a: 'lava',   b: 'snow',  minTemp: null, chance: 1,    resultA: 'volcanic', resultB: 'steam', note: 'Lava flash-boils snow' },
  { kind: 'contact', a: 'sand',   b: 'lava',  minTemp: null, chance: 0.15, resultA: 'glass',    resultB: 'lava',  note: 'Lava melts sand into glass' },
  { kind: 'contact', a: 'ash',    b: 'water', minTemp: null, chance: 0.25, resultA: 'dirt',     resultB: '',      note: 'Wet ash rots into fresh soil' },
  { kind: 'contact', a: 'gravel', b: 'water', minTemp: null, chance: 0.01, resultA: 'sand',     resultB: 'water', note: 'Water slowly erodes gravel into sand' },
  { kind: 'contact', a: 'moss',   b: 'stone', minTemp: null, chance: 0.02, resultA: 'moss',     resultB: 'moss',  note: 'Moss creeps over stone' },
  { kind: 'contact', a: 'grass',  b: 'dirt',  minTemp: null, chance: 0.02, resultA: 'grass',    resultB: 'grass', note: 'Grass spreads to bare dirt' },
  { kind: 'contact', a: 'steam',  b: 'ice',   minTemp: null, chance: 0.5,  resultA: 'snow',     resultB: 'ice',   note: 'Steam frosts into snow on ice' },
  { kind: 'heat',    a: 'mud',    b: '',      minTemp: 400,  chance: 1,    resultA: 'brick',    resultB: '',      note: 'Mud bakes into brick' },
  { kind: 'heat',    a: 'sand',   b: '',      minTemp: 1700, chance: 1,    resultA: 'glass',    resultB: '',      note: 'Sand vitrifies into glass' },
];

const DATA_VERSION = 2;   // bump when defaults gain new fields/entries → triggers one-time migration

// ── Database wrapper (live-editable, persisted to localStorage) ──
const DB = {
  materials: [],
  reactions: [],
  _byId: {},
  STORE_KEY: 'ashfall_voxel_lab_v1',

  load() {
    let saved = null;
    try { saved = JSON.parse(localStorage.getItem(this.STORE_KEY)); } catch (e) { /* file:// storage blocked or corrupt */ }
    if (saved && Array.isArray(saved.materials) && saved.materials.length) {
      this.materials = saved.materials;
      this.reactions = Array.isArray(saved.reactions) ? saved.reactions : structuredClone(DEFAULT_REACTIONS);
      if ((saved.version ?? 1) < DATA_VERSION) this._migrate();
    } else {
      this.materials = structuredClone(DEFAULT_MATERIALS);
      this.reactions = structuredClone(DEFAULT_REACTIONS);
    }
    this.refresh();
  },

  // One-time upgrade of an older saved DB: fill new fields, append new defaults.
  // Runs only when the saved version is behind, so user deletions stay deleted afterwards.
  _migrate() {
    for (const m of this.materials) {
      if (m.elecCond == null) m.elecCond = ELEC_DEFAULTS[m.id] ?? 0.05;
    }
    for (const dm of DEFAULT_MATERIALS) {
      if (!this.materials.some(m => m.id === dm.id)) this.materials.push(structuredClone(dm));
    }
    for (const r of this.reactions) if (r.chance == null) r.chance = 1;
    const sig = r => [r.kind, r.a, r.b || '', r.resultA || '', r.resultB || ''].join('|');
    const have = new Set(this.reactions.map(sig));
    for (const dr of DEFAULT_REACTIONS) {
      if (!have.has(sig(dr))) this.reactions.push(structuredClone(dr));
    }
    this.save();
  },

  save() {
    try {
      localStorage.setItem(this.STORE_KEY, JSON.stringify({ version: DATA_VERSION, materials: this.materials, reactions: this.reactions }));
    } catch (e) { /* storage unavailable — session-only edits */ }
    // Notify the MCP bridge so server-side state stays in sync
    if (typeof window !== 'undefined' && window.__bridgePush) window.__bridgePush();
  },

  resetToDefaults() {
    try { localStorage.removeItem(this.STORE_KEY); } catch (e) {}
    this.materials = structuredClone(DEFAULT_MATERIALS);
    this.reactions = structuredClone(DEFAULT_REACTIONS);
    this.refresh();
  },

  refresh() {
    this._byId = {};
    this.materials.forEach((m, i) => { if (!m.deleted) this._byId[m.id] = i; });
  },

  byId(id) {
    const i = this._byId[id];
    return i === undefined ? null : this.materials[i];
  },

  indexOf(id) {
    const i = this._byId[id];
    return i === undefined ? -1 : i;
  },

  // Export with Godot .tres property names (null thresholds → 0 sentinel used by voxel_type.gd)
  exportJSON() {
    const mats = this.materials.filter(m => !m.deleted).map(m => ({
      id: m.id,
      display_name: m.name,
      category: m.category,
      description: m.desc,
      phase_state: m.phase,
      melting_point: m.meltPoint ?? 0,
      boiling_point: m.boilPoint ?? 0,
      freezing_point: m.freezePoint ?? 0,
      thermal_conductivity: m.conductivity,
      density: m.density,
      default_temperature: m.defaultTemp,
      state_on_melt: m.onMelt,
      state_on_boil: m.onBoil,
      state_on_freeze: m.onFreeze,
      is_flammable: m.flammable,
      ignition_temperature: m.ignition,
      burn_life_ticks: m.burnLife,
      burn_result: m.burnResult,
      is_granular: m.granular,
      electrical_conductivity: m.elecCond ?? 0,
      color: m.color,
      opacity: m.opacity,
    }));
    const reactions = this.reactions.map(r => ({
      kind: r.kind, a: r.a, b: r.b || '',
      min_temp: r.minTemp ?? 0,
      chance: r.chance ?? 1,
      result_a: r.resultA || '', result_b: r.resultB || '',
      note: r.note || '',
    }));
    return JSON.stringify({ materials: mats, reactions: reactions }, null, 2);
  },
};

function makeNewMaterial(id) {
  return {
    id, name: 'New Material', category: 'custom', color: '#a56cc7', opacity: 1,
    phase: PhaseState.SOLID, defaultTemp: 20, conductivity: 0.5, density: 1.0,
    meltPoint: null, boilPoint: null, freezePoint: null,
    onMelt: '', onBoil: '', onFreeze: '',
    flammable: false, ignition: 300, burnLife: 120, burnResult: 'ash', granular: false,
    elecCond: 0.1,
    desc: 'Describe this material…',
  };
}

// ── Phase logic (mirrors voxel_type.gd::get_phase_at) ──────────
function getPhaseAt(m, t) {
  switch (m.phase) {
    case PhaseState.SOLID:
      if (m.meltPoint != null && t >= m.meltPoint) return PhaseState.LIQUID;
      // Sublimation only when the material has no liquid form
      if (m.meltPoint == null && m.boilPoint != null && t >= m.boilPoint) return PhaseState.GAS;
      return PhaseState.SOLID;
    case PhaseState.LIQUID:
      if (m.boilPoint != null && t >= m.boilPoint) return PhaseState.GAS;
      if (m.freezePoint != null && t <= m.freezePoint) return PhaseState.SOLID;
      return PhaseState.LIQUID;
    case PhaseState.GAS:
      if (m.boilPoint != null && t < m.boilPoint) return PhaseState.LIQUID;
      return PhaseState.GAS;
  }
  return m.phase;
}

// Which material does m become when it shifts to newPhase? null = no transform defined.
function transitionTargetId(m, newPhase) {
  let target = '';
  if (m.phase === PhaseState.SOLID && newPhase === PhaseState.LIQUID) target = m.onMelt;
  else if (m.phase === PhaseState.SOLID && newPhase === PhaseState.GAS) target = m.onBoil;
  else if (m.phase === PhaseState.LIQUID && newPhase === PhaseState.GAS) target = m.onBoil;
  else if (m.phase === PhaseState.LIQUID && newPhase === PhaseState.SOLID) target = m.onFreeze;
  else if (m.phase === PhaseState.GAS) target = m.onFreeze; // condense / deposit
  return target || null;
}

DB.load();
