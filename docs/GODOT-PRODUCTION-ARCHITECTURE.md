# Aperture — Godot Production Architecture

*Complete technical architecture for the Ark of Genesis and all future content. Defines folder hierarchy, scene composition, naming conventions, loading strategy, performance rules, and AI-friendly organization. Every artist, designer, programmer, and automated agent works within this structure.*

**Classification:** AAA Studio Internal — Technical Directorate
**Version:** 1.0
**Date:** 2026-07-08
**Engine Target:** Godot 4.7+ (GL Compatibility renderer, forward+ for production)
**Authors:** ArchBishop (Technical Art Director, Lead Godot Architect, Senior Level Designer, Environment Pipeline Engineer, Production Director), by order of Lord Commander Ahmad

**Parent Documents:**
- [[ARK-OF-GENESIS-ISLAND-BLUEPRINT]]
- [[ARK-OF-GENESIS-TOPOGRAPHY]]
- [[ARK-OF-GENESIS-TRAVERSAL-BLUEPRINT]]
- [[ARK-OF-GENESIS-DISTRICT-DESIGN]]
- [[ARK-OF-GENESIS-RESOURCE-ECOLOGY]]
- [[ARK-OF-GENESIS-LANDMARK-CATALOGUE]]
- [[GAMEPLAY-ARCHITECTURE]]
- [[WORLD-SIMULATION-DESIGN]]

---

## TABLE OF CONTENTS

