# AshFall Crafting Progression — Design Document

*Integrating Infinite Craft recipe logic into AshFall's knowledge-gated discovery system.*
*Version 1.0 — 2026-07-13*

---

## 1. The Problem

**Infinite Craft** has no chronological order or progression system. Any element can be combined with any other element from the start. There is no discovery curve — only combinatorial explosion.

**AshFall's design mandate** (from `CODEX-SYSTEMS-DESIGN.md` and `GAMEPLAY-ARCHITECTURE.md`) demands:

> "Crafting is a consequence of understanding materials and processes, not a UI panel."
> "Recipes are locked behind knowledge; the Codex records *why* something works."
> "Knowledge should be earned, not collected."

The integration must transform Infinite Craft's flat recipe graph into AshFall's **knowledge-gated, tiered progression system**.

---

## 2. The Solution: Knowledge-Gated Tiers

### 2.1 Tier Architecture

```
TIER 0 — PRIMORDIAL (found in world)
    Materials collected from the environment.
    No knowledge required to collect.
    Examining these teaches basic properties.
    
TIER 1 — DISCOVERY (first combinations)
    Requires: have collected both inputs.
    No knowledge gate — trial and error works.
    Results teach basic material science concepts.
    
TIER 2 — UNDERSTANDING (knowledge-gated)
    Requires: Tier 1 knowledge node known (Glimpsed or higher).
    Combinations produce refined materials and tools.
    Failed experiments reveal one property of an input.
    
TIER 3 — MASTERY (multi-knowledge-gated)
    Requires: 2+ Tier 2 knowledge nodes.
    Complex materials, alloys, and energized compounds.
    Some require conditions (heat, pressure) at the combine station.
    
TIER 4 — BREAKTHROUGH (story-critical)
    Requires: 3+ Tier 3 knowledge nodes + conditions.
    Resonance Core, Reflective Lens, and other plot-relevant discoveries.
    These unlock new districts, gates, and story events.
```

### 2.2 How It Differs from Infinite Craft

| Infinite Craft | AshFall |
|---|---|
| All elements available from start | Materials must be collected in the world |
| Any two can combine | Gated behind knowledge nodes |
| No progression | Tiered unlocks via Codex confidence |
| AI generates new elements | Fixed, authored reactions |
| No "wrong" combinations | Failed experiments teach properties |
| No spatial context | Combine station is a physical place you visit |

### 2.3 The Knowledge Gate Mechanism

Each reaction in `data/reactions/` already has:
```gdscript
requires_knows: String = ""   # knowledge node_id required
```

The `ExperimentEngine.run()` checks:
1. Do inputs exist in player's inventory?
2. Does the player know `requires_knows` (Codex confidence > 0)?
3. Are conditions met (heat, pressure, etc.)?

If step 2 fails: the game says "You lack the understanding to perform this reaction." The player must go examine things in the world to build Codex confidence.

---

## 3. Tier Mapping: Infinite Craft → AshFall

### 3.1 AshFall's Primordial Materials (= Infinite Craft's Starting Elements)

| AshFall Material | Infinite Craft Analog | Found At |
|---|---|---|
| crystal_shard | 🔥 Fire (resonant crystal) | Crystal Collect (-2, 0, 4) |
| resonance_moss | 💧 Water (resonant moss) | Moss Plaza (8, 0, -2) |
| iron_fragment | 🌍 Earth (metal ore) | Iron Fragment (-8, 0, 10) |
| coal_dust | 🔥 Fire (fuel) | Coal Dust (0, 0, -14) |
| vine_fiber | 🌬️ Wind (plant fiber) | Vine Forest (-6, 0, -4) |
| nectar_sap | 💧 Water (liquid) | Nectar Sap (10, 0, 8) |
| quicksilver_drop | 🌍 Earth (liquid metal) | Quicksilver Drop (-10, 0, -8) |
| clay_deposit | 🌍 Earth (earth) | Clay Deposit (-14, 0, 2) |
| copper_ore | 🌍 Earth (metal ore) | — not placed yet |
| forge_ember | 🔥 Fire (heat source) | — not placed yet |
| obsidian_shard | 🌍 Earth (volcanic glass) | — not placed yet |
| pollen_dust | 🌬️ Wind (powder) | — not placed yet |

### 3.2 Tier Structure (sample)

#### Tier 0 → Tier 1: First Combinations (no gate)

