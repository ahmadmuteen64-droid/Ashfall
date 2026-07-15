# AshFall Voxel Lab — MCP Server

MCP server for programmatic control of the AshFall Voxel Lab simulation and material database. Lets Claude (and other MCP clients) create/edit materials, run simulations, and export results — no browser required.

## Quick Start

The server is already registered in `~/.claude.json`. It works automatically in new Claude Code sessions.

**Manual test:**
```bash
cd /home/nomi/Desktop/bunyad/gamedev/ashfall2
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}' | node web/mcp/server.js
```

## Architecture

```
Claude Code ←→ stdio ←→ web/mcp/server.js
                              ├── loads data.js + sim.js
                              ├── persist: web/db.json
                              └── (optional) ws://localhost:9138 → bridge.js → browser
```

- **Transport**: JSON-RPC 2.0 over stdio (zero dependencies)
- **Persistence**: `web/db.json` (mirrors browser localStorage)
- **Simulation**: Full VoxelSim engine, same tick pipeline as the browser

## Tools (20 total)

### Materials
| Tool | Description |
|------|-------------|
| `list_materials` | List all non-deleted materials |
| `get_material` | Get one material by ID |
| `create_material` | Create a new material (all properties settable) |
| `edit_material` | Edit properties of an existing material |
| `delete_material` | Soft-delete a custom material |

### Reactions
| Tool | Description |
|------|-------------|
| `list_reactions` | List all reactions with indices |
| `create_reaction` | Create a contact or heat reaction |
| `delete_reaction` | Delete by array index |

### Simulation
| Tool | Description |
|------|-------------|
| `sim_reset` | Create empty grid (4–24³) |
| `sim_set_cell` | Place/clear a single cell |
| `sim_fill_rect` | Fill a cuboid region |
| `sim_advance` | Run N ticks (up to 10,000) |
| `sim_get_state` | Full grid dump (all non-air cells) |
| `sim_get_cell` | Inspect one cell |
| `sim_get_stats` | Aggregate stats (counts, temps, phases) |
| `sim_set_ambient` | Set ambient temperature |
| `sim_strike` | Heat/freeze/zap at a position |
| `sim_load_demo` | Load the built-in demo scene |

### Scenarios + Export
| Tool | Description |
|------|-------------|
| `scenario_save` | Save DB + sim state to file |
| `scenario_load` | Restore a saved scenario |
| `scenario_list` | List saved scenarios |
| `scenario_delete` | Delete a scenario |
| `export_godot_json` | Export in Godot .tres field names |

## Example Usage

**Create a material and test it:**
```
sim_reset({ n: 8 })
create_material({ id: "copper_ore", name: "Copper Ore", category: "mineral", meltPoint: 1085, conductivity: 0.7, color: "#b87333" })
sim_fill_rect({ x1: 2, y1: 0, z1: 2, x2: 5, y2: 3, z2: 5, matId: "copper_ore" })
sim_set_ambient({ temp: 20 })
sim_set_cell({ x: 3, y: 4, z: 3, matId: "lava" })
sim_advance({ ticks: 100 })
sim_get_stats()
```

**Run 500-tick experiment:**
```
sim_load_demo()
sim_advance({ ticks: 500 })
sim_get_stats()
```

**Add a new reaction:**
```
create_reaction({ kind: "contact", a: "copper_ore", b: "lava", chance: 0.5, resultA: "lava", resultB: "lava", note: "Copper melts on lava contact" })
```

## Browser Sync (optional)

Run the bridge to keep the browser UI in sync with MCP mutations:

```bash
node web/mcp/bridge.js &
```

Then open `web/index.html` in a browser. Changes made via MCP tools will appear live in the browser, and changes made in the browser UI will sync back to the MCP server.

## Files

| File | Purpose |
|------|---------|
| `web/mcp/server.js` | MCP stdio server (~600 lines) |
| `web/mcp/bridge.js` | WebSocket relay for browser sync (~150 lines) |
| `web/db.json` | Auto-created persistence file |
| `web/scenarios/` | Saved scenario files |

## Verification

```bash
# Tests
node web/test.js                           # 30/30 simulation tests

# MCP server smoke test
echo '{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}' \
  | node web/mcp/server.js | head -1 | node -e "process.stdin.on('data',d=>{const r=JSON.parse(d);console.log(r.result.tools.length+' tools')})"
```
