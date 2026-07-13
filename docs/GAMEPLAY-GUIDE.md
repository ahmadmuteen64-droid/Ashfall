# AshFall — Gameplay Guide

*How to play, craft, and progress. Version 2026-07-13.*

---

## Controls

| Key | Action |
|---|---|
| S | Move forward |
| W | Move backward |
| A | Strafe left |
| D | Strafe right |
| Space | Jump (air jumps: 2) |
| Shift | Sprint / wall glide |
| E | Interact (examine, collect, activate) |
| J | Open journal |
| Right-click drag | Orbit camera |
| Scroll wheel | Zoom camera |
| V | Swap shoulder (camera) |

---

## Starting Out

You wake up on a large flat plain. Around you are glowing objects scattered across the ground. You have no equipment, no inventory, and no instructions — just your eyes and your curiosity.

### What you see

| Color | Object | What to do |
|---|---|---|
| Cyan glowing sphere | Shrine Test Orb | Walk up, press **E** to examine. Each examination teaches you something new. |
| Purple glowing box | Crystal Resonant | Examine 3 times → unlocks Resonance Basics knowledge |
| Magenta glowing box | Crystal Shard | Press **E** to collect. Goes to your inventory. |
| Green glowing box | Resonance Moss | Collect. Used in experiments. |
| Lime cylinder | Vine Fiber | Collect. Plant fiber material. |
| Orange box | Combine Station | Press **E** to open the experiment UI. This is where you craft. |
| Dark grey box | Iron Fragment | Collect. Metal material. |
| Black sphere | Coal Dust | Collect. Fuel material. |
| Amber sphere | Nectar Sap | Collect. Liquid material. |
| Silver sphere | Quicksilver Drop | Collect. Liquid metal material. |
| Brown box | Clay Deposit | Collect. Earth material. |
| Orange sphere (copper) | Copper Ore | Collect. Metal ore material. |
| Glowing orange sphere | Forge Ember | Collect. Heat source material. |
| Dark glass box | Obsidian Shard | Collect. Volcanic glass material. |
| Golden sphere | Pollen Dust | Collect. Reactive powder material. |

### First actions

1. Walk around and **collect everything** (press E on each glowing object)
2. Find the **Crystal Resonant** (purple box at x=6, z=6) and **examine it 3 times**. This teaches you Resonance Basics.
3. Walk to the **Combine Station** (orange box at x=0, z=-8) and press E.

---

## The Combine Station

The experiment UI has three sections:

### Materials
Shows everything in your inventory. Click items to select/deselect them for the experiment.

### Conditions
Toggle switches for **Heat** and **Pressure**. Some reactions require these to be ON.

### Actions
- **RUN EXPERIMENT** — attempts the combination
- **CLOSE** — exits the station

### How Experiments Work

1. Select 2 (or 3) materials from your inventory
2. Toggle conditions (Heat/Pressure) if needed
3. Click RUN EXPERIMENT
4. If successful → new material appears in your inventory
5. If you lack knowledge → "You lack the understanding to perform this reaction"
6. If conditions wrong → "Missing condition: heat"
7. If no reaction exists → one property of a material is revealed (you still learn something)

---

## Progression Tiers

### Tier 1 — Discovery (no knowledge required)

These work immediately. Just collect the materials and combine at the station.

| Input A | Input B | Result | Notes |
|---|---|---|---|
| crystal_shard | iron_fragment | Resonant Alloy | |
| crystal_shard | coal_dust | Charged Gem | Needs HEAT |
| resonance_moss | clay_deposit | Resonant Ceramic | |
| vine_fiber | iron_fragment | Reinforced Cable | |
| copper_ore | iron_fragment | Ancient Bronze | |
| copper_ore | forge_ember | Conductive Alloy | |
| pollen_dust | nectar_sap | Growth Elixir | |
| obsidian_shard | coal_dust | Abrasive Paste | |
| iron_fragment | forge_ember | Steel Ingot | Needs HEAT |
| clay_deposit | forge_ember | Ceramic Plate | Needs HEAT |
| vine_fiber | vine_fiber | Woven Fabric | |
| coal_dust | coal_dust | Carbon Powder | |

### Tier 2 — Understanding (requires knowledge)

After learning **Resonance Basics** (examine Crystal Resonant 3×), these unlock:

| Input A | Input B | Result | Needs |
|---|---|---|---|
| crystal_shard | nectar_sap | Crystal Bloom | — |
| crystal_shard | quicksilver_drop | Reflective Lens | PRESSURE |
| crystal_shard | resonance_moss + quicksilver_drop | Resonance Core | HEAT + PRESSURE |
| charged_gem | resonant_alloy | Resonance Amplifier | HEAT + PRESSURE |
| resonant_alloy | steel_ingot | Tuned Alloy | — |
| resonant_ceramic | carbon_powder | Insulated Ceramic | — |
| reflective_lens | resonant_alloy | Focusing Lens | PRESSURE |
| growth_elixir | crystal_bloom | Awakening Essence | — |
| conductive_alloy | charged_gem | Power Cell | HEAT |
| steel_ingot | woven_fabric | Armored Mesh | — |
| reinforced_cable | power_cell | Energy Conduit | — |
| ancient_bronze | carbon_powder | Hardened Bronze | HEAT |