| Input A | Input B | Result | Teaches |
|---|---|---|---|
| crystal_shard | iron_fragment | resonant_alloy | — |
| crystal_shard | coal_dust | charged_gem | — |
| resonance_moss | clay_deposit | resonant_ceramic | — |
| vine_fiber | iron_fragment | reinforced_cable | — |
| copper_ore | iron_fragment | ancient_bronze | — |
| copper_ore | forge_ember | conductive_alloy | — |
| pollen_dust | nectar_sap | growth_elixir | — |
| obsidian_shard | coal_dust | abrasive_paste | — |

#### Tier 2: Knowledge-Gated (requires resonance_basics)

| Input A | Input B | Result | Requires |
|---|---|---|---|
| crystal_shard | nectar_sap | crystal_bloom | resonance_basics |
| crystal_shard | quicksilver_drop | reflective_lens | resonance_basics |
| crystal_shard | resonance_moss + quicksilver_drop | resonance_core | resonance_basics |

#### Tier 3: Multi-Knowledge (requires resonance_basics + conductive_alloy)

| Input A | Input B | Result | Requires |
|---|---|---|---|
| charged_gem | resonant_alloy | resonance_amplifier | resonance_basics + conductive_alloy |
| crystal_bloom | growth_elixir | awakening_essence | resonance_basics + growth_elixir |

---

## 4. Knowledge Node Design

Each tier has a corresponding knowledge node that gates the next tier:

```
resonance_basics (Tier 1)
    "Crystals store and release kinetic energy through lattice vibration."
    Unlocked by: examining crystal_resonant 3 times.
    Unlocks: Tier 2 reactions involving crystal_shard.
    Links to: resonant_alloy, resonance_core

conductive_alloy (Tier 1)
    "Metal alloys can channel both thermal and resonant energy."
    Unlocked by: crafting conductive_alloy.
    Unlocks: Tier 3 reactions involving energy transfer.

growth_elixir (Tier 1)
    "Certain compounds accelerate organic growth patterns."
    Unlocked by: crafting growth_elixir.
    Unlocks: Tier 3 reactions involving biological materials.

resonant_alloy (Tier 2)
    "An alloy that vibrates in sympathy with resonant frequencies."
    Unlocked by: crafting resonant_alloy.
    Links to: resonance_core, resonance_amplifier
```

---

## 5. Failed Experiments as Teaching

Unlike Infinite Craft, AshFall's `ExperimentEngine._record_failure_learning()` ensures that failed combinations are not wasted:

- If a reaction requires knowledge you don't have: "You lack the understanding..."
- If a reaction requires conditions not met: "Missing condition: heat"
- If no reaction exists for those inputs: one input's unknown property is revealed

This means experimentation always teaches something — even failure progresses the Codex.

---

## 6. The Combine Station

The combine station (already in the world at 0, 0, -8) is the physical location where experiments happen. This is intentional:

- You cannot craft from a menu anywhere — you must be at the station
- The station has configurable conditions (heat, pressure) — these are gameplay toggles
- Different stations could exist in different districts with different conditions
- The station UI shows materials from your inventory AND available condition toggles

---

## 7. Integration with the World

### 7.1 Material Placement

Tier 0 materials are placed as collectible objects on the plane. As new districts unlock (Mine, Foundry, Garden), new materials become collectible there.

### 7.2 Gate Unlocks via Knowledge

Existing gates (`shrine_gate`, `cache_gate`, `hidden_path_gate`) already check for knowledge/flags. When you learn `resonance_basics`, the shrine gate opens — revealing new materials and a new combine station with more conditions.

### 7.3 Discovery Events

When a knowledge node reaches VERIFIED or MASTERY confidence, `discovery_events.gd` triggers:
- Brief environmental effect (sunlight flash)
- "A connection forms: [node_name]"
- This is the game telling you: "you understand this now — new things are possible"

---

## 8. Implementation Plan

1. **Generate Tier 1 materials** — 20+ new `.tres` files in `data/materials/`
2. **Generate Tier 1–3 reactions** — 50+ new `.tres` files in `data/reactions/`
3. **Generate knowledge nodes** — 10+ new `.tres` files in `data/codex/`
4. **Update existing reaction gates** — ensure all Tier 2+ reactions have `requires_knows` set
5. **Place Tier 1 result materials** — some as collectibles in newly unlocked areas
6. **Wire knowledge → gate unlocks** — ensure gates open when knowledge is gained

---

*Design by ArchBishop, 2026-07-13*