1. [Architecture Principles](#1-architecture-principles)
2. [Complete Folder Hierarchy](#2-complete-folder-hierarchy)
3. [Scene Hierarchy — The Island Tree](#3-scene-hierarchy--the-island-tree)
4. [District Scene Specifications](#4-district-scene-specifications)
5. [Landmark Scene Specifications](#5-landmark-scene-specifications)
6. [Resource Node Library](#6-resource-node-library)
7. [Prop Library](#7-prop-library)
8. [Vegetation System](#8-vegetation-system)
9. [Environment Systems](#9-environment-systems)
10. [Lighting Architecture](#10-lighting-architecture)
11. [Audio Architecture](#11-audio-architecture)
12. [Data Architecture](#12-data-architecture)
13. [Naming Conventions](#13-naming-conventions)
14. [Loading & Streaming Strategy](#14-loading--streaming-strategy)
15. [Performance Architecture](#15-performance-architecture)
16. [Multiplayer Synchronization Architecture](#16-multiplayer-synchronization-architecture)
17. [AI-Friendliness Specification](#17-ai-friendliness-specification)
18. [Dependency Graph](#18-dependency-graph)
19. [Scene Boundaries & Ownership](#19-scene-boundaries--ownership)
20. [Production Pipeline](#20-production-pipeline)

---

## 1. ARCHITECTURE PRINCIPLES

### 1.1 — The Prime Directive

**Every scene is independently loadable, testable, and replaceable.** No scene shall depend on its parent being in a specific state. No scene shall assume it is the only instance of its type. No scene shall communicate with anything outside its own subtree except through the defined data interfaces.

### 1.2 — The Eight Architecture Rules

| Rule | What It Means | Why It Exists |
|------|---------------|---------------|
| **Modularity** | Every scene is a self-contained unit with explicit dependencies declared at its root | Artists can work on districts in parallel. AI agents can modify scenes without understanding the full project. |
| **Single Responsibility** | Each scene does ONE thing — terrain OR props OR lighting, never all three | Prevents monolithic scenes that are impossible to debug, diff, or delegate |
| **Composition Over Inheritance** | Complex scenes are built by composing simpler scenes, not by extending base classes | Scene inheritance in Godot is fragile across renames and restructures. Composition is robust. |
| **Flat Over Deep** | Maximum nesting depth: 4 levels. Target: 3 levels | Deep hierarchies are hard to navigate, hard to serialize, and hard for AI to reason about |
| **Data-Driven** | Scene behavior is configured through resource files (.tres), not hardcoded in scripts | Designers can tune without programmers. AI can modify data without touching logic. |
| **Predictable Naming** | Names follow strict conventions. A file's name communicates its type, its content, and its place in the hierarchy | grep, find, and AI agents can locate any file without reading directory listings |
| **Lazy Loading** | Nothing loads until it is needed. Everything unloads when it is not | 100+ islands cannot fit in memory simultaneously. The player only experiences one at a time. |
| **Forward-Compatible** | Every scene includes placeholder nodes for future systems. Interfaces are versioned | The game will grow. The architecture must accommodate content that doesn't exist yet |

### 1.3 — The Folder = Scene Principle

Every folder under `scenes/` that represents a spatial entity (island, district, landmark) corresponds to exactly one `.tscn` file at that folder's root. The folder contains all assets unique to that entity. Shared assets live in `assets/`. This means you can copy a district folder to a new island and it will work — all its dependencies are either self-contained or referenced through the shared asset library.

---

## 2. COMPLETE FOLDER HIERARCHY

### 2.1 — Root Structure

```
aperture/                          # Project root
│
├── project.godot                  # Engine configuration
├── icon.svg                       # Project icon
│
├── scenes/                        # ALL scene files (.tscn)
│   ├── world/                     #   Island scenes and their children
│   ├── player/                    #   Player character and controllers
│   ├── ui/                        #   All user interface
│   ├── systems/                   #   Singleton system scenes (autoloads)
│   └── _test/                     #   Test scenes (not shipped)
│
├── assets/                        # ALL shared assets
│   ├── meshes/                    #   3D models (.glb, .blend, .obj)
│   ├── materials/                 #   Material definitions (.tres)
│   ├── textures/                  #   Image files and texture resources
│   ├── animations/                #   Animation libraries (.anim, .tres)
│   ├── audio/                     #   Sound files and audio buses
│   ├── fonts/                     #   Typography
│   └── _dev/                      #   Placeholder/blockout assets (not shipped)
│
├── scripts/                       # ALL GDScript/C# files (.gd, .cs)
│   ├── autoloads/                 #   Scripts attached to autoload scenes
│   ├── components/                #   Reusable component scripts
│   ├── resources/                 #   Custom Resource class definitions
│   ├── systems/                   #   System logic (not scene-specific)
│   ├── multiplayer/               #   Network code
│   └── _dev/                      #   Debug/development scripts
│
├── data/                          # ALL data resource files (.tres)
│   ├── resources/                 #   Resource definitions
│   ├── districts/                 #   District configuration
│   ├── landmarks/                 #   Landmark configuration
│   ├── spawns/                    #   Spawn tables and loot tables
│   ├── codex/                     #   Codex entry data
│   ├── dialogue/                  #   NPC speech data
│   ├── quests/                    #   Quest/mission definitions
│   ├── simulation/                #   World simulation parameters
│   ├── navigation/                #   NavMesh and pathfinding data
│   └── multiplayer/               #   Network configuration
│
├── shaders/                       # ALL shader files (.gdshader)
│   ├── environment/               #   Sky, water, fog, weather
│   ├── materials/                 #   PBR material shaders
│   ├── vegetation/                #   Plant wind/interaction shaders
│   ├── postprocess/               #   Screen-space effects
│   └── debug/                     #   Development visualization
│
├── docs/                          # Design documents (NOT shipped)
│
├── addons/                        # Godot plugins
│   └── godot_ai/                  #   Godot AI MCP plugin
│
├── .godot/                        # Engine cache (gitignored)
├── .gitignore
├── .editorconfig
└── .gitattributes
```

### 2.2 — World Folder (Deep Expansion)

```
scenes/world/
│
├── world_root.tscn                # The root world scene — contains nothing but
│                                  #   child scenes and environment systems
│
├── ark_genesis/                   # Island: Ark of Genesis (tutorial island)
│   ├── ark_genesis.tscn           #   Island root — loads all district scenes
│   ├── terrain/                   #   Terrain mesh scenes
│   │   ├── ark_terrain_base.tscn  #     The island's structural slab
│   │   ├── ark_terrain_soil.tscn  #     Accumulated soil layer
│   │   └── ark_terrain_edge.tscn  #     Perimeter/underside geometry
│   │
│   ├── districts/                 #   District scenes (one per district)
│   │   ├── atrium/                #     District: The Atrium
│   │   ├── gatehouse/             #     District: The Gatehouse
│   │   ├── cascade_gardens/       #     District: The Cascade Gardens
│   │   ├── verdant_creep/         #     District: The Verdant Creep
│   │   ├── living_quarters/       #     District: The Living Quarters
│   │   ├── aviary/                #     District: The Aviary
│   │   ├── celestial_ring/        #     District: The Celestial Ring
│   │   └── stasis_sanctum/        #     District: The Stasis Sanctum
│   │
│   ├── landmarks/                 #   Landmark scenes (one per landmark)
│   │   ├── shattered_dome/
│   │   ├── courtyard_tree/
│   │   ├── ring_platform/
│   │   ├── great_table/
│   │   ├── departure_platform/
│   │   ├── central_reservoir/
│   │   ├── grand_archway/
│   │   ├── great_telescope/
│   │   ├── instrument_tree/
│   │   ├── standing_stones/
│   │   ├── sanctum_entrance/
│   │   ├── hollow_dome/
│   │   ├── fountain/
│   │   ├── dome_fragments_floor/
│   │   ├── fungal_grotto_entrance/
│   │   ├── memory_garden_flower/
│   │   ├── director_window/
│   │   ├── empty_chamber/
│   │   ├── quarantine_windows/
│   │   └── music_box/
│   │
│   ├── resources/                 #   Resource node instances (placer scene)
│   │   └── ark_resource_placer.tscn  # Contains instanced resource nodes
│   │
│   ├── vegetation/                #   Vegetation node instances
│   │   └── ark_vegetation.tscn    #     Contains MultimeshInstance nodes
│   │
│   ├── water/                     #   Water bodies specific to this island
│   │   ├── central_reservoir_water.tscn
│   │   ├── irrigation_channels.tscn
│   │   ├── settling_pools.tscn
│   │   └── fountain_water.tscn
│   │
│   ├── effects/                   #   Island-specific visual effects
│   │   ├── prismatic_dome_light.tscn
│   │   ├── bioluminescence.tscn
│   │   └── crystal_glow.tscn
│   │
│   ├── lighting/                  #   Island-specific lighting
│   │   └── ark_lighting.tscn      #     Light nodes, LightmapGI data
│   │
│   ├── audio/                     #   Island-specific audio emitters
│   │   └── ark_audio.tscn        #     AudioStreamPlayer3D nodes
│   │
│   ├── navigation/                #   Island navigation data
│   │   └── ark_navigation.tscn   #     NavigationRegion3D
│   │
│   └── npc/                       #   NPC spawn points and patrol paths
│       └── ark_npc_spawns.tscn
│
├── resonance_foundry/             # Island: Resonance Foundry (future)
├── [future_island_slug]/          # Pattern repeats for each island
│   └── ...
│
└── _shared/                       # Shared world elements
    ├── environment/               #   Sky, clouds, weather (shared across islands)
    │   ├── sky.tscn
    │   ├── clouds.tscn
    │   ├── weather_controller.tscn
    │   └── wind_system.tscn
    │
    ├── systems/                   #   Shared gameplay systems
    │   ├── interaction_manager.tscn
    │   ├── time_manager.tscn
    │   └── spawn_manager.tscn
    │
    └── templates/                 #   Base scenes that islands inherit from
        ├── island_base.tscn       #     What every island must have
        ├── district_base.tscn     #     What every district must have
        └── landmark_base.tscn     #     What every landmark must have
```

### 2.3 — Assets Folder (Deep Expansion)

```
assets/
│
├── meshes/
│   ├── architecture/              # Building components
│   │   ├── first_delver/          #   Golden Age style
│   │   │   ├── walls/
│   │   │   ├── floors/
│   │   │   ├── pillars/
│   │   │   ├── arches/
│   │   │   ├── domes/
│   │   │   ├── stairs/
│   │   │   ├── bridges/
│   │   │   └── platforms/
│   │   └── _blockout/             #   Greybox meshes
│   │
│   ├── terrain/                   # Terrain meshes
│   │   ├── island_slab.glb        #   The structural slab (shared across islands)
│   │   ├── soil_layers.glb        #   Soil accumulation meshes
│   │   └── edge_variants/         #   Perimeter edge variants
│   │
│   ├── vegetation/                # Plant meshes
│   │   ├── trees/
│   │   │   ├── courtyard_tree/    #   Unique hero tree
│   │   │   ├── canopy_oak/        #   Atrium canopy trees
│   │   │   └── specimen_trees/    #   Aviary collection trees
│   │   ├── shrubs/
│   │   ├── grasses/
│   │   ├── flowers/
│   │   ├── vines/
│   │   ├── moss/
│   │   └── fungi/
│   │
│   ├── props/                     # Small reusable objects
│   │   ├── laboratory/
│   │   ├── furniture/
│   │   ├── containers/
│   │   ├── tools/
│   │   ├── books/
│   │   └── debris/
│   │
│   ├── resources/                 # Resource node meshes
│   │   ├── stone/
│   │   ├── crystals/
│   │   ├── plants/
│   │   └── artifacts/
│   │
│   ├── landmarks/                 # Landmark-specific hero meshes
│   │   ├── shattered_dome/
│   │   ├── great_table/
│   │   ├── great_telescope/
│   │   └── ...
│   │
│   ├── water/                     # Water meshes and VFX
│   └── effects/                   # Particle systems, decals
│
├── materials/
│   ├── architecture/
│   │   └── first_delver/
│   │       ├── stone_composite.tres
│   │       ├── stone_weathered.tres
│   │       ├── stone_interior.tres
│   │       ├── iron_rusted.tres
│   │       ├── brass_patina.tres
│   │       ├── crystal_charged.tres
│   │       ├── crystal_discharged.tres
│   │       └── amber_glass.tres
│   │
│   ├── terrain/
│   │   ├── soil_basin.tres
│   │   ├── soil_slope.tres
│   │   └── soil_summit.tres
│   │
│   ├── vegetation/                # Bark, leaf, flower materials
│   └── resources/                 # Resource-specific materials
│
├── textures/
│   ├── architecture/
│   ├── terrain/
│   ├── vegetation/
│   ├── vfx/
│   └── _dev/                      # Checker patterns, grid textures
│
├── animations/
│   ├── player/
│   ├── npc/
│   ├── creatures/
│   ├── environment/               # Animated water, foliage, machinery
│   └── props/                     # Animated doors, devices
│
├── audio/
│   ├── ambience/                  # Looping ambient beds
│   ├── sfx/                       # One-shot sound effects
│   ├── music/                     # Musical compositions
│   ├── foley/                     # Player movement sounds
│   └── voice/                     # (Minimal — no dialogue in core design)
│
└── fonts/
    └── journal_font.ttf
```

---

## 3. SCENE HIERARCHY — THE ISLAND TREE

### 3.1 — Why Not One Giant Scene?

A single scene containing the entire Ark of Genesis would be:
- **Unmergeable** — no two people can work on it simultaneously without conflicts
- **Unreviewable** — diffs would be thousands of lines of serialized node data
- **Unloadable** — the entire island must be in memory even when the player is in one district
- **AI-hostile** — no agent can reason about a 50,000-line `.tscn` file
- **Fragile** — a single corrupted node crashes the entire island

Instead, the island is a **tree of composed scenes**. The root scene loads child scenes. Each child is independently editable, testable, and replaceable.

### 3.2 — The Island Scene Tree

```
world_root.tscn                              # Root of the entire game world
│
├── [_shared/environment/sky.tscn]           # Shared sky (always loaded)
├── [_shared/environment/clouds.tscn]        # Shared clouds (always loaded)
├── [_shared/environment/weather_controller.tscn]  # Weather (always loaded)
├── [_shared/systems/time_manager.tscn]      # Day/night (always loaded)
├── [_shared/systems/interaction_manager.tscn]  # Player interaction (always loaded)
│
└── ark_genesis/ark_genesis.tscn             # Ark of Genesis island
    │
    ├── terrain/ark_terrain_base.tscn        # Structural slab (LOD0–LOD3)
    ├── terrain/ark_terrain_soil.tscn        # Soil layer (visible above slab)
    ├── terrain/ark_terrain_edge.tscn        # Perimeter and underside
    │
    ├── districts/atrium/atrium.tscn         # District root scenes
    ├── districts/gatehouse/gatehouse.tscn
    ├── districts/cascade_gardens/cascade_gardens.tscn
    ├── districts/verdant_creep/verdant_creep.tscn
    ├── districts/living_quarters/living_quarters.tscn
    ├── districts/aviary/aviary.tscn
    ├── districts/celestial_ring/celestial_ring.tscn
    ├── districts/stasis_sanctum/stasis_sanctum.tscn
    │
    ├── landmarks/                           # Hero landmark instances
    │   ├── shattered_dome/shattered_dome.tscn
    │   ├── courtyard_tree/courtyard_tree.tscn
    │   ├── ring_platform/ring_platform.tscn
    │   └── ...                              # (all 20 landmarks)
    │
    ├── resources/ark_resource_placer.tscn   # Resource node instances
    ├── vegetation/ark_vegetation.tscn       # Multimesh vegetation
    ├── water/                               # Water bodies
    ├── effects/                             # Island-specific VFX
    ├── lighting/ark_lighting.tscn           # Island lights + lightmap
    ├── audio/ark_audio.tscn                 # Island audio emitters
    ├── navigation/ark_navigation.tscn       # NavRegion
    └── npc/ark_npc_spawns.tscn              # NPC spawn points
```

### 3.3 — Scene Loading Order

Scenes load in a defined sequence to avoid visual popping:

```
Phase 0 (Always):    world_root, sky, clouds, weather, time, interaction
Phase 1 (Stream):    island terrain (lowest LOD first, then refine)
Phase 2 (Stream):    district shells (bounding geometry, portals, occlusion)
Phase 3 (Stream):    landmarks within the player's district
Phase 4 (Deferred):  resources, vegetation within view range
Phase 5 (Deferred):  water, effects, audio within view range
Phase 6 (Background): NPC spawns, navigation data
```

The player never sees "nothing." Phase 0 is always present. Phase 1 provides the silhouette. Phase 2 provides the spatial structure. By the time the player can move, Phases 0–2 are complete. Phases 3–6 load asynchronously.

### 3.4 — How Scenes Reference Each Other

Scenes do NOT contain hard paths to other scenes. Instead:

1. **The island root scene** (`ark_genesis.tscn`) is the ONLY scene that knows about ALL child scenes. It contains `PackedScene` references to every district, landmark, and system scene it composes.
2. **District scenes** contain `Node` placeholders with specific names. The island root instantiates landmarks and props into these placeholders at load time.
3. **Landmark scenes** are self-contained — they reference only shared meshes and materials from `assets/`.
4. **Resource scenes** are self-contained and instanced via `MultiMeshInstance3D` or a placer script.

This means: you can delete a district scene and the island still loads (the placeholder is empty). You can replace a landmark with a blockout mesh and everything still works. The island root is the single point of assembly.

---

## 4. DISTRICT SCENE SPECIFICATIONS

### 4.1 — District Base Template

Every district scene inherits this structure. The `district_base.tscn` template ensures consistency.

```
district_base.tscn                           # Template — never instanced directly
│
├── DistrictRoot (Node3D)                    # Named: {district_slug}_root
│   ├── Metadata (Node)                      #   District identity data
│   │   ├── DistrictName (String)            #     "The Atrium"
│   │   ├── DistrictSlug (String)            #     "atrium"
│   │   ├── ElevationRange (Vector2)         #     (5.0, 12.0)
│   │   └── BoundingBox (AABB)              #     Spatial bounds
│   │
│   ├── Geometry (Node3D)                    #   Static visual geometry
│   │   ├── Architecture (Node3D)            #     Walls, floors, structural
│   │   │   ├── Structural                  #       Load-bearing — never culled
│   │   │   └── Detail                      #       Decorative — distance culled
│   │   ├── TerrainBlend (Node3D)            #     Where district meets terrain
│   │   └── Collision (StaticBody3D)         #     Walkable surfaces, walls
│   │
│   ├── Landmarks (Node3D)                   #   Placeholder for landmark scenes
│   │   ├── Placeholder_T1                   #     Named slots for each landmark
│   │   ├── Placeholder_T2                   #     Instanced by island root
│   │   └── Placeholder_T3
│   │
│   ├── Props (Node3D)                       #   Reusable prop instances
│   │
│   ├── VegetationAnchor (Node3D)            #   Where Multimesh vegetation attaches
│   │
│   ├── ResourcePoints (Node3D)              #   Where resource nodes spawn
│   │
│   ├── InteractionPoints (Node3D)            #   Where interactive objects live
│   │
│   ├── LightingLocal (Node3D)               #   District-specific lights
│   │
│   ├── AudioLocal (Node3D)                  #   District-specific audio
│   │
│   ├── Portals (Node3D)                     #   Connections to other districts
│   │   ├── Portal_North                     #     Named directional portals
│   │   ├── Portal_South
│   │   ├── Portal_East
│   │   ├── Portal_West
│   │   ├── Portal_Up
│   │   └── Portal_Down
│   │
│   └── ExpansionHooks (Node3D)              #   Placeholder nodes for future content
│       ├── Hook_LockedDoor
│       ├── Hook_CollapsedPassage
│       └── Hook_FutureSystem
```

### 4.2 — Individual District Specifications

#### DISTRICT: The Atrium

| Field | Value |
|-------|-------|
| **Scene Name** | `atrium.tscn` |
| **Scene Path** | `scenes/world/ark_genesis/districts/atrium/atrium.tscn` |
| **Purpose** | Central hub. Player awakening point. Radial connector to all other districts. |
| **Dependencies** | `assets/meshes/architecture/first_delver/` — walls, pillars, domes. `district_base.tscn` template. |
| **Landmark Children** | Shattered Dome (T1), Great Table (T2), Fountain (T3), Dome Fragments Floor (T3) |
| **Portal Count** | 5 exits: North (Cascade Gardens), Northeast (Aviary), Northwest (Living Quarters), South (Gatehouse), Southeast (Verdant Creep) |
| **Reusable Components** | Pillar set, dome ring, floor slab tiles, alcove prefabs, wall sections |
| **Estimated Object Count** | ~200 static mesh nodes + 4 landmark scenes |
| **Loading Strategy** | Phase 1 (always first — player awakens here). Full detail at load. Adjacent districts stream in Phase 2. |
| **Lighting Notes** | Prismatic dome light is the primary illumination. LightmapGI baked for static surfaces. Dynamic light from dome crystal fragments. |

#### DISTRICT: The Gatehouse

| Field | Value |
|-------|-------|
| **Scene Name** | `gatehouse.tscn` |
| **Scene Path** | `scenes/world/ark_genesis/districts/gatehouse/gatehouse.tscn` |
| **Purpose** | Arrival/departure terminal. First revelation (floating island). Resource provenance introduction. |
| **Dependencies** | `assets/meshes/architecture/first_delver/` — walls, platforms. `district_base.tscn` template. |
| **Landmark Children** | Departure Platform (T2), Quarantine Windows (T3) |
| **Portal Count** | 3 exits: North (Atrium), East (Verdant Creep lower), West (Collapsed Bridge — locked) |
| **Reusable Components** | Cargo cradles, reception desk module, door frame variants, quarantine station shell |
| **Estimated Object Count** | ~120 static mesh nodes + 2 landmark scenes |
| **Loading Strategy** | Phase 2. Loads after Atrium. The Departure Platform extends beyond the island edge — requires special culling (never occlude the platform view). |

#### DISTRICT: The Cascade Gardens

| Field | Value |
|-------|-------|
| **Scene Name** | `cascade_gardens.tscn` |
| **Scene Path** | `scenes/world/ark_genesis/districts/cascade_gardens/cascade_gardens.tscn` |
| **Purpose** | Resource ecology tutorial. Collection system introduction. Water system comprehension. |
| **Dependencies** | `assets/meshes/terrain/` — terrace retaining walls. `district_base.tscn` template. `scenes/world/ark_genesis/water/` — channels, reservoir, pools. |
| **Landmark Children** | Central Reservoir (T2), Instrument Tree (visible from upper terraces — T2, owned by Verdant Creep) |
| **Portal Count** | 4 exits: South (Atrium), East (Verdant Creep upper), North (Living Quarters), Northeast (Aviary) |
| **Reusable Components** | Terrace wall segments, channel pieces, sluice gate prefab, settling pool modules, planting bed templates |
| **Estimated Object Count** | ~300 static mesh nodes + vegetation Multimesh (~2000 instances) |
| **Loading Strategy** | Phase 2. Terraces load bottom-to-top (following water flow). Vegetation populates via Multimesh after geometry. |

#### DISTRICT: The Verdant Creep

| Field | Value |
|-------|-------|
| **Scene Name** | `verdant_creep.tscn` |
| **Scene Path** | `scenes/world/ark_genesis/districts/verdant_creep/verdant_creep.tscn` |
| **Purpose** | Boundary-pushing tutorial. Decomposition resource hub. Hidden systems introduction. |
| **Dependencies** | `assets/meshes/vegetation/` — high-density foliage. `district_base.tscn` template. |
| **Landmark Children** | Instrument Tree (T2), Hollow Dome (T2), Fungal Grotto Entrance (T3) |
| **Portal Count** | 3 exits: Northwest (Atrium), West (Gatehouse lower), North (Cascade Gardens upper) |
| **Reusable Components** | Dome framework remnants, vine-covered wall segments, fungal colony prefabs, root network meshes |
| **Estimated Object Count** | ~150 static mesh nodes + vegetation Multimesh (~5000 instances — highest density on island) |
| **Loading Strategy** | Phase 2 (shell). Vegetation streams in progressively as player penetrates deeper. Highest LOD budget on the island — dense canopy requires aggressive culling. |

#### DISTRICT: The Living Quarters

| Field | Value |
|-------|-------|
| **Scene Name** | `living_quarters.tscn` |
| **Scene Path** | `scenes/world/ark_genesis/districts/living_quarters/living_quarters.tscn` |
| **Purpose** | Environmental storytelling masterclass. Personal connection catalyst. Lore deep-dive. |
| **Dependencies** | `assets/meshes/architecture/first_delver/` — interior rooms. `assets/meshes/props/furniture/`. `district_base.tscn` template. |
| **Landmark Children** | Courtyard Tree (T1 — owned by this district but visible island-wide), Director's Window (T3), Music Box (T3) |
| **Portal Count** | 4 exits: Southeast (Atrium), South (Cascade Gardens upper), North (Aviary), East (Celestial Ring) |
| **Reusable Components** | Room modules (single, double, family), corridor segments, door prefabs, window prefabs, furniture set |
| **Estimated Object Count** | ~250 static mesh nodes + ~100 prop instances |
| **Loading Strategy** | Phase 2 (exterior shell, Courtyard Tree). Phase 3 (interior rooms — only load when player enters). Interior rooms are small enough to load instantly on approach. |

#### DISTRICT: The Aviary

| Field | Value |
|-------|-------|
| **Scene Name** | `aviary.tscn` |
| **Scene Path** | `scenes/world/ark_genesis/districts/aviary/aviary.tscn` |
| **Purpose** | Cultivation system introduction. Botanical resource hub. Emotional payoff (hope). |
| **Dependencies** | `assets/meshes/architecture/first_delver/` — iron framework, glasshouse modules. `assets/meshes/vegetation/flowers/`. `district_base.tscn` template. |
| **Landmark Children** | Grand Archway (T2), Memory Garden Flower (T3) |
| **Portal Count** | 5 exits: Southwest (Atrium), South (Cascade Gardens), West (Living Quarters), North (Celestial Ring), East (Verdant Creep upper canopy) |
| **Reusable Components** | Iron arch segments, glasshouse frame modules, specimen bed templates, pollinator hive prefabs, propagation station workbench |
| **Estimated Object Count** | ~200 static mesh nodes + vegetation Multimesh (~1500 flower instances) + animated pollinator particles |
| **Loading Strategy** | Phase 2. Flowers populate via Multimesh. Butterflies/bees are GPU particles — no CPU cost per instance. |

#### DISTRICT: The Celestial Ring

| Field | Value |
|-------|-------|
| **Scene Name** | `celestial_ring.tscn` |
| **Scene Path** | `scenes/world/ark_genesis/districts/celestial_ring/celestial_ring.tscn` |
| **Purpose** | Panoramic revelation. Distant landmark introduction. Resonance system introduction. |
| **Dependencies** | `assets/meshes/architecture/first_delver/` — platform, standing stones. `assets/meshes/landmarks/`. `district_base.tscn` template. |
| **Landmark Children** | Ring Platform (T1 — owned by this district), Standing Stones (T2), Great Telescope (T2) |
| **Portal Count** | 2 exits: Southwest (Aviary), South (Living Quarters), North (Sanctum bridge) |
| **Reusable Components** | Platform surface tiles, stone monolith prefabs, instrument housing modules |
| **Estimated Object Count** | ~100 static mesh nodes + 3 landmark scenes |
| **Loading Strategy** | Phase 2. The 360° view means distant islands must be loaded as impostors/skybox elements. Actual island geometry is NOT loaded — only the Ark is real geometry at this stage. Distant islands are billboard impostors at this distance. |

#### DISTRICT: The Stasis Sanctum

| Field | Value |
|-------|-------|
| **Scene Name** | `stasis_sanctum.tscn` |
| **Scene Path** | `scenes/world/ark_genesis/districts/stasis_sanctum/stasis_sanctum.tscn` |
| **Purpose** | Identity confirmation. Central mystery establishment. Progression goal setting. |
| **Dependencies** | `assets/meshes/architecture/first_delver/` — vault interior. `assets/meshes/props/laboratory/`. `district_base.tscn` template. |
| **Landmark Children** | Sanctum Entrance (T2), Empty Chamber (T3) |
| **Portal Count** | 1 exit: South (Celestial Ring bridge) — the only entrance/exit |
| **Reusable Components** | Stasis chamber modules, data vault shelving, Regulator panel prefab, amber light strips |
| **Estimated Object Count** | ~80 static mesh nodes + 2 landmark scenes + 12 stasis chamber instances |
| **Loading Strategy** | Phase 3. Loads when player crosses the bridge midpoint. Interior-only — no distant visibility needed. Full detail at load (small space, low object count). |

---

## 5. LANDMARK SCENE SPECIFICATIONS

### 5.1 — Landmark Base Template

```
landmark_base.tscn                           # Template — never instanced directly
│
├── LandmarkRoot (Node3D)                    # Named: {landmark_slug}_root
│   ├── Metadata (Node)                      #   Landmark identity
│   │   ├── LandmarkName (String)
│   │   ├── LandmarkSlug (String)
│   │   ├── Tier (int)                       #     1, 2, or 3
│   │   └── OwningDistrict (String)
│   │
│   ├── Visual (Node3D)                      #   Visual hierarchy
│   │   ├── LOD0                            #     Full detail — player within 30m
│   │   ├── LOD1                            #     Medium detail — 30–100m
│   │   ├── LOD2                            #     Low detail — 100–300m
│   │   └── Impostor                        #     Billboard — beyond 300m or other islands
│   │
│   ├── Collision (StaticBody3D)             #   Walkable surfaces, barriers
│   │
│   ├── InteractionPoints (Node3D)            #   Examinable, collectible, interactive
│   │   ├── Interaction_Primary              #     Main interaction (telescope: look through)
│   │   ├── Interaction_Secondary            #     Secondary (telescope: examine mount)
│   │   └── Interaction_Hidden               #     Discoverable only (telescope: hidden inscription)
│   │
│   ├── MemoryTriggers (Node3D)              #   Areas that trigger memory fragments
│   │   └── Trigger_{fragment_name}
│   │
│   ├── AudioLocal (Node3D)                  #   Landmark-specific audio emitters
│   │
│   ├── EffectsLocal (Node3D)                #   Landmark-specific particles/shaders
│   │
│   └── ExpansionNodes (Node3D)              #   Future content attachment points
│       ├── Future_Restored                  #     Node for restored/repaired version
│       └── Future_Upgrade                   #     Node for upgraded capability
```

### 5.2 — Landmark LOD Strategy

| Tier | LOD0 Range | LOD1 Range | LOD2 Range | Impostor | Notes |
|------|-----------|-----------|-----------|----------|-------|
| **T1** | 0–50m (hero detail) | 50–200m | 200–500m (other islands) | 500m+ | Always visible from somewhere. Highest LOD budget. |
| **T2** | 0–30m | 30–150m | 150m+ | Not needed (island-scale only) | Visible from multiple districts. |
| **T3** | 0–15m | Not needed | Not needed | Not needed | Interior or local only. Single LOD. |

### 5.3 — Selected Landmark Examples

#### Shattered Dome (T1)

```
shattered_dome.tscn
│
├── ShatteredDomeRoot (Node3D)
│   ├── Visual/
│   │   ├── LOD0/
│   │   │   ├── StructuralRing (MeshInstance3D)        # The dome's stone ring
│   │   │   ├── FloatingPanels (Node3D)                # Parent for crystal panels
│   │   │   │   ├── Panel_01–Panel_30 (MeshInstance3D) # Each panel is a separate mesh
│   │   │   │   └── ...                                #   (allows individual drift animation)
│   │   │   └── CrystalShards_Floor (Node3D)           # Fallen fragments on Atrium floor
│   │   ├── LOD1/
│   │   │   ├── StructuralRing_Med (MeshInstance3D)    # Reduced panel count (15 panels)
│   │   │   └── Panels_Combined (MultiMeshInstance3D)  # Batched panels
│   │   ├── LOD2/
│   │   │   └── DomeSilhouette (MeshInstance3D)        # Simplified dome shape
│   │   └── Impostor/
│   │       └── DomeBillboard (Sprite3D)               # Flat billboard for distant views
│   │
│   ├── Collision/
│   │   ├── StructuralRing_Body (StaticBody3D)
│   │   └── FloorShards_Body (StaticBody3D)            # Walkable large shards
│   │
│   ├── InteractionPoints/
│   │   ├── Interaction_DomeView                      # Look up → Journal trigger
│   │   └── Interaction_CollectShard                   # Small shards → collectible
│   │
│   ├── MemoryTriggers/
│   │   └── Trigger_DomeAtNight                        # Stand beneath dome at night
│   │
│   ├── AudioLocal/
│   │   ├── ResonanceHum (AudioStreamPlayer3D)          # Multi-layered crystal hum
│   │   └── CrystalChimes (AudioStreamPlayer3D)         # Occasional contact sounds
│   │
│   └── EffectsLocal/
│       ├── PrismaticLight (GPUParticles3D)             # Light scattering through crystal
│       └── CrystalGlow (ShaderMaterial overlay)        # Charged panel glow
```

**Collision design:** The structural ring and large floor shards have collision (the player can stand on them). Floating panels DO NOT have collision — they are visual only. The player cannot reach them without late-game flight.

**Future expansion nodes:**
- `Future_Restored/` — contains the restored dome geometry (all 60 panels aligned, no gaps). Swapped in when the player completes the dome restoration project.
- `Future_TetherPoints/` — interactive nodes for the resonance tuning puzzle. Each tether point becomes an interaction target.

#### Courtyard Tree (T1)

```
courtyard_tree.tscn
│
├── CourtyardTreeRoot (Node3D)
│   ├── Visual/
│   │   ├── LOD0/
│   │   │   ├── Trunk (MeshInstance3D)                  # Hero trunk mesh with carvings
│   │   │   ├── MajorBranches (Node3D)                 # 8–12 major branch meshes
│   │   │   ├── Canopy_Inner (MultiMeshInstance3D)     # Inner leaves (high detail)
│   │   │   ├── Roots (Node3D)                         # Exposed root meshes
│   │   │   └── NestColony (Node3D)                    # Bird nest clusters
│   │   ├── LOD1/
│   │   │   ├── Trunk_Med (MeshInstance3D)
│   │   │   ├── Canopy_Outer (MultiMeshInstance3D)     # Outer leaves (medium detail)
│   │   │   └── Roots_Simplified (MultiMeshInstance3D)
│   │   └── LOD2/
│   │       ├── TreeSilhouette (MeshInstance3D)         # Trunk + billboard canopy
│   │       └── Canopy_Impostor (Sprite3D)
│   │
│   ├── Collision/
│   │   ├── Trunk_Body (StaticBody3D)
│   │   ├── MajorRoots_Body (StaticBody3D)             # Walkable root surfaces
│   │   └── ClimbableBranches (Node3D)                 # Empty until late-game — then climbable
│   │
│   ├── InteractionPoints/
│   │   ├── Interaction_ExamineTrunk                    # Read children's carvings
│   │   ├── Interaction_CollectBark                     # Harvest medicinal bark
│   │   ├── Interaction_PlantingPlaque                  # Buried plaque at base
│   │   └── Interaction_ClimbStart                      # Late-game climb point
│   │
│   ├── MemoryTriggers/
│   │   ├── Trigger_TreeDay                             # Find the planting plaque
│   │   └── Trigger_Goodbye                             # Examine children's carvings
│   │
│   └── AudioLocal/
│       ├── WindThroughLeaves (AudioStreamPlayer3D)
│       ├── BirdSong (AudioStreamPlayer3D)              # Nest colony calls
│       └── BranchCreak (AudioStreamPlayer3D)           # Occasional structural sound
```

**Collision design:** The trunk and major roots have collision. The canopy does not (except for designated climbable branches in late game). The tree is an obstacle you walk around, not through.

**Future expansion nodes:**
- `Future_ClimbableBranches/` — activated when the player gains climbing ability. Contains collision and interaction points for the ascent route.
- `Future_NestArchive/` — the centuries of accumulated nests in the upper fork. Accessible only by climbing. Contains ancient feathers (genetic samples).

#### Great Telescope (T2)

```
great_telescope.tscn
│
├── TelescopeRoot (Node3D)
│   ├── Visual/
│   │   ├── LOD0/
│   │   │   ├── Tube (MeshInstance3D)                  # Brass tube with patina
│   │   │   ├── Mount_Equatorial (MeshInstance3D)      # Precision mount (frozen)
│   │   │   ├── Optics_Crystal (MeshInstance3D)        # Clouded objective lens
│   │   │   └── Pedestal (MeshInstance3D)              # Stone base
│   │   ├── LOD1/
│   │   │   └── Telescope_Combined (MeshInstance3D)    # Simplified single mesh
│   │   └── LOD2/
│   │       └── Telescope_Silhouette (MeshInstance3D)  # Angular profile only
│   │
│   ├── Collision/
│   │   ├── Pedestal_Body (StaticBody3D)               # Walkable base area
│   │   └── Mount_Body (StaticBody3D)                  # Physical obstacle
│   │
│   ├── InteractionPoints/
│   │   ├── Interaction_LookThrough                    # Primary: blurry view of Foundry
│   │   ├── Interaction_ExamineMount                   # Secondary: read mount markings
│   │   └── Interaction_AlignOptics                    # Future: repair interaction
│   │
│   ├── MemoryTriggers/
│   │   └── Trigger_TheStars                           # First time looking through
│   │
│   └── ExpansionNodes/
│       ├── Future_Cleaned/                            # Clean optics → clear view
│       ├── Future_Aligned/                            # Aligned mount → tracking
│       └── Future_Enhanced/                           # Enhanced optics → spectral analysis
```

---

## 6. RESOURCE NODE LIBRARY

### 6.1 — Design Principle

Every resource the player can collect exists as a **resource node scene** — a self-contained `.tscn` file that can be instanced anywhere on any island. Resource nodes are NOT placed by hand (except unique/hero resources). Common resources are placed by a **resource placer script** that reads spawn data from `.tres` resource files and instances the appropriate scenes.

### 6.2 — Resource Node Base Template

```
resource_base.tscn                           # Template for all resource nodes
│
├── ResourceRoot (Node3D)                    # Named: res_{resource_slug}
│   ├── Visual (Node3D)
│   │   ├── Mesh (MeshInstance3D)            #   The visual representation
│   │   └── LOD1 (MeshInstance3D)            #   Simplified mesh for distance
│   │
│   ├── Collision (Area3D)                   #   Interaction volume
│   │   └── CollisionShape3D
│   │
│   ├── ResourceData (Node)                  #   What this resource IS
│   │   ├── resource_id (String)            #     References data/resources/*.tres
│   │   ├── quantity (int)                  #     How many units available
│   │   ├── quality (float)                 #     0.0–1.0 quality modifier
│   │   └── depleted (bool)                 #     Has it been harvested?
│   │
│   ├── RegenerationTimer (Timer)            #   If renewable — when it respawns
│   │
│   └── VisualState (AnimationPlayer)        #   Full → harvested → depleted states
```

### 6.3 — Resource Node Catalogue

#### res_stone_building (Building Stone)
- **Mesh:** Irregular block, warm grey composite stone with crystalline flecks. 3 variants (size/shape).
- **Collision:** Area3D, 2m radius.
- **States:** Exposed (default — sitting on surface), PartiallyBuried (in soil), Crumbled (at base of retaining wall).
- **Depletion:** Does not deplete (stone is structural — you can't "use up" a wall). Individual loose blocks can be collected; the node represents a collection point, not an exhaustible resource.
- **Regeneration:** Very slow (new blocks weather free over years). For gameplay: respawns after long sleep.

#### res_stone_weathered (Weathered Stone)
- **Mesh:** Smaller fragments, more irregular, rounded edges. 5 variants.
- **Spawn Condition:** At base of vertical stone surfaces, in structural cracks, along island edges.
- **Depletion:** Depletes. Regenerates slowly as weathering continues.
- **Regeneration:** New fragments appear after storms (weather-driven respawn).

#### res_clay (Clay)
- **Mesh:** Flat deposit, cracked geometric polygon pattern, grey-brown. Wet variant (darker, shiny) vs dry variant.
- **Spawn Condition:** Settling pool edges (primary), dried pool beds (secondary).
- **Depletion:** Depletes. Does NOT regenerate in player timescale.
- **Regeneration:** New clay accumulates over centuries (long-sleep mechanic).

#### res_sand (Sand/Grit)
- **Mesh:** Low flat mound, granular texture, pale grey-beige.
- **Spawn Condition:** Wind-sheltered corners, structural depressions.
- **Depletion:** Depletes partially. Regenerates very slowly (wind continuously deposits).
- **Regeneration:** Gradual refill over seasons.

#### res_metal_debris (Metallic Debris)
- **Mesh:** Small rusted fitting, bolt, bracket, or hinge. 8 variants (iron rusted, brass patina, copper verde).
- **Spawn Condition:** Near original Golden Age equipment (Gatehouse cargo cradles, Celestial Ring instruments).
- **Depletion:** Depletes permanently. Finite quantity on the island. New sources require visiting other islands.
- **Regeneration:** None. Non-renewable on the Ark.

#### res_wood_branch (Fallen Wood)
- **Mesh:** Branch segment, 0.5–2m long, weathered grey-brown exterior. 4 variants (species, size).
- **Spawn Condition:** Beneath mature trees. More after storms.
- **Depletion:** Depletes. Regenerates as trees continue to shed branches.
- **Regeneration:** Seasonal — new branches fall in autumn and during storms.

#### res_wood_log (Fallen Log)
- **Mesh:** Large trunk section, 2–5m long. Rare spawn.
- **Spawn Condition:** Where a mature tree died (rare event). Fixed positions until decomposed.
- **Depletion:** Depletes. Does not regenerate (tree death is rare).
- **Regeneration:** New logs appear only if a new tree dies (centuries — long-sleep mechanic).

#### res_wild_grain (Wild Grains)
- **Mesh:** Cluster of tall golden grass with seed heads. Animated (wind sway).
- **Spawn Condition:** Upper Cascade terraces (dense stands). Scattered elsewhere.
- **Depletion:** Harvestable annually. Stand remains; regrows next season.
- **Regeneration:** Annual cycle — germinates in spring, harvestable in autumn.

#### res_berry_bush (Edible Berries — 3 variants)
- **Mesh:** Shrub 0.8–1.5m tall with visible berries. Variants for each berry type (purple, red-orange, golden).
- **Spawn Condition:** Sunny edges, well-drained soil. Cascade Gardens middle terraces, Aviary edges.
- **Depletion:** Berries harvestable. Bush remains. Refruits next season.
- **Regeneration:** Annual fruiting cycle.

#### res_medicinal_herb (Medicinal Herbs — 4 variants)
- **Mesh:** Herbaceous plant 0.2–0.6m tall. Distinctive leaf shape/color per type.
- **Spawn Condition:** Species-specific habitats (damp shade, dry sun, saturated soil, rich partial shade).
- **Depletion:** Leaves harvestable. Plant remains. Regrows over weeks.
- **Regeneration:** Continuous slow regrowth during growing season.

#### res_fiber_plant (Plant Fibers — 3 variants)
- **Mesh:** Vine segment (draped on structure), tall herbaceous stem, or spiky leaf cluster.
- **Spawn Condition:** Vines on arches/walls, bast plants on terraces, leaf plants on retaining walls.
- **Depletion:** Harvestable. Source plant remains. Regrows.
- **Regeneration:** Vines regrow from roots; bast plants regrow annually; leaf plants produce new leaves.

#### res_crystal_small (Crystal Fragments — Small)
- **Mesh:** Translucent crystal shard, thumbnail to palm-sized. Glows faintly if charged. 6 variants (size, charge state).
- **Spawn Condition:** Near crumbled retaining walls, structural cracks, exposed resonance infrastructure. Proximity to Resonance Moss is a visual indicator.
- **Depletion:** Depletes. Very slow regeneration as weathering exposes new fragments.
- **Regeneration:** New fragments exposed over decades (long-sleep mechanic).

#### res_crystal_large (Crystal Fragments — Large)
- **Mesh:** Fist-sized or larger crystal with visible internal lattice structure. Audible hum. Visible glow. UNIQUE placements — not randomly spawned.
- **Spawn Condition:** In specific Golden Age instruments (telescope optics, monitor sensors, Regulator panel). Hand-placed by designers.
- **Depletion:** Depletes permanently. Irreplaceable without Foundry access.
- **Regeneration:** None. Each large crystal is a unique, finite resource.

#### res_moss_resonance (Resonance Moss)
- **Mesh:** Circular patch 5–30cm diameter, blue-green, faint luminescence, soft velvety texture. Slow pulsing glow animation.
- **Spawn Condition:** Exclusively on or within 5cm of exposed resonance crystals.
- **Depletion:** Harvestable (moss scrapes off). Colony remains and regrows slowly.
- **Regeneration:** Colony expands by millimeters per year. Very slow.

#### res_honey (Honey)
- **Mesh:** Honeycomb section, golden, viscous. In Aviary upper arches (fixed position). Accessible only by climbing or smoke.
- **Spawn Condition:** Aviary arches — fixed hive locations. Not randomly placed.
- **Depletion:** Harvestable annually. Over-harvesting collapses the colony.
- **Regeneration:** Annual production cycle. Sustainable yield: ~30% of visible honey.

#### res_humus (Rich Humus)
- **Mesh:** Dark crumbly soil mound. Distinct from mineral soil by color and texture.
- **Spawn Condition:** Verdant Creep forest floor, Cascade Gardens compost beds.
- **Depletion:** Harvestable. Regenerates as organic matter continues decomposing.
- **Regeneration:** Continuous slow production. Faster in Verdant Creep (more input).

#### res_fungi (Fungi — 6 variants)
- **Mesh:** Mushroom or bracket fungus, species-specific. 6 variants with distinct visual identities. Bioluminescent variant glows.
- **Spawn Condition:** Species-specific: on fallen logs, in Fungal Grotto, on compost, at tree bases. Seasonal (peak after rain).
- **Depletion:** Harvestable (fruiting body). Mycelial network remains. Refruits.
- **Regeneration:** Seasonal fruiting cycles.

#### res_water (Fresh Water)
- **Mesh:** None — water is a fluid surface, not a mesh resource. Collection point marker (invisible Area3D).
- **Spawn Condition:** Reservoir, channels, settling pools, fountain.
- **Depletion:** Does not deplete (continuous flow). Water level fluctuates seasonally.
- **Regeneration:** Continuous via rain cycle.

#### res_feather (Bird Feathers)
- **Mesh:** Single feather or small cluster. Variable size/color by species.
- **Spawn Condition:** Below nesting colonies (Aviary arches, Atrium canopy, Courtyard Tree).
- **Depletion:** Collectible. New feathers continuously deposited.
- **Regeneration:** Continuous (birds molt regularly).

#### res_ancient_component (Ancient Components)
- **Mesh:** Small mechanical part — gear, bracket, fastener, lens element. 10+ variants.
- **Spawn Condition:** Near original Golden Age equipment. Some hand-placed in specific locations.
- **Depletion:** Depletes permanently. Finite supply on the Ark.
- **Regeneration:** None.

#### res_seed (Seeds — various)
- **Mesh:** Tiny — represented as a particle or small mesh per species. Collected by interacting with parent plant.
- **Spawn Condition:** On mature plants after flowering. Seasonal.
- **Depletion:** Harvestable annually. Plant continues producing.
- **Regeneration:** Annual cycle.

---

## 7. PROP LIBRARY

### 7.1 — Modular Prop Design

Props are reusable `.tscn` files stored in `assets/meshes/props/`. They are instanced into district scenes at author time (hand-placed for storytelling props) or at load time (procedural for filler props). Every prop uses a consistent root node structure.

### 7.2 — Prop Categories

#### Architecture — Walls & Structure

| Prop | Variants | Reusability | Notes |
|------|----------|-------------|-------|
| `prop_wall_straight` | 3 lengths (2m, 4m, 8m) × 2 finishes (interior, exterior) | Every district | Modular wall segments. Snap together at 2m grid. |
| `prop_wall_corner` | 2 types (inner, outer) × 2 finishes | Every district | Corner pieces for room construction. |
| `prop_wall_crumbled` | 4 damage states | Cascade, Verdant, Gatehouse | Partially collapsed wall segments. |
| `prop_pillar_square` | 2 heights × 2 states (intact, damaged) | Atrium, Living Quarters | Structural pillars. |
| `prop_floor_slab` | 3 sizes (2m, 4m, 8m square) × 2 finishes | Every district | Floor tiles. Cracked and root-penetrated variants for aged areas. |
| `prop_stairs_straight` | 3 rise heights | Cascade, Atrium, Living Quarters | Modular stair segments. |
| `prop_stairs_spiral` | 1 variant (broken) | Atrium (dome access) | The broken spiral staircase. |

#### Architecture — Openings & Connections

| Prop | Variants | Reusability | Notes |
|------|----------|-------------|-------|
| `prop_doorway` | 2 widths × 2 states (open, door ajar) | Every district | Standard doorframe without door. |
| `prop_door_heavy` | 1 variant (Sanctum-style) | Sanctum | The heavy push-door. Animated interaction. |
| `prop_arch_parabolic` | 2 sizes | Aviary, Atrium | First Delver parabolic arch. |
| `prop_window_frame` | 3 sizes × 2 states (glazed, empty) | Living Quarters | Window openings in walls. |
| `prop_bridge_stone` | 2 spans (10m, 20m) | Sanctum (primary), future islands | The bridge type connecting Sanctum to Ring. |

#### Laboratory & Scientific

| Prop | Variants | Reusability | Notes |
|------|----------|-------------|-------|
| `prop_workbench_lab` | 2 sizes | Sunken Lab, Propagation Station | Laboratory work surface with instrument mounts. |
| `prop_instrument_panel` | 3 variants (monitoring, control, display) | Celestial Ring, Sunken Lab, Sanctum | Wall-mounted instrument panels. Some interactive. |
| `prop_stasis_chamber` | 3 states (sealed, open, empty-active) | Sanctum (12 instances) | The stasis chambers. Unique interaction per state. |
| `prop_seed_storage_jar` | 4 variants (labeled with coding system) | Cascade Germination Station, Sanctum | Ceramic storage jars with coded labels. |
| `prop_bookshelf_lab` | 1 variant | Living Quarters Library, Sanctum Data Vault | Shelving for records and specimens. |

#### Furniture & Domestic

| Prop | Variants | Reusability | Notes |
|------|----------|-------------|-------|
| `prop_bed_single` | 1 variant | Living Quarters | Simple bed frame. Blankets in "turned down" state. |
| `prop_desk_writing` | 2 variants | Living Quarters, Director's Quarters | Writing desk with papers. |
| `prop_chair_wooden` | 2 variants | Living Quarters, Atrium alcoves | Simple wooden chair. |
| `prop_table_common` | 2 sizes | Living Quarters Common Room | Communal dining/work table. |
| `prop_mug_ceramic` | 4 variants | Atrium (half-finished cup), Living Quarters kitchen | Ceramic drinking vessel. The Atrium alcove mug is a unique instance (petrified contents). |

#### Debris & Decay

| Prop | Variants | Reusability | Notes |
|------|----------|-------------|-------|
| `prop_rubble_pile` | 4 sizes × 3 compositions | Cascade, Verdant, Gatehouse | Stone rubble from collapsed walls. |
| `prop_leaf_litter` | 3 densities | Verdant, Atrium, Aviary | Decal or mesh patches of fallen leaves. |
| `prop_root_intrusion` | 4 shapes | Living Quarters, Verdant, Atrium | Tree roots penetrating architecture. |
| `prop_vine_curtain` | 3 densities | Aviary, Verdant, Atrium walls | Hanging/draped vine meshes. |
| `prop_moss_patch` | 3 sizes | Damp areas throughout | Moss colonization on stone surfaces. |

---

## 8. VEGETATION SYSTEM

### 8.1 — Vegetation Architecture

Vegetation is NOT placed as individual scene instances. That would choke the engine at 50+ trees. Instead:

```
Vegetation System
│
├── Hero Trees                           # Unique, hand-placed, full 3D
│   ├── Courtyard Tree                   #   courtyard_tree.tscn (T1 landmark)
│   ├── Canopy Trees (Atrium)            #   3–4 hand-placed trees through the dome
│   ├── Specimen Trees (Aviary)          #   5–8 hand-placed collection trees
│   └── Instrument Tree                  #   instrument_tree.tscn (T2 landmark)
│
├── Multimesh Vegetation                 # Batched instanced meshes
│   ├── Multimesh_CanopyTrees            #   Verdant Creep canopy (~200 instances)
│   ├── Multimesh_Shrubs                 #   ~500 instances island-wide
│   ├── Multimesh_Grasses                #   ~2000 instances on Cascade terraces
│   ├── Multimesh_Flowers                #   ~1500 instances in Aviary
│   ├── Multimesh_Ferns                  #   ~800 instances in damp areas
│   ├── Multimesh_Vines                  #   ~300 instances on structures
│   ├── Multimesh_Moss                   #   ~500 instances on damp stone
│   └── Multimesh_Fungi                  #   ~200 instances in Verdant Creep
│
└── GPU Particles                        # Animated ambient life
    ├── Particles_Butterflies             #   Aviary, Cascade (visual only)
    ├── Particles_Fireflies               #   Nighttime — Verdant, Aviary, Atrium
    ├── Particles_Spores                  #   Fungal Grotto, Verdant damp areas
    └── Particles_Pollen                  #   Aviary, Cascade during flowering season
```

### 8.2 — Vegetation Data Flow

1. **Designer authors** a vegetation zone in `data/districts/{district}_vegetation.tres`. The zone specifies: bounding box, species list, density per species, elevation range, slope constraints.
2. **Vegetation placer script** reads the zone data at load time, generates placement points within the zone bounds, performs raycast validation (is there ground here? is the slope acceptable?), and populates the appropriate MultimeshInstance3D buffers.
3. **At runtime**, the MultimeshInstance3D renders all instances in a single draw call per species.

This means: to add more trees to the Verdant Creep, a designer edits the vegetation zone `.tres` file — they never touch scene files or manually place instances.

---

## 9. ENVIRONMENT SYSTEMS

### 9.1 — System Separation Principle

Environment systems are **independent scenes** that know nothing about each other. The weather scene does not reference the lighting scene. The wind scene does not reference the audio scene. Each system reads from shared data resources and publishes its state through signals. Systems are composed in the world root — they can be added, removed, or replaced without affecting anything else.

### 9.2 — Environment System Scenes

```
scenes/world/_shared/environment/
│
├── sky.tscn                             # Procedural sky material
│   Responsibility: Day/night cycle, star field, moon positions, Veil aurora
│   Reads: data/simulation/time_config.tres
│   Publishes: time_of_day signal, sun_direction signal
│
├── clouds.tscn                          # Volumetric cloud system
│   Responsibility: Cloud generation, movement, density, weather transitions
│   Reads: data/simulation/weather_config.tres
│   Consumes: wind_direction signal (from wind_system)
│
├── weather_controller.tscn              # Weather state machine
│   Responsibility: Rain, storm, clear, fog state transitions
│   Reads: data/simulation/weather_config.tres, time_of_day signal
│   Publishes: weather_changed signal, precipitation_intensity signal
│
├── wind_system.tscn                     # Wind simulation
│   Responsibility: Wind direction, speed, gusts, vegetation animation driver
│   Reads: data/simulation/wind_config.tres, weather_changed signal
│   Publishes: wind_direction signal, wind_speed signal
│   Affects: Vegetation shader parameters (global shader uniform)
│
├── fog_controller.tscn                  # Fog and atmospheric scattering
│   Responsibility: Height fog, distance fog, fog interaction with lighting
│   Consumes: weather_changed signal, time_of_day signal
│
└── water_manager.tscn                   # Water surface management
    Responsibility: Water shader parameters, reflection probes, flow animation
    Reads: data/simulation/water_config.tres
```

### 9.3 — How Systems Communicate

Systems NEVER hold direct references to each other. They communicate through:

1. **Signals** — Godot's built-in signal system. A system emits a signal when its state changes. Other systems connect to that signal in the world root.
2. **Shader Globals** — For visual systems that affect shaders (wind, time of day, fog). Systems write to `RenderingServer.global_shader_parameter_set()`. Shaders read the global. No scene reference needed.
3. **Data Resources** — For configuration that doesn't change at runtime. Systems read `.tres` files at load time. Designers edit the `.tres` files to tune behavior.

Example: When the weather changes to "rain," the weather controller emits `weather_changed("rain")`. The wind system receives the signal and adjusts wind speed. The fog controller receives it and increases atmospheric scattering. The audio system receives it and crossfades to the rain ambient bed. None of these systems knows the others exist.

---

## 10. LIGHTING ARCHITECTURE

### 10.1 — Lighting Layers

```
Lighting Strategy (per island)
│
├── Baked Lighting (LightmapGI)
│   Responsible: Static architecture, terrain, large structures
│   Method: LightmapGI baked per district scene
│   Storage: .lmb files alongside district .tscn files
│   Update: Rebake when static geometry changes
│
├── Dynamic Lights (Light3D nodes — limited count)
│   Responsible: Moving/toggleable lights, player light, crystal glow
│   Budget: Maximum 8 dynamic lights visible simultaneously
│   Priority: Nearest lights first; distant lights fade to baked approximation
│
├── Environment Lighting (WorldEnvironment)
│   Responsible: Sky contribution, ambient light, reflections
│   Method: Procedural sky material driven by time_of_day
│   Update: Continuous based on day/night cycle
│
└── Emissive Materials
    Responsible: Bioluminescent surfaces, crystal glow, amber strips
    Method: Emissive channel in standard materials — no light nodes
    Advantage: Zero performance cost; visible in baked and dynamic lighting
```

### 10.2 — District Lighting Profiles

Each district has a lighting configuration resource:

```
data/districts/{district_slug}_lighting.tres
│
├── ambient_color (Color)                # Base ambient tint
├── ambient_energy (float)               # Ambient intensity
├── sun_contribution (float)             # How much direct sun reaches (0=interior, 1=exposed)
├── sky_contribution (float)             # How much sky light reaches
├── local_lights (Array[LightData])      # District-specific dynamic lights
├── emissive_surfaces (Array[MeshRef])   # Surfaces with emissive materials
└── fog_override (FogData)              # District-specific fog (Verdant Creep mist)
```

---

## 11. AUDIO ARCHITECTURE

### 11.1 — Audio Bus Hierarchy

```
Master
├── Ambience                             # Environmental sounds
│   ├── Wind                            #   Wind system (procedural)
│   ├── Water                           #   Water features
│   ├── Wildlife                        #   Birds, insects
│   └── Resonance                       #   Crystal hum, stasis fields
│
├── SFX                                  # Sound effects
│   ├── Player                          #   Footsteps, interactions
│   ├── Environment                     #   Doors, mechanisms, resource harvest
│   └── UI                              #   Journal, Codex, menu
│
├── Music                                # Musical score
│   ├── Exploration                     #   District-specific music
│   ├── Discovery                       #   Codex discovery stings
│   └── Memory                          #   Memory fragment music
│
└── Voice                                # (Reserved — minimal in core design)
```

### 11.2 — Audio Emitter Strategy

- **District ambience:** One `AudioStreamPlayer3D` per district root, playing a looping ambient bed. Crossfades on district transition.
- **Landmark-specific audio:** Each landmark scene contains its own `AudioStreamPlayer3D` nodes (hum of the dome, creak of the tree, wind at the Ring).
- **Dynamic audio:** Wind, weather, and day/night audio are managed by the environment systems, not by spatial emitters.
- **Resource audio:** Harvest sounds are one-shot `AudioStreamPlayer3D` instances created at the interaction point and freed after playback.

---

## 12. DATA ARCHITECTURE

### 12.1 — Data Ownership Principle

**Scenes contain structure. Data resources contain configuration.** A `.tscn` file should contain ONLY node hierarchy, transforms, and scene references. All tunable parameters, gameplay values, and content definitions live in `.tres` files.

### 12.2 — Data Resource Map

| Data Domain | File Location | Resource Type | What It Defines |
|-------------|---------------|---------------|-----------------|
| **Resource Definitions** | `data/resources/{slug}.tres` | `ResourceDef` | Name, category, properties, spawn rules, Codex ref |
| **District Config** | `data/districts/{slug}.tres` | `DistrictConfig` | Name, elevation range, landmarks, portals, lighting profile, audio profile, vegetation zones |
| **Landmark Config** | `data/landmarks/{slug}.tres` | `LandmarkConfig` | Name, tier, owning district, interaction definitions, memory fragment refs, LOD distances |
| **Spawn Tables** | `data/spawns/{zone}_spawns.tres` | `SpawnTable` | Resource type, weight, quantity range, respawn timer |
| **Vegetation Zones** | Data embedded in `DistrictConfig.vegetation_zones[]` | `VegetationZone` | Bounds, species, density, constraints |
| **Codex Entries** | `data/codex/{entry_id}.tres` | `CodexEntry` | Title, category, text, unlock conditions, connections |
| **Simulation Config** | `data/simulation/{system}_config.tres` | Various | Time settings, weather params, ecology params, civilization params |
| **Navigation Data** | `data/navigation/{island}_navmesh.obj` (or .tres) | NavigationMesh | Walkable surfaces, obstacle data |
| **Interaction Data** | Embedded in `LandmarkConfig.interactions[]` | `InteractionDef` | Interaction type, prompt text, required knowledge, result |
| **Memory Fragments** | `data/dialogue/memories/{fragment_id}.tres` | `MemoryFragment` | Trigger conditions, audiovisual content, Journal text |
| **Dialogue** | `data/dialogue/{npc_id}.tres` | `DialogueTree` | NPC speech — minimal in core design, placeholder for future |

### 12.3 — Example: Resource Definition

```gdscript
# data/resources/stone_weathered.tres
class_name ResourceDef
extends Resource

@export var resource_id: String = "stone_weathered"
@export var display_name: String = "Weathered Stone"
@export var category: String = "stone"
@export var description: String = "Crumbled stone fragments from eroded structures..."
@export var mesh_variants: Array[PackedScene] = []
@export var scarcity: String = "common"
@export var renewable: bool = true
@export var regeneration_time_game_days: float = 365.0
@export var harvest_tool_required: String = ""  # empty = hands
@export var harvest_yield_min: int = 1
@export var harvest_yield_max: int = 4
@export var codex_entry_id: String = "stone_weathering"
@export var spawn_conditions: SpawnConditions  # Separate resource
```

---

## 13. NAMING CONVENTIONS

### 13.1 — The Prime Directive of Naming

**A file's name must communicate its type, its content, and its place in the hierarchy — without opening the file.**

### 13.2 — Conventions

| Element | Convention | Example | Rationale |
|---------|-----------|---------|-----------|
| **Scene files** | `snake_case.tscn` | `atrium.tscn`, `shattered_dome.tscn` | Matches Godot convention. Grep-friendly. |
| **Script files** | `snake_case.gd` | `resource_placer.gd`, `weather_controller.gd` | Matches scene name when paired. |
| **Data resources** | `{type}_{slug}.tres` | `resource_stone_weathered.tres`, `district_atrium.tres` | Type prefix enables glob patterns: `data/resources/resource_*.tres` |
| **Meshes** | `{category}_{descriptor}.glb` | `pillar_square_intact.glb`, `wall_crumbled_02.glb` | Category groups in file browser. |
| **Materials** | `{category}_{descriptor}.tres` | `stone_composite.tres`, `brass_patina.tres` | Matches mesh category naming. |
| **Textures** | `{material}_{map}.png` | `stone_composite_albedo.png`, `brass_patina_normal.png` | PBR map type as suffix. |
| **Folders** | `snake_case/` for content, `_prefix/` for special | `districts/`, `_shared/`, `_dev/` | Underscore prefix = special/not content. |
| **Nodes in scenes** | `PascalCase` for unique, `snake_case` for generic | `ShatteredDomeRoot`, `Panel_01`, `portal_north` | Unique nodes are findable. Generic nodes are typed. |
| **Signals** | `snake_case` past tense | `weather_changed`, `resource_depleted` | Signals describe things that happened. |
| **Autoloads** | `PascalCase` | `TimeManager`, `InteractionManager` | Autoloads are global singletons — PascalCase reflects this. |

### 13.3 — The Slug Standard

A "slug" is a URL-safe unique identifier used in file names, data keys, and cross-references. Slugs follow these rules:
- Lowercase alphanumeric plus underscores
- No spaces, no hyphens, no special characters
- Must be unique within their domain (island slugs unique among islands, district slugs unique within island, resource slugs globally unique)
- Examples: `ark_genesis`, `atrium`, `courtyard_tree`, `stone_weathered`

---

## 14. LOADING & STREAMING STRATEGY

### 14.1 — The Island Is Not Loaded All At Once

The Ark of Genesis is small enough (~220m × 190m) that it COULD fit in memory. But the architecture must scale to the Resonance Foundry (3× the Ark's size), surface regions (kilometers across), and the Underworld (vertical kilometers). The loading strategy is designed for the 100-island future, not just the tutorial island.

### 14.2 — Loading Phases

```
Player approaching island (distant)
│
├── Phase 0: Island Impostor
│   Load: Billboard impostor of island silhouette
│   Memory: ~1 MB (single texture)
│
├── Phase 1: Terrain Shell (player within 500m)
│   Load: ark_terrain_base.tscn (LOD2), terrain edge
│   Memory: ~15 MB (simplified geometry)
│
├── Phase 2: District Shells (player within 200m)
│   Load: District exterior geometry (LOD1), portals, occlusion volumes
│   Memory: ~40 MB (all districts' simplified exteriors)
│
├── Phase 3: Player's District (player within district bounds)
│   Load: Full district geometry (LOD0), landmarks within district, local props
│   Unload: Adjacent districts' LOD1 → LOD2 (keep silhouette, drop detail)
│   Memory: ~80 MB (one district full + rest simplified)
│
├── Phase 4: Interior Transition (player enters building/cave)
│   Load: Interior geometry at full detail
│   Unload: Exterior geometry beyond portal → LOD2 (occluded)
│   Memory: ~60 MB (interior replaces exterior)
│
└── Phase 5: Background Stream
    Load: Vegetation Multimesh buffers, resource nodes, ambient audio
    Memory: ~30 MB
```

### 14.3 — Streaming Implementation

Godot's `ResourceLoader.load_interactive()` and `PackedScene.instantiate()` are used with background threading:

```
1. Island root detects player within 500m of island → begins Phase 1
2. Phase 1 completes → begins Phase 2 (background thread)
3. Player enters district trigger volume → Phase 3 begins for that district
4. Each phase reports completion via signal
5. Failed loads (missing scene, corrupted resource) fall back to blockout mesh
```

**Maximum concurrent loads:** 4 scenes in background. Priority queue: nearest district first.

### 14.4 — The Resource Placer

Resources and vegetation are not loaded as individual scenes. The resource placer:

1. Reads the district's spawn table at Phase 5
2. Generates placement positions (random within constraints, checked against collision)
3. Populates `MultiMeshInstance3D` buffers for batched resources
4. For hero/unique resources: instances individual scenes at hand-authored positions
5. Regenerates placements on long-sleep (century timescale — resources have changed)

---

## 15. PERFORMANCE ARCHITECTURE

### 15.1 — Draw Call Budget

| Content Type | Max Draw Calls | Strategy |
|-------------|----------------|----------|
| **Static Architecture** | 200 | Merged by material. Same-material walls/floors are one draw call via MultiMesh or merged meshes. |
| **Hero Landmarks** | 50 | Individual meshes. LOD system reduces this at distance. |
| **Vegetation** | 8 | All vegetation per species is one MultiMeshInstance3D draw call. 8 total across all species. |
| **Props** | 30 | Instanced with MultiMeshInstance3D where repeated. Individual where unique. |
| **Water** | 4 | One per water body (reservoir, channels, pools, fountain). |
| **Effects** | 10 | GPU particles. |
| **Total Target** | **<300 draw calls** | At any moment in the player's view. |

### 15.2 — LOD Strategy

| Distance | LOD Level | Geometry Reduction | Material Reduction | Vegetation |
|----------|-----------|-------------------|-------------------|------------|
| 0–30m | LOD0 | Full detail | Full PBR | Full density Multimesh |
| 30–100m | LOD1 | 50% vertices | Simplified (no height map) | 50% density |
| 100–300m | LOD2 | 25% vertices | Single albedo texture | Billboard impostors |
| 300m+ | Impostor | Billboard | Single texture | Billboard only |
| Other island | Island Impostor | 6-sided billboard | Single texture | Not rendered |

### 15.3 — Occlusion Strategy

- **Portal-based occlusion:** District portals act as occlusion volumes. When the player is in the Atrium, the Gatehouse interior is not rendered (occluded by walls and the portal threshold).
- **Distance-based:** Beyond the LOD2 range (300m), nothing is rendered except skyline T1 landmarks and island impostors.
- **Height-based:** When the player is at the summit (Celestial Ring), the lower districts are visible but at LOD2. The engine renders simplified geometry for the overview.
- **Interior occlusion:** The Stasis Sanctum is a sealed interior. When the player is inside, nothing exterior is rendered. The Sanctum portal triggers a full exterior unload.

### 15.4 — Instancing Strategy

| Element | Instancing Method | Justification |
|---------|-------------------|---------------|
| **Structural walls/floors** | Merged mesh at build time | Same-material architecture is static — merge for single draw call |
| **Repeated props (chairs, jars)** | MultiMeshInstance3D | Hundreds of instances, one draw call |
| **Vegetation (non-hero)** | MultiMeshInstance3D | Thousands of instances, one draw call per species |
| **Resource nodes (common)** | MultiMeshInstance3D with visibility culling | Hundreds of instances |
| **Resource nodes (unique)** | Individual scene instance | Each has unique state (harvested, depleted) |
| **Hero landmarks** | Individual scene instance | Each is unique geometry with unique interactions |

### 15.5 — Chunking Strategy

For larger islands (the Foundry, surface regions), the terrain and architecture are split into **chunks** — spatial grid cells, typically 50m × 50m. Each chunk is a separate scene that loads/unloads based on distance. The Ark of Genesis (~220m × 190m) does not need chunking — it is small enough to load as a single terrain shell. But the architecture supports chunking: the terrain folder can contain `chunk_0_0.tscn` through `chunk_N_M.tscn` instead of a single terrain scene.

---

## 16. MULTIPLAYER SYNCHRONIZATION ARCHITECTURE

### 16.1 — Multiplayer Philosophy (From Vision Document)

> "Shared world, private understanding. Other players exist in the same world. You can encounter signs of them — structures, cultivated land, written notes, changes to the environment. But understanding is never transferred automatically."

Multiplayer in Aperture is **asynchronous and environmental**, not real-time co-op. Players share a world but are rarely in the same place at the same time. This simplifies synchronization significantly.

### 16.2 — What Is Synchronized

| Data | Sync Method | Frequency | Authority |
|------|-------------|-----------|-----------|
| **Terrain modifications** | Delta patches (heightmap diffs) | On change, batched | Player who made the change |
| **Structure placements** | Scene instantiation events | On placement/destruction | Player who built |
| **Resource depletion** | State change events (depleted, regenerating) | On state change | Server-authoritative |
| **Vegetation changes** | Zone state updates (density modifiers) | On significant change | Server-authoritative |
| **NPC states** | State snapshots (position, knowledge, relationships) | Periodic (every 60s real-time) | Server-authoritative |
| **Codex discoveries** | Per-player, NOT shared | — | Player-local |
| **Player-written notes** | Object instances with text payload | On placement | Player who wrote |
| **Time of day / Season** | Global state — same for all players | Continuous | Server-authoritative |

### 16.3 — What Is NOT Synchronized

- Player positions (players rarely meet — tracking is unnecessary until within proximity)
- Journal contents (private to each player)
- Memory fragments (private to each player)
- Player inventory (private)
- Player understanding/knowledge state (private — this is the core thesis)

### 16.4 — Synchronization Nodes

Each synchronizable object adds a minimal `SyncHandle` component:

```
SyncHandle (Node)
├── sync_id (String)                      # Globally unique identifier
├── sync_category (String)                # "resource", "structure", "terrain"
├── last_modified_timestamp (int)         # For conflict resolution
└── authority (String)                    # "server" or player_id
```

The sync system batches changes and transmits them on a low-frequency channel (every 5–10 seconds for non-critical updates). Critical updates (structure destruction that affects other players) are transmitted immediately.

---

## 17. AI-FRIENDLINESS SPECIFICATION

### 17.1 — Why AI-Friendliness Matters

Future development of Aperture will involve AI agents (like the fleet system already in place) modifying scenes, adding content, and debugging issues. The project structure must be **legible to a machine reading the file tree and file contents**. An AI should be able to:

1. Find any district scene by name without searching
2. Understand a scene's dependencies by reading its root node
3. Add a new prop to a district without breaking anything
4. Create a new island by copying the template and filling in the blanks
5. Read a `.tres` file and understand what it configures

### 17.2 — AI Navigation Rules

| Rule | Implementation |
|------|---------------|
| **Predictable locations** | Every file of type X lives in `{root}/{type}/`. Districts are ALWAYS at `scenes/world/{island}/districts/{slug}/`. |
| **Self-documenting roots** | Every scene's root node has a `Metadata` child containing String nodes with human-readable names and descriptions. |
| **Flat hierarchies** | Maximum 4 levels deep. An AI can enumerate all children without recursive descent. |
| **Consistent naming** | The naming conventions (Section 13) are machine-verifiable. A CI script can validate that all files follow the conventions. |
| **Explicit dependencies** | A scene's dependencies are listed in its `Metadata/Dependencies` node as an array of resource paths. An AI can read this without parsing the entire scene file. |
| **Template inheritance** | Every district is created from `district_base.tscn`. An AI can diff a district against the template to see what was customized. |
| **No magic strings in code** | All data references use exported resource paths or const string arrays at the top of scripts. |
| **File size limits** | `.tscn` files should not exceed 500 lines (Godot serialization). Larger scenes are split. A 5,000-line `.tscn` is a bug. |

### 17.3 — The Metadata Node Convention

Every scene root contains a `Metadata` node with at minimum:

```
Metadata (Node)
├── scene_name (String)                   # Human-readable name
├── scene_slug (String)                   # Machine-readable identifier
├── scene_type (String)                   # "island", "district", "landmark", "prop", "resource", "system"
├── description (String)                  # One sentence describing what this scene is
├── dependencies (Array[String])          # Paths to scenes/resources this depends on
├── owner_island (String)                 # Which island this belongs to (or "_shared")
├── version (int)                         # Incremented on structural changes
└── last_modified_by (String)             # "human" or agent_id
```

An AI agent tasked with "add a new prop to the Atrium" can:
1. Read `scenes/world/ark_genesis/districts/atrium/atrium.tscn` Metadata → confirms this is the right scene
2. Read `dependencies` → knows what assets are already loaded
3. Find `Props` node → knows where to instance the new prop
4. Instance the prop → knows it won't break anything because props are self-contained

---

## 18. DEPENDENCY GRAPH

### 18.1 — Dependency Directions

```
data/  ←────────────────── scenes/  ←────────────────── assets/
(configures)               (composes)                  (provides meshes,
                            │                           materials, audio)
                            │
                            ▼
                         scripts/
                         (defines behavior for scenes,
                          reads data/ for configuration)
```

**Key rule:** `assets/` never depends on anything. `data/` never depends on `scenes/`. `scripts/` depends on `data/` and `assets/`. `scenes/` depends on everything.

### 18.2 — What Can Reference What

| From ↓ / To → | assets/ | data/ | scripts/ | scenes/ | shaders/ |
|---------------|---------|-------|----------|---------|----------|
| **assets/** | ✅ | ❌ | ❌ | ❌ | ❌ |
| **data/** | ✅ (mesh refs) | ✅ | ❌ | ❌ | ❌ |
| **scripts/** | ✅ | ✅ | ✅ | ❌ | ✅ |
| **scenes/** | ✅ | ✅ | ✅ | ✅ | ✅ |
| **shaders/** | ✅ (textures) | ❌ | ❌ | ❌ | ✅ |

---

## 19. SCENE BOUNDARIES & OWNERSHIP

### 19.1 — Who Owns What

| Team | Owns | Can Modify |
|------|-------|-----------|
| **Environment Art** | `assets/meshes/architecture/`, `assets/meshes/terrain/`, `assets/materials/architecture/` | District scene geometry nodes, terrain scenes |
| **Prop Art** | `assets/meshes/props/`, `assets/materials/props/` | Prop instances in district scenes |
| **Vegetation Art** | `assets/meshes/vegetation/`, `assets/materials/vegetation/` | Vegetation Multimesh parameters in data resources |
| **VFX** | `assets/meshes/effects/`, `shaders/environment/`, `shaders/postprocess/` | Effect scenes, environment system parameters |
| **Lighting** | `scenes/world/{island}/lighting/`, `data/districts/{slug}_lighting.tres` | Light nodes, lightmap bakes, lighting config |
| **Audio** | `assets/audio/`, `scenes/world/{island}/audio/` | Audio emitter placement, ambient bed parameters |
| **Level Design** | `scenes/world/{island}/districts/`, `scenes/world/{island}/landmarks/` | Scene composition, portal placement, interaction point placement |
| **Systems Design** | `data/resources/`, `data/spawns/`, `data/simulation/` | Resource definitions, spawn tables, simulation config |
| **Gameplay Programming** | `scripts/`, `scenes/world/_shared/systems/` | All `.gd` files, system scenes |
| **Narrative** | `data/codex/`, `data/dialogue/` | Codex entries, memory fragment data |

### 19.2 — Conflict Prevention

Two people should NEVER need to modify the same file simultaneously:

- **District scenes** are small enough that one environment artist can own a district for a sprint.
- **Prop library** additions are append-only during production — new props don't modify existing ones.
- **Data resources** are individual files — two designers editing different resources never conflict.
- **Scripts** follow the same rule — one file per class, one programmer per feature.

---

## 20. PRODUCTION PIPELINE

### 20.1 — From Design Document to Engine

```
Design Document (docs/*.md)
        │
        ▼
Blockout Phase
  ├── Greybox district scenes (assets/meshes/architecture/_blockout/)
  ├── Placeholder landmark geometry
  ├── Flat lighting (single DirectionalLight3D)
  └── No vegetation, no props, no audio
        │
        ▼
Terrain Phase
  ├── ark_terrain_base.tscn from Topography Blueprint
  ├── Soil layer placement
  ├── Collision geometry
  └── Navigation mesh generation
        │
        ▼
Architecture Phase
  ├── Final architecture meshes replace blockouts
  ├── District scenes assembled from modular prop library
  ├── Landmark hero meshes placed
  └── LightmapGI baked per district
        │
        ▼
Dressing Phase
  ├── Props instanced
  ├── Vegetation Multimesh populated from data
  ├── Resource nodes placed
  └── Water bodies added
        │
        ▼
Polish Phase
  ├── Lighting tuned per district
  ├── Audio emitters placed
  ├── Effects (particles, shaders) added
  ├── Interaction points configured
  └── Memory fragment triggers placed
        │
        ▼
Optimization Phase
  ├── LOD meshes generated
  ├── Occlusion volumes verified
  ├── Draw call budget verified (<300)
  └── Load time tested (target: <5s to playable)
```

### 20.2 — CI/CD Integration

- **Pre-commit hook:** Validates naming conventions, file size limits (no .tscn > 500 lines), folder structure compliance.
- **Nightly build:** Exports all scenes, validates no missing dependencies, generates LOD meshes for new/modified assets, bakes lightmaps for modified districts.
- **Scene validator script:** `scripts/_dev/scene_validator.gd` — run in editor to check any scene against the architecture rules (has Metadata node, correct depth, named portals, etc.).

---

## CLOSING STATEMENT

This Production Architecture defines the complete Godot implementation framework for Aperture. It specifies folder hierarchy, scene composition, naming conventions, loading strategy, performance budgets, multiplayer synchronization, AI-friendly organization, and the production pipeline from design document to optimized scene.

The architecture scales from the Ark of Genesis (one tutorial island) to the full game (100+ islands, thousands of props, large NPC populations). It supports parallel development by multiple human artists and designers. It is legible to AI agents that will modify and extend the project.

Every scene is independently loadable. Every resource is data-driven. Every name follows predictable conventions. Every system communicates through defined interfaces.

The project is ready for production.

---

*Godot Production Architecture v1.0 — ratified 2026-07-08*
*Technical Art Director, Lead Godot Architect, Senior Level Designer, Environment Pipeline Engineer, Production Director: ArchBishop, by order of Lord Commander Ahmad*