### Tier 3 — Mastery (requires multiple knowledge nodes)

After crafting Tier 2 results, their corresponding knowledge nodes unlock:

| Input A | Input B | Result | Requires |
|---|---|---|---|
| resonance_core | focusing_lens | Resonance Prism | resonance_core |
| resonance_amplifier | energy_conduit | Resonance Relay | resonance_amplifier |
| awakening_essence | resonance_core | Living Crystal | awakening_essence |
| power_cell | reflective_lens | Laser Emitter | power_cell |
| tuned_alloy | resonance_prism | Harmonic Alloy | tuned_alloy |
| insulated_ceramic | energy_conduit | Thermal Shield | insulated_ceramic |
| armored_mesh | resonant_ceramic | Resonant Armor | armored_mesh |
| living_crystal | growth_elixir | Crystal Seed | living_crystal |

### Tier 4 — Breakthrough

Endgame crafting. Requires Tier 3 knowledge nodes.

| Input A | Input B | Result |
|---|---|---|
| harmonic_alloy | resonance_relay | Ark Resonator |
| living_crystal | laser_emitter | Crystal Beacon |
| resonance_prism | thermal_shield | Prismatic Barrier |
| crystal_seed | ark_resonator | World Tree Core |

---

## Knowledge System

Knowledge is tracked in the **Codex** (journal). Each concept has a confidence level:

| Level | Name | How to reach |
|---|---|---|
| 0 | Unknown | Not yet encountered |
| 1 | Glimpsed | Observed once |
| 2 | Partial | Observed a few times |
| 3 | Working | Corroborated by multiple sources |
| 4 | Verified | Supported by successful predictions |
| 5 | Mastery | Deeply understood |

You gain knowledge by:
- **Examining** objects in the world (press E on examine-type objects)
- **Collecting** materials (each collection counts as an observation)
- **Failed experiments** (reveal properties of input materials)
- **Successful experiments** (confirm and advance knowledge)

When a knowledge node reaches **Verified (4)** or **Mastery (5)**, a discovery event triggers — the sunlight flashes briefly and you feel a moment of understanding.

---

## Gates & Exploration

Three energy gates block paths on the plane. They open when you gain specific knowledge:

| Gate | Position | Opens when |
|---|---|---|
| Shrine Gate | (0, 0, 8) | You learn **Resonance Basics** |
| Cache Gate | (-8, 0, 6) | You gain **Resonance Lens** |
| Hidden Path Gate | (10, 0, -2) | You gain **Resonance Lens** |

Beyond each gate are new districts with more materials and combine stations.

---

## Discovery Beacons

Three glowing columns mark district boundaries. Walking into them tracks your exploration:

| Beacon | Position | Color |
|---|---|---|
| Mine District | (25, 0, 0) | Gold column |
| Foundry District | (-25, 0, 0) | Red column |
| Garden District | (0, 0, 30) | Teal column |

---

## Tips

- **Examine everything.** The Crystal Resonant is the most important — examine it 3 times.
- **Experiment freely.** Failed experiments still teach you material properties.
- **Toggle conditions.** Some reactions need Heat, Pressure, or both. The station lets you toggle these.
- **Collect duplicates.** You can collect the same material multiple times. Some reactions consume inputs.
- **The cape sways.** Your red cape responds to movement — walk, run, jump, and glide to see different fabric behaviors.
- **Wind appears when gliding.** Sprint into a wall while airborne to glide — white wind particles trail behind you.
- **Orbit the camera.** Right-click drag to look around. Scroll to zoom. Press V to swap shoulders.

---

## World Layout (Top-Down)

```
                        GARDEN DISTRICT (0, 0, 30)
                              [teal beacon]

    POLLEN (12,6)    NECTAR (10,8)
    
                  CRYSTAL RESONANT (6,6) [EXAMINE ×3!]
                  
    CLAY (-14,2)   OBSIDIAN (-6,12)   COPPER (-10,12)
    
                  IRON (-8,10)

    QSILVER (-10,-8)   VINE (-6,-4)    MOSS (8,-2)

           EMBER (-4,-14)   COAL (0,-14)
           
                  STATION (0,-8) [CRAFT HERE]
                  SHRINE ORB (2,2) [EXAMINE]

    FOUNDRY DISTRICT (-25,0)          MINE DISTRICT (25,0)
       [red beacon]                     [gold beacon]
```

---

*Guide compiled 2026-07-13. Updated as the game evolves.*
