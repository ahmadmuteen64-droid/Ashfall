# Aperture — Production Roadmap: Ark of Genesis

*Complete executable production plan. Every build phase, task, dependency, validation gate, and AI work package defined. Multiple agents can execute in parallel from this document alone.*

**Classification:** AAA Studio Internal — Production & Technical Directorate
**Version:** 1.0
**Date:** 2026-07-08
**Authors:** ArchBishop (Technical Director, Production Director, Lead Godot Engineer, AI Pipeline Architect, Project Manager), by order of Lord Commander Ahmad

**Reference Documents (READ-ONLY — do not modify):**
- [[VISION]], [[WORLD-BIBLE]], [[GAMEPLAY-ARCHITECTURE]], [[ARK-OF-GENESIS-ISLAND-BLUEPRINT]], [[ARK-OF-GENESIS-TOPOGRAPHY]], [[ARK-OF-GENESIS-TRAVERSAL-BLUEPRINT]], [[ARK-OF-GENESIS-DISTRICT-DESIGN]], [[ARK-OF-GENESIS-RESOURCE-ECOLOGY]], [[ARK-OF-GENESIS-LANDMARK-CATALOGUE]], [[GODOT-PRODUCTION-ARCHITECTURE]], [[PRODUCTION-ASSET-MANIFEST]]

**What this document IS:** The build plan. The schedule. The validation framework. The AI dispatch manifest.
**What this document IS NOT:** Design. Lore. Mechanics. Systems. Those are already complete.
## TABLE OF CONTENTS
1. [Production Overview](#1-production-overview)
2. [Phase 1 — Foundation](#2-phase-1--foundation)
3. [Phase 2 — District Shells](#3-phase-2--skeleton)
4. [Phase 3 — Traversal & Collision](#4-phase-3--spine)
5. [Phase 4 — Landmarks](#5-phase-4--heart)
6. [Phase 5 — Resources & Vegetation](#6-phase-5--blood)
7. [Phase 6 — Props & Dressing](#7-phase-6--skin)
8. [Phase 7 — Atmosphere](#8-phase-7--atmosphere)
9. [Phase 8 — Optimization & QA](#9-phase-8--polish)
10. [Phase 9 — Playtesting & Ship](#10-phase-9--launch)
11. [Dependency Graph](#11-dependency-graph)
12. [Godot Implementation Order](#12-godot-implementation-order)
13. [Testing Checkpoints](#13-testing-checkpoints)
14. [AI Work Packages](#14-ai-work-packages)
15. [Production Timeline](#15-production-timeline)

---

## TASK SPECIFICATION FORMAT

| Field | Purpose |
|-------|---------|
| TASK-ID | Unique identifier (Phase.TaskNumber) |
| Priority | P0 (blocks everything) > P1 (critical path) > P2 (important) > P3 (nice-to-have) |
| Risk | LOW (routine) / MED (coordination) / HIGH (technical uncertainty) |
| Est. Hours | Approximate person-hours |
| Team | TERRAIN, ARCH, PROPS, VEG, WATER, CRYSTAL, VFX, LIGHT, AUDIO, SCRIPT, DATA, QA |
| Title | One-line action description |
| Purpose | Why this task exists |
| Description | What to build, with references to design documents |
| Inputs | Files/documents needed BEFORE starting |
| Dependencies | Task IDs that MUST be completed first |
| Blocks | Task IDs that CANNOT start until this is done |
| Parallel With | Task IDs that CAN run simultaneously |
| Output | Deliverable files and their expected state |
| Validation | How to verify the task is DONE |
| Completion Definition | Exact criteria for completion |

---

## 1. PRODUCTION OVERVIEW

### 1.1 — Build Philosophy
The Ark is built from the ground up: terrain first, then architecture, then traversal, then landmarks, then dressing, then atmosphere. Each phase produces a playable checkpoint.

### 1.2 — Parallel Execution
After foundation (Phase 1), the island splits into three parallel streams: Basin districts (AT, GH, CG-low), Slope districts (CG-up, VC, LQ, AV), Summit districts (CR, SS). Streams merge at Phase 3 (Traversal), split again at Phase 4 (Landmarks), and merge permanently at Phase 5.

### 1.3 — Phase Summary

| Phase | Name | Duration | Tasks | Deliverable |
|-------|------|----------|-------|-------------|
| 1 | Foundation | 1 week | 10 | Walkable terrain slab with sky |
| 2 | District Shells | 2 weeks | 11 | 8 district blockouts with portals |
| 3 | Traversal | 1 week | 7 | Player walks Gatehouse to Celestial Ring |
| 4 | Landmarks | 2 weeks | 14 | 20 landmarks with LOD0 and interactions |
| 5 | Resources & Vegetation | 1.5 weeks | 8 | Harvestable resources, full vegetation |
| 6 | Props & Dressing | 1.5 weeks | 11 | Every district environmentally dressed |
| 7 | Atmosphere | 2 weeks | 11 | Lighting, audio, VFX complete |
| 8 | Optimization & QA | 1 week | 9 | <300 draw calls, stable FPS |
| 9 | Launch | 1 week | 8 | Signed-off, packaged, documented |
| **TOTAL** | | **13 weeks** | **89 tasks** | Ark of Genesis — complete |

---

## 2. PHASE 1 — FOUNDATION

**Goal:** Project scaffold, terrain slab, sky, the player can stand on the island.
**Deliverable:** world_root.tscn loading ark_genesis.tscn with terrain visible.

### T1.01 — Project Folder Hierarchy
P0 | LOW | 3h | TERRAIN, SCRIPT
Create all folders per GODOT-PRODUCTION-ARCHITECTURE.md Section 2. Create district_base.tscn, landmark_base.tscn, resource_node_base.tscn templates with Metadata nodes. Place .gdignore files. Inputs: GODOT-PRODUCTION-ARCHITECTURE.md. Blocks: ALL tasks. Output: Complete folder tree + 3 template .tscn files. Validation: Folder tree matches architecture spec. Templates open without errors.

### T1.02 — Terrain Slab Mesh
P0 | LOW | 3h | TERRAIN
Model island_slab.glb: 220m N-S × 190m E-W, rounded hexagon, three-tier stepped profile from 0m to 42m. Per ARK-OF-GENESIS-TOPOGRAPHY.md Sections 2–4. Blocks: T1.05. Output: assets/meshes/terrain/island_slab.glb with blockout material. Validation: Dimensions verified. Three tiers distinguishable. Silhouette matches topography doc.

### T1.03 — Soil and Edge Meshes
P1 | LOW | 3h | TERRAIN
Model soil layers (basin 0.5-3m, slope 0.1-1m, summit 0-0.1m) conforming to slab. Model perimeter edges (sheer 48%, slope 35%, retaining 17%) and underside. Per Topography Sections 3, 15. Depends: T1.02. Output: 3 soil meshes + 4 edge meshes. Validation: Soil zones match elevation ranges. Edge types distinguishable.

### T1.04 — Terrain Scene Assembly
P0 | MED | 2h | TERRAIN
Create ark_terrain_base.tscn: instance slab, soil, edge meshes. Apply transforms. Add simplified StaticBody3D collision for walkable surface. Create ark_terrain_soil.tscn and ark_terrain_edge.tscn. Depends: T1.02, T1.03. Blocks: T2.01. Validation: Island visible from all angles. Player can be placed on surface.

### T1.05 — World Root and Island Root
P0 | MED | 3h | TERRAIN, SCRIPT
Create world_root.tscn with WorldEnvironment, DirectionalLight3D, sky placeholder. Create ark_genesis.tscn: instance terrain, create named placeholder nodes for districts/, landmarks/, resources/, vegetation/, water/, effects/, lighting/, audio/, navigation/, npc/. Add Metadata node. Depends: T1.01, T1.04. Blocks: ALL district/landmark work. Validation: World root loads. Island root has all placeholders.

### T1.06 — Data Resource Scaffold
P1 | LOW | 3h | DATA
Create ResourceDef, DistrictConfig, LandmarkConfig, SpawnTable custom resource classes. Create placeholder .tres files for 8 districts and 20 landmarks. Populate with initial data from design docs. Depends: T1.01. Blocks: T5.01. Output: scripts/resources/*.gd, data/districts/*.tres, data/landmarks/*.tres. Validation: Scripts compile. .tres files load.

### T1.07 — Autoload Singletons
P1 | LOW | 3h | SCRIPT
Create TimeManager (day/night), InteractionManager (raycast routing), WeatherController (stub), AudioManager (bus hierarchy). Register in project.godot. Depends: T1.01. Blocks: T7.02, T7.07, T6.10. Validation: Autoloads initialize on startup. TimeManager ticks.

### T1.08 — Developer Tools
P2 | LOW | 2h | SCRIPT
Create scenes/_dev/dev_tools.tscn: free-cam, frame counter, draw call display, LOD debug, scene reload. Depends: T1.01. Output: dev tools functional. Not referenced by shipping scenes.

### T1.09 — Populate District and Landmark Configs
P2 | LOW | 2h | DATA
Fill all 28 .tres files with verified data from District Design and Landmark Catalogue documents. Depends: T1.06. Validation: Spot-check 5 entries against design docs for accuracy.

### T1.10 — CKP-1: Terrain Review
P0 | MED | 2h | QA
Systematic verification: island dimensions (within 5%), elevation profile, edge types, soil zones, silhouette from 8 compass directions. Depends: T1.04, T1.05. Blocks: Phase 2 start. Output: QA report. All metrics pass. Phase 2 authorized.

---

## 3. PHASE 2 — DISTRICT SHELLS

**Goal:** Architectural blockout of all 8 districts with correct spatial boundaries and portal connections.
**Deliverable:** 8 district .tscn files instanced into ark_genesis.tscn, all portals aligned.

### Stream A — Basin Districts

### T2.01 — Atrium Shell
P0 | MED | 6h | ARCH
Build atrium.tscn from Stone Architecture kit blockout. Circular hall ~40m×35m. Structural ring at +15m. 5 portal exits to: N→CG, NE→AV, NW→LQ, S→GH, SE→VC. Floor at +8m. Inputs: ARK-OF-GENESIS-DISTRICT-DESIGN.md Section 3. Depends: T1.05. Parallel: T2.02. Validation: Circular shape. 5 portals at correct compass directions.

### T2.02 — Gatehouse Shell
P0 | MED | 4h | ARCH
Build gatehouse.tscn. ~30m×40m. Open southern face. Reception area, cargo cradle positions, quarantine alcove. 3 portals: N→AT, E→VC-low, W→Collapsed Bridge (locked). Inputs: District Design Section 4. Depends: T1.05. Parallel: T2.01. Validation: Open southern face. 3 portals correct.

### T2.03 — Cascade Gardens Shell
P0 | MED | 6h | ARCH
Build cascade_gardens.tscn. 5 terraces (+5m to +20m). Retaining walls. Channel depressions. Reservoir basin at +20m. Settling pool basins. Germination Station shell. 4 portals: S→AT, E→VC-up, N→LQ, NE→AV. Inputs: District Design Section 5. Depends: T1.05. Validation: 5 terraces. 4 portals correct.

### Stream B — Slope Districts

### T2.04 — Verdant Creep Shell
P0 | HIGH | 8h | ARCH
Build verdant_creep.tscn. Irregular ~50m×40m. 6 dome foundation depressions. Sunken Lab below-grade volume. Heavy structural damage (Ruins kit at 80% density). 3 portals: NW→AT, W→GH-low, N→CG-up. Inputs: District Design Section 6. Depends: T1.05. Validation: 6 dome rings. Sunken Lab volume exists. Collapse density correct.

### T2.05 — Living Quarters Shell
P0 | MED | 6h | ARCH
Build living_quarters.tscn. Central courtyard (open to sky). 12-15 rooms ringing courtyard. Director's Quarters at north end with large window. Common Room, Kitchen, Children's Room, Library. 4 portals: SE→AT, S→CG-up, N→AV, E→CR. Inputs: District Design Section 7. Depends: T1.05. Validation: Courtyard open. 12-15 rooms. Director's window at north.

### T2.06 — Aviary Shell
P0 | MED | 6h | ARCH
Build aviary.tscn. Iron arch framework. 3 glasshouse chambers (varying enclosure states). Specimen bed layouts. Grand Archway at SW. 5 portals: SW→AT, S→CG, W→LQ, N→CR, E→VC-up. Inputs: District Design Section 8. Depends: T1.05. Validation: Arch framework present. 3 chambers distinct. 5 portals correct.

### Stream C — Summit Districts

### T2.07 — Celestial Ring Shell
P0 | MED | 5h | ARCH
Build celestial_ring.tscn. 25m diameter circular platform at +42m. 8 stone monolith positions (irregular spacing). Telescope pedestal. Switchback ramp connection to Aviary. Resonance Core hatch. 3 portals: SW→AV, S→LQ, N→SS. Inputs: District Design Section 9. Depends: T1.05. Validation: 25m circle. 8 stone positions at irregular intervals.

### T2.08 — Stasis Sanctum Shell
P0 | MED | 4h | ARCH
Build stasis_sanctum.tscn. Interior ~25m×30m. Heavy door at south. 12 chamber positions (3 open, 8 sealed, 1 empty). Data Vault alcove. Bridge to Celestial Ring (10m span). 1 portal: S→CR. Inputs: District Design Section 10. Depends: T1.05. Validation: 12 chamber positions. Single portal. Bridge geometry correct.

### Integration

### T2.09 — District Integration
P0 | HIGH | 4h | ARCH, SCRIPT
Instance all 8 district scenes into ark_genesis.tscn placeholders. Verify transforms — districts align at portal boundaries. No gaps or overlaps. Depends: T2.01–T2.08. Blocks: T3.01. Validation: Walk all boundaries. Seamless transitions at every portal.

### T2.10 — CKP-2: District Shell Review
P2 | LOW | 2h | QA
Systematic walkthrough of all 8 districts. Check spatial dimensions, portal counts, feature presence against District Design doc. Depends: T2.09. Blocks: Phase 3 start. Output: QA report. All districts pass. Phase 3 authorized.

---

## 4. PHASE 3 — TRAVERSAL & COLLISION

**Goal:** Island is fully walkable. Player can traverse from Gatehouse (0m) to Celestial Ring (+42m).
**Deliverable:** Precise collision, navmesh, player controller, basic Journal, portal triggers.

### T3.01 — Production Collision
P0 | HIGH | 6h | TERRAIN, ARCH
Replace blockout collision with precise collision on all walkable surfaces. Precise: floors, stairs, ramps, platforms, bridges. Simplified: walls, large obstacles. None: small props, vegetation. Inputs: TRAVERSAL-BLUEPRINT.md. Depends: T2.09. Blocks: T3.02. Validation: No gaps in walkable surfaces. Walls block movement. No collision on visual-only.

### T3.02 — Navigation Mesh
P0 | MED | 3h | SCRIPT
Place NavigationRegion3D. Bake NavMesh for entire island. Configure agent parameters. Verify coverage of all paths. Exclude: steep slopes (>45°), water, platform edge zone. Depends: T3.01. Validation: NavMesh debug shows coverage. Pathfinding Gatehouse→Ring returns valid path.

### T3.03 — Player Controller
P0 | MED | 4h | SCRIPT
Create player.tscn with CharacterBody3D. Implement: walk, sprint (stamina), crouch, jump, mantle, interact (raycast). First-person camera. Vampire edge-safety (auto-catch at island edge). Inputs: GAMEPLAY-ARCHITECTURE.md Sections 1-3, 7. Depends: T1.07. Validation: All movement states work. Edge safety triggers at Departure Platform.

### T3.04 — Basic Journal System
P1 | LOW | 3h | SCRIPT
Create Journal UI. Auto-record observations on examine. Hypothesis section (player-editable). Category tabs (placeholder). Connect to InteractionManager. Depends: T1.07. Validation: Examine fountain → Journal entry. 5 objects → 5 entries. Hypothesis accepts input.

### T3.05 — Portal Triggers
P1 | LOW | 2h | SCRIPT
Place Area3D triggers at each district portal. On enter: log district change, emit signal for audio crossfade and streaming. Depends: T2.09, T3.03. Validation: Walk through each portal. Console logs transition. Signals fire.

### T3.06 — CKP-3: Traversal Review
P0 | MED | 3h | QA
Walk every route in Traversal Blueprint. Time primary route Gatehouse→Ring (target: 15-25 min walking). Document stuck points, missing collision. Test edge cases (jumping, crouching). Depends: T3.01–T3.05. Blocks: Phase 4 start. Output: Route verification report. All routes pass. Phase 4 authorized.

---

## 5. PHASE 4 — LANDMARKS

**Goal:** All 20 landmarks with LOD0 geometry, collision, interaction points.
**Deliverable:** 20 landmark scenes instanced into districts. Visibility matrix verified.

### Stream A — Basin Landmarks

### T4.01 — Shattered Dome (T1)
P0 | HIGH | 12h | ARCH, CRYSTAL, VFX
Build shattered_dome.tscn. Structural ring at +15m. 30 floating hexagonal crystal panels (drift animation). 15 floor fragments. Resonance tether points. Crystal hum audio. Interaction: look up → Journal trigger. Inputs: LANDMARK-CATALOGUE.md Section 5.1. Depends: T2.01. Validation: 30 panels floating. Hum audible. Prismatic light on walls.

### T4.02 — Great Table (T2)
P0 | MED | 4h | ARCH
Build great_table.tscn. 4.5m×2m oval stone slab. Astronomical calendar inlay. Hidden inscription on underside (crouch to discover). Player spawn marker. Depends: T2.01. Validation: Calendar inlay visible. Hidden inscription triggers on crouch.

### T4.03 — Departure Platform (T2)
P0 | MED | 4h | ARCH
Build departure_platform.tscn. 30m×8m projecting south. No railing. Rusted docking clamps. Edge safety zone. Depends: T2.02. Validation: Clouds visible below. No railing. Safety triggers.

### T4.04 — Fountain + Dome Fragments (T3)
P1 | LOW | 3h | ARCH, WATER
Build fountain.tscn (water particles, bioluminescent moss emissive, flowing audio) and dome_fragments_floor.tscn (15 scattered shards, charged+discharged). Depends: T2.01. Validation: Fountain flows. Moss glows. Shards scattered.

### Stream B — Slope Landmarks

### T4.05 — Courtyard Tree (T1)
P0 | HIGH | 16h | VEG, ARCH
Build courtyard_tree.tscn. 45m hero tree. Silver-grey bark with children's carvings. 8-12 major branches. Inner canopy (MultiMesh ~10k leaves). Exposed roots throughout LQ. Bird nests. Planting plaque at base (buried). Interaction: examine carvings, collect bark. Inputs: LANDMARK-CATALOGUE.md Section 5.2. Depends: T2.05. Validation: 45m height. Carvings visible. Roots penetrate LQ rooms.

### T4.06 — Grand Archway (T2)
P0 | MED | 6h | ARCH, VEG
Build grand_archway.tscn. 8m parabolic iron arch. 90% flowering vine coverage. Bioluminescent night glow. Threshold lighting trigger. Depends: T2.06. Validation: Arch dimensions. Vine density. Threshold trigger.

### T4.07 — Instrument Tree (T2)
P0 | HIGH | 10h | VEG, ARCH
Build instrument_tree.tscn. Irregular trunk grown around station walls. Embedded instruments (display, dial, recorder). Coffee cup at chest height. Researcher's notebook in root crevice. Depends: T2.04. Validation: Instruments visible in trunk. Cup at chest height. Notebook discoverable.

### T4.08 — Central Reservoir (T2)
P0 | MED | 5h | ARCH, WATER
Build central_reservoir.tscn. 15m×8m stone basin. Reflective water surface. Overflow connection. Aquatic plants. Broken lift mechanism. Tools visible through water. Depends: T2.03. Validation: Water reflects sky. Overflow connects. Lift broken.

### T4.09 — Hollow Dome (T2)
P1 | MED | 5h | ARCH
Build hollow_dome.tscn. 20m hemisphere. Crystal viewing ports. Interior accessible through breaches. Distinct interior microclimate vegetation. Light shafts. Depends: T2.04. Validation: 20m hemisphere. Breaches allow entry. Interior distinct.

### T4.10 — T3 Slope Landmarks
P1 | LOW | 3h | ARCH
Build: fungal_grotto_entrance.tscn (dark opening, bioluminescent glow), memory_garden_flower.tscn (bioluminescent blue-violet flower, bench, Director's sketch case), director_window.tscn (large open frame, Ring view), music_box.tscn (wind-up, lullaby audio). Depends: T2.04, T2.05, T2.06. Validation: Grotto glows. Flower bioluminescent at night. Window frames Ring. Music box plays.

### Stream C — Summit Landmarks

### T4.11 — Ring Platform + Standing Stones (T1+T2)
P0 | HIGH | 12h | ARCH, CRYSTAL
Build ring_platform.tscn (25m circle at +42m, wind-scoured) and standing_stones.tscn (8 unique monoliths, crystal inclusions, layered inscriptions, K's entry). Depends: T2.07. Validation: 25m diameter. 8 unique stones. Crystals glow at night. Inscriptions layered.

### T4.12 — Great Telescope (T2)
P0 | HIGH | 10h | ARCH, SCRIPT
Build great_telescope.tscn. 3.5m brass tube on equatorial mount. Clouded optics. Pointed at northern Foundry. Interaction: look through (blurry image). Memory trigger on first use. Depends: T2.07. Validation: Tube angle correct. Blurry view. Memory triggers.

### T4.13 — Sanctum Entrance + Empty Chamber (T2+T3)
P0 | HIGH | 8h | ARCH, VFX
Build sanctum_entrance.tscn (heavy door, amber lights, sustained push 3-5s). Build empty_chamber.tscn (active stasis field shimmer, player name label, Data Vault records). Depends: T2.08. Validation: Sustained push opens door. Stasis field shimmers. Label shows player name.

### T4.14 — Landmark Integration + CKP-4
P0 | MED | 5h | QA, ARCH
Instance all 20 landmarks into district placeholders. Verify transforms. Test all interactions. Verify cross-district visibility per visibility matrix. Depends: T4.01–T4.13. Blocks: Phase 5. Validation: All landmarks placed. Visibility matrix verified. CKP-4 signed. Phase 5 authorized.

---

## 6. PHASE 5 — RESOURCES & VEGETATION

**Goal:** Harvestable resources and living vegetation. Ecosystem functional.
**Deliverable:** Resource placer operational. All vegetation zones populated. Water system flowing.

### T5.01 — Resource Node System
P0 | HIGH | 6h | DATA, SCRIPT
Create resource_node_base.tscn. Implement ResourceDef class (all fields from ASSET-MANIFEST). Implement resource placer: reads SpawnTable, generates positions, validates against collision, instances nodes. Implement harvest: state change, quantity update, regeneration timer. Inputs: ASSET-MANIFEST.md, RESOURCE-ECOLOGY.md. Depends: T1.06, T3.01. Blocks: T5.03–T5.05. Validation: Place test nodes. Harvest. State changes. Timer starts.

### T5.02 — Water System
P0 | MED | 4h | WATER, SCRIPT
Place all water surfaces: reservoir, channels, pools, fountain. Connect to WaterManager. Implement: seasonal level variation, sluice gate interaction (adjusts downstream flow). Depends: T4.04, T4.08. Output: Complete water flow from reservoir to fountain. Validation: Flow verified. Sluice interaction works.

### T5.03 — Spawn Data
P0 | MED | 4h | DATA
Create SpawnTable .tres for all resource types. Define: zones, elevation range, slope constraints, moisture requirements, density, companion associations, seasonal availability. Per RESOURCE-ECOLOGY.md spawn logic. Depends: T1.06, T5.01. Output: data/spawns/ark_spawns.tres, 8 vegetation zone definitions. Validation: Every resource type has rules. Zones cover all districts.

### T5.04 — Vegetation Population
P0 | HIGH | 8h | VEG, SCRIPT
Populate MultiMeshInstance3D buffers from vegetation zone data. Hero trees hand-placed. Densities: VC ~5000 instances, AV ~1500 flowers, CG ~2000 grasses, CR ~20 wind-pruned. Configure LOD distances. Apply wind shader. Depends: T5.03, T4.14. Validation: Density correct per district. No clipping. Wind active.

### T5.05 — Common Resource Placement
P0 | MED | 4h | SCRIPT
Run resource placer for: weathered stone, fallen branches, wild grains, berries (3 types), medicinal herbs (4 types), fiber plants (3 types), sand, clay. Per ecological spawn logic. Depends: T5.03, T5.01. Validation: Each type in correct zone. Collect 5 types. Respawn correct.

### T5.06 — Uncommon/Rare Resource Placement
P1 | MED | 3h | SCRIPT
Hand-place: crystal fragments (near moss/crumbled walls), resonance moss (on exposed crystals), fungi (on logs, Grotto, seasonal), honey (Aviary arches), ancient components (near Golden Age equipment). Depends: T5.05, T4.14. Validation: Crystals near moss. Fungi on correct substrates. Honey in arches.

### T5.07 — Discovery System (No Sparkles)
P1 | MED | 3h | SCRIPT
Resources have NO glow/sparkle/outline. Journal records on examine. After 3+ observations of same type, Journal suggests habitat pattern. Moss reveals nearby crystals. Animal behavior reveals resources. Seasonal availability enforced. Depends: T5.05, T5.06. Validation: No sparkle. Journal hints after 3 obs. Seasonal berries correct.

### T5.08 — CKP-5: Resource & Vegetation Review
P1 | LOW | 2h | QA
Collect every resource type. Verify spawn logic (ecological correctness). Verify harvest feedback and regeneration. Verify vegetation density and LOD. Test seasonal variation. Depends: T5.01–T5.07. Blocks: Phase 6. Output: QA report. Phase 6 authorized.

---

## 7. PHASE 6 — PROPS & DRESSING

**Goal:** Every district environmentally dressed. The island feels lived-in, abandoned, reclaimed.
**Deliverable:** All districts dressed with props per District Design environmental storytelling.

### T6.01–T6.08 — District Prop Dressing

Each district is one task. All 8 can run in parallel after landmarks are placed.

| Task | District | Hours | Key Story Props |
|------|----------|-------|-----------------|
| T6.01 | Atrium | 4h | Half-finished mug, research alcoves, Directory Plaque, child's drawing, dust footprints |
| T6.02 | Gatehouse | 3h | Left Luggage, Arrival Log, height markings, cargo manifests, coded labels |
| T6.03 | Cascade Gardens | 4h | Germination Station (seeds, notebook), sluice gates, weather station, grave marker |
| T6.04 | Verdant Creep | 3h | Sunken Lab (panels, experiment log), Breached Seed Bank (L's note), animal log |
| T6.05 | Living Quarters | 5h | Director's journal, resonance chest, Music Box, half-written letter, hidden codex, children's drawings |
| T6.06 | Aviary | 4h | Propagation Station (log mid-sentence), specimen labels, beehive records, Director's sketch |
| T6.07 | Celestial Ring | 3h | Resonance Monitors (anomaly visible), Weather Station data, K's observation entry |
| T6.08 | Stasis Sanctum | 3h | Empty Chamber label, Data Vault records, Regulator access log, evacuation priority log |

Each task: Inputs: DISTRICT-DESIGN.md (district section). Depends: T4.14 (landmarks placed). Validation: All story props present and interactive. Environmental stories discoverable.

### T6.09 — Ambient Prop Scattering
P1 | LOW | 3h | PROPS
Scatter: stone debris (MultiMesh in damaged areas), leaf litter (decals), bird nests, scattered books, fallen tools. Density per district: SS 0%, CR 5%, GH 10%, AT 30%, CG 40%, LQ 50%, AV 60%, VC 80%. Depends: T6.01–T6.08. Validation: Ambient density correct per district.

### T6.10 — Interaction System
P1 | MED | 3h | SCRIPT
Implement InteractionManager: raycast → check "interactable" group → context prompt. Handle: Examine (Journal), Collect (inventory + state change), Activate (mechanism), Sustained (door push). Depends: T1.07. Validation: All interaction types functional on all interactive objects.

### T6.11 — Memory Fragment System
P1 | MED | 3h | SCRIPT
Implement MemoryFragment resource class. Trigger conditions (location, object, time, prior fragments). Audio/visual content (brief shift, NOT cutscene). Journal entry. One-time triggers. Depends: T6.10. Output: All memory fragments defined and triggerable per District Design.

### T6.12 — CKP-6: Gameplay Interaction Review
P1 | LOW | 3h | QA
Test every interactive object, every memory fragment, every environmental story. Verify Journal entries. Depends: T6.01–T6.11. Blocks: Phase 7. Output: QA report. Phase 7 authorized.

---

## 8. PHASE 7 — ATMOSPHERE

**Goal:** Full visual and audio atmosphere. The island feels like the Ark of Genesis.
**Deliverable:** Baked lighting, dynamic lights, complete audio, all VFX.

### T7.01 — Lightmap Bake
P0 | HIGH | 8h | LIGHT
Configure LightmapGI in world_root. Bake per district scene (each gets own lightmap). 4 bounces, ambient occlusion. Verify no light leaking at portals. Shattered Dome handled separately (prismatic is dynamic). Depends: T6.09 (all geometry final). Blocks: T7.02. Validation: No black surfaces. No leaks. AO at junctions.

### T7.02 — Dynamic Lighting + Time of Day
P0 | MED | 4h | LIGHT
Implement full day/night cycle in TimeManager. Sun directional: color temp 3500K (dawn) → 5500K (midday) → 3500K (dusk) → moon 4100K (night). Apply per-district lighting profiles (ambient, sun contribution, sky contribution, fog). Depends: T1.07, T7.01. Validation: Full 24h cycle. District profiles applied.

### T7.03 — Emissive & Bioluminescent
P0 | MED | 3h | LIGHT
Configure emissive materials: crystal glow (pale blue-white, slow pulse), amber strips (warm amber, constant), bioluminescent moss/fungi (blue-green, 10-15s pulse), Memory Garden flower (violet-blue, night-only). Depends: T7.02. Validation: All emissive sources visible at night. Pulses correct.

### T7.04 — Prismatic Dome Effect
P0 | HIGH | 6h | VFX
Create caustic-like light projection shader. Driven by sun angle through 30 crystal panel positions. Panel charge state affects glow. Projects on Atrium walls/floor/table. Cloud dimming. Golden hour intensification. Depends: T4.01, T7.02. Validation: Prismatic patterns visible. Shift with sun. Cloud dimming works.

### T7.05 — Weather & Atmospheric VFX
P1 | MED | 4h | VFX
Volumetric fog (VC dense 3-8m visibility, CG morning mist, GH none). Cloud system (below island). Rain (GPU particles, surface-dependent sound). Godrays (through canopy). Spores (bioluminescent in Grotto). Depends: T7.02, T5.04. Validation: Creep fog limits visibility. Rain triggers. Godrays visible.

### T7.06 — Resonance & Stasis VFX
P1 | MED | 3h | VFX
Stasis field shader: volumetric shimmer, geometric interference patterns, pale blue-white. Crystal pulse animation (varied by crystal size). Resonance Core hatch glow. Depends: T4.13, T7.03. Validation: Empty Chamber shimmers. Crystal pulses vary. Core glows.

### T7.07 — District Ambient Audio Beds
P0 | HIGH | 6h | AUDIO
Place AudioStreamPlayer3D in each district. 8 ambient beds per ASSET-MANIFEST Section 16.1. Crossfade on portal transition (3s). Depends: T1.07, T3.05. Validation: Correct ambience per district. Smooth crossfade. No gaps.

### T7.08 — SFX Implementation
P0 | MED | 4h | AUDIO
Configure: footstep system (6 surface types), mechanism SFX (Sanctum door, sluice gate, music box), resource harvest SFX (per type), crystal SFX (chime, collect). Depends: T6.10, T7.07. Validation: Every SFX triggers correctly.

### T7.09 — Adaptive Music System
P1 | MED | 3h | AUDIO
Implement 8 district music themes with 3 adaptive layers each. Layer triggers: L1 always, L2 on examine, L3 on crystal/resonance proximity. Crossfade on district transition. Memory fragment overlay. Depends: T7.07, T7.08. Validation: Correct theme per district. Layers activate on triggers.

### T7.10 — Creature Sounds
P1 | LOW | 2h | AUDIO
Place spatial audio emitters: Aviary birdsong, Creep insect chorus, CG frog calls (evening), Courtyard Tree birds. Depends: T5.04, T7.07. Validation: Birdsong spatial. Insect density correct in Creep.

### T7.11 — CKP-7: Atmosphere Review
P1 | LOW | 2h | QA
Full playthrough at dawn, midday, night. Test: lighting per district, time transitions, emissive/bioluminescent, prismatic dome, fog, audio crossfades, SFX, music layers, creature sounds. Depends: T7.01–T7.10. Blocks: Phase 8. Output: QA report. Phase 8 authorized.

---

## 9. PHASE 8 — OPTIMIZATION & QA

**Goal:** Performance targets met. All QA passes complete.
**Deliverable:** Optimized island at <300 draw calls, stable 30+ FPS.

### T8.01 — Performance Audit
P0 | HIGH | 4h | QA, SCRIPT
Measure: FPS per district, draw calls, VRAM, load times. Identify top 10 bottlenecks. Document baseline. Depends: T7.11. Validation: Baseline captured. Bottlenecks ranked.

### T8.02 — LOD Generation
P0 | HIGH | 8h | ARCH, VEG
Generate LOD1 (50% verts) and LOD2 (25% verts) for all architecture. Hero landmarks: LOD per catalogue specs. Vegetation: MultiMesh LOD distances configured. Water: simplified at >100m. LOD distances: T1 0-50/50-200/200-500m, T2 0-30/30-150/150m+, T3 0-15m. Depends: T8.01. Validation: LOD transitions at correct distances. Dithering smooth.

### T8.03 — Occlusion Culling
P0 | HIGH | 4h | SCRIPT
Portal-based: district portals as occlusion volumes. Interior: Sanctum interior → nothing exterior. Distance: >300m → T1 only. Height: Ring → lower districts at LOD2. Depends: T8.02, T3.05. Validation: Draw calls drop in interiors. No visible pop-in.

### T8.04 — Performance Verification
P0 | MED | 3h | QA
Re-measure all metrics. Verify: FPS > 30 (target 60), draw calls < 300, VRAM in budget, load < 5s. Depends: T8.02, T8.03. Blocks: Phase 9. Validation: All targets met.

### T8.05 — Collision & Navigation QA
P1 | MED | 3h | QA
Walk every surface. Test stairs, ramps, bridges, platforms, root surfaces. Verify no fall-through. Verify navmesh coverage. Test edge cases. Depends: T3.01, T3.02. Validation: No stuck points. No gaps. NavMesh complete.

### T8.06 — Visual QA Pass
P1 | MED | 3h | QA
Check: geometry clipping, floating objects, z-fighting, LOD popping, texture seams, missing faces, incorrect normals. Depends: T6.09, T7.11. Validation: No visual artifacts remain.

### T8.07 — Audio QA Pass
P1 | MED | 2h | QA
Check: ambient levels (consistent), SFX levels, spatialization, crossfade smoothness, music layers, no dropouts, no distortion. Depends: T7.07–T7.10. Validation: All audio balanced and correct.

### T8.08 — Codex Data Population
P1 | MED | 2h | DATA
Create CodexEntry .tres files for all entries in District Design and Landmark Catalogue documents. Unlock conditions configured. Connections between entries defined. Depends: T1.06. Validation: Spot-check 10 entries for accuracy.

### T8.09 — CKP-8 + CKP-9: Final QA Gates
P1 | LOW | 2h | QA
CKP-8 (Performance): All metrics pass. CKP-9 (QA): Zero critical bugs. Zero major bugs. Minor bugs documented. Depends: T8.01–T8.08. Blocks: Phase 9. Output: Signed QA reports. Phase 9 authorized.

---

## 10. PHASE 9 — LAUNCH

**Goal:** Playtested, polished, packaged, documented. Ready for players.
**Deliverable:** Shippable build with documentation.

### T9.01 — Internal Playtest
P0 | MED | 4h | QA
Full playthrough by 3+ team members who did NOT build their test areas. Script: awaken → explore 8 districts → interact 20 landmarks → collect all resource types → trigger all memory fragments → reach Sanctum → discover Empty Chamber. Document: time, friction, bugs. Depends: T8.09. Validation: 3+ playtests complete. Issues documented.

### T9.02 — First-Playthrough Timing
P0 | MED | 3h | QA
Time 5 naive playtesters. No guidance. Record: time to first exit choice, first revelation, first memory fragment, reaching Ring, total time. Target: 25-40 minutes. Depends: T9.01. Validation: Average in 25-40 min range.

### T9.03 — Return-Playthrough Verification
P0 | MED | 2h | QA
Second playthrough by same testers. Verify: new details discovered (hidden paths, coding system, Director's mark, locked areas as goals). Document second-pass discoveries. Depends: T9.02. Validation: New content discovered on second pass.

### T9.04 — Bug Fix Pass
P1 | MED | 4h | ALL
Triage T9.01–T9.03 findings. Fix critical and major bugs. Defer minor to post-launch. Depends: T9.01–T9.03. Validation: Zero critical. Zero major.

### T9.05 — Export Configuration
P1 | LOW | 2h | SCRIPT
Configure Godot export presets. Release build. Stripped debug. Compressed textures. Test exported build. Depends: T9.04. Validation: Export completes. Build runs correctly.

### T9.06 — Build Documentation
P1 | LOW | 2h | DATA
Write BUILD.md (dependencies, setup, build commands, export targets). Write ARCHITECTURE.md summary (project structure, how to add island/district, naming conventions, AI agent instructions). Depends: T9.05. Validation: Follow BUILD.md from clean checkout → builds.

### T9.07 — Launch Assets
P2 | LOW | 2h | ALL
Capture: hero screenshots (dome at golden hour, Departure Platform, Courtyard Tree, Empty Chamber, Ring panorama). 60-second flythrough video. Depends: T9.04. Output: Launch assets folder.

### T9.08 — CKP-10: Final Sign-off
P0 | MED | 3h | ALL
Cross-reference checklist against all design documents. Verify: 8 districts match District Design, 20 landmarks match Landmark Catalogue, all resources per Resource Ecology, all environmental stories discoverable, all memory fragments triggerable, performance targets met, all QA gates passed. Depends: T9.01–T9.07. Output: Production sign-off document. **ARK OF GENESIS — PRODUCTION COMPLETE.**

---

## 11. DEPENDENCY GRAPH

```
P1: Foundation ──→ P2: District Shells ──→ P3: Traversal ──→ P4: Landmarks
                                                                     │
                                                                     ▼
                                              P5: Resources & Vegetation
                                                                     │
                                                                     ▼
                                              P6: Props & Dressing
                                                                     │
                                                                     ▼
                                              P7: Atmosphere
                                                                     │
                                                                     ▼
                                              P8: Optimization & QA
                                                                     │
                                                                     ▼
                                              P9: Launch & Ship
```

**Critical path (18 tasks):** T1.01 → T1.02 → T1.04 → T1.05 → T2.01 → T2.09 → T3.01 → T4.01 → T4.14 → T5.01 → T5.04 → T6.05 → T7.01 → T7.04 → T8.01 → T8.02 → T9.01 → T9.08

**Parallelizable:** 71 of 89 tasks can run in parallel with the critical path. Phase 2 runs 8 district shells simultaneously. Phase 4 runs 14 landmark tasks across 3 parallel streams. Phase 6 runs 8 district dressing tasks simultaneously. Phase 7 runs lighting, audio, and VFX in parallel.

---

## 12. GODOT IMPLEMENTATION ORDER (Sequential)

For a solo developer or sequential AI agent:

```
 1. Terrain slab mesh + soil + edges
 2. Terrain scene assembly
 3. World root + island root + placeholders
 4. Data scaffold + autoloads
 5. District shells: AT → GH → CG → VC → LQ → AV → CR → SS
 6. District integration
 7. Collision on all surfaces
 8. NavMesh + player controller + Journal + portal triggers
 9. Traversal verification
10. Landmarks: AT landmarks → GH → CG → VC → LQ → AV → CR → SS
11. Landmark integration + visibility check
12. Water system
13. Resource system + spawn data
14. Vegetation population
15. Resource placement (common → uncommon)
16. Discovery system
17. District prop dressing (AT→GH→CG→VC→LQ→AV→CR→SS)
18. Ambient scatter
19. Interaction + memory fragment systems
20. Lightmap bake + dynamic lighting
21. Emissive/bioluminescent + prismatic dome
22. Weather, fog, VFX
23. Audio: ambience → SFX → music → creatures
24. Performance audit → LOD → occlusion → verify
25. QA passes: collision, visual, audio, Codex
26. Playtesting → fixes → export → docs → sign-off
```

**Why this order:** Terrain is the foundation. Data before content. Shells before detail. Collision before traversal. Traversal before landmarks. Landmarks before vegetation. Water before resources. Atmosphere last. Optimization after everything is placed.

---

## 13. TESTING CHECKPOINTS

| CKP | After Phase | What Is Tested | Acceptance Criteria |
|-----|-------------|----------------|---------------------|
| CKP-1 | 1 | Terrain | Dimensions within 5%. Silhouette recognizable from 8 directions. |
| CKP-2 | 2 | District Shells | All spatial dimensions match. All portal connections correct. |
| CKP-3 | 3 | Traversal | Every route walkable. Gatehouse→Ring 15-25 min. NavMesh complete. |
| CKP-4 | 4 | Landmarks | 20 landmarks present. Visibility matrix verified. Interactions functional. |
| CKP-5 | 5 | Resources & Veg | All resources harvestable in correct zones. Vegetation density correct. |
| CKP-6 | 6 | Gameplay | All interactions functional. All memory fragments triggerable. Stories discoverable. |
| CKP-7 | 7 | Atmosphere | Lighting correct. Audio complete. VFX present. Day/night cycle verified. |
| CKP-8 | 8 | Performance | FPS > 30 (target 60). Draw calls < 300. Load < 5s. LOD smooth. |
| CKP-9 | 8 | QA Gate | Zero critical bugs. Zero major bugs. All checks passed. |
| CKP-10 | 9 | Playtest | 25-40 min first playthrough. Return reveals new content. Export functional. |

---

## 14. AI WORK PACKAGES

AI agents receive self-contained packages. Each has: scope, inputs (file paths), outputs (file paths), validation script or checklist, estimated time, dependencies.

### Phase 1 Packages (can run in parallel pairs)
- **AI-P1-01:** Project scaffolding (2h, no deps)
- **AI-P1-02:** Terrain slab mesh (2h, no deps)
- **AI-P1-03:** Soil + edge meshes (3h, needs AI-P1-02)
- **AI-P1-04:** Autoload scripts (4h, needs AI-P1-01)

### Phase 2 Packages (all 8 can run in parallel)
- **AI-P2-{AT,GH,CG,VC,LQ,AV,CR,SS}:** Build {district} shell (4-8h each, all need terrain)

### Phase 4 Packages (by stream — 3 streams can run in parallel, within-stream tasks sequential)
- **AI-P4-BASIN:** Dome + Table + Platform + Fountain/Fragments (depends: AT+GH shells)
- **AI-P4-SLOPE:** Courtyard Tree + Archway + Instrument Tree + Reservoir + Hollow Dome + T3s (depends: LQ+AV+VC+CG shells)
- **AI-P4-SUMMIT:** Ring+Stones + Telescope + Sanctum Entrance + Empty Chamber (depends: CR+SS shells)

### Phase 5–6 Packages
- **AI-P5-RES:** Resource system + spawn data + placement (6h, needs P4 complete)
- **AI-P5-VEG:** Vegetation population (8h, needs P4 complete)
- **AI-P5-WATER:** Water system (4h, needs reservoir + fountain landmarks)
- **AI-P6-{AT,GH,CG,VC,LQ,AV,CR,SS}:** Dress {district} (3-5h each, needs district landmarks)

### Phase 7 Packages (can run in parallel)
- **AI-P7-LIGHT:** Lightmap + dynamic + emissive + prismatic (12h, needs P6 complete)
- **AI-P7-AUDIO:** All audio — ambience, SFX, music, creatures (10h, needs P6 complete)
- **AI-P7-VFX:** Weather, fog, resonance, stasis (6h, needs P4 landmarks)

### Package Validation Standard
Every AI package includes a validation step: "Run scripts/_dev/validate_{package_id}.gd. All checks must pass." Validation scripts check: file existence, correct node hierarchy, metadata presence, naming conventions, collision presence, interaction point configuration.

---

## 15. PRODUCTION TIMELINE

```
WEEK 1   ████████  P1: Foundation          [CKP-1 Fri]
WEEK 2   ████████████████████  P2: District Shells (3 parallel streams)
WEEK 3   ░░░░░░░░░░░░░░████████  P2 cont.  [CKP-2 Fri]
WEEK 4   ████████  P3: Traversal           [CKP-3 Fri]
WEEK 5   ████████████████████  P4: Landmarks (3 parallel streams)
WEEK 6   ████████████████████  P4 cont.    [CKP-4 Fri]
WEEK 7   ████████████████  P5: Resources & Vegetation  [CKP-5 mid-week]
WEEK 8   ████████████████  P6: Props & Dressing       [CKP-6 Fri]
WEEK 9   ████████████████████  P7: Atmosphere (Light/Audio/VFX parallel)
WEEK 10  ████████████████████  P7 cont.    [CKP-7 Fri]
WEEK 11  ████████  P8: Optimization & QA   [CKP-8 + CKP-9 Fri]
WEEK 12  ████████████████  P9: Playtesting
WEEK 13  ████████  P9: Fixes, Export, Docs  [CKP-10 Fri] ▶ SHIP
```

### Staffing Model

| Phase | TERRAIN | ARCH | PROPS/VEG | SCRIPT | VFX/LIGHT/AUD | QA | Total |
|-------|---------|------|-----------|--------|---------------|-----|-------|
| 1 | 2 | — | — | 2 | — | 1 | 5 |
| 2 | — | 3 | — | — | — | 1 | 4 |
| 3 | 1 | — | — | 2 | — | 1 | 4 |
| 4 | — | 3 | — | 1 | 1 | 1 | 6 |
| 5 | — | — | 3 | 2 | — | 1 | 6 |
| 6 | — | — | 3 | 1 | — | 1 | 5 |
| 7 | — | — | — | 1 | 3 | 1 | 5 |
| 8 | — | — | — | 2 | — | 1 | 3 |
| 9 | — | — | — | 1 | — | 2 | 3 |

**Ideal team:** 14-17. With AI agents augmenting: 6-8 humans + AI for parallel packages.

### Risk Register

| Risk | Prob | Impact | Mitigation |
|------|------|--------|------------|
| Lightmap bake exceeds schedule | MED | HIGH | Bake overnight. Lower res for early passes. |
| Creep vegetation density tanks perf | MED | MED | Aggressive LOD. Reduce density if needed. |
| Prismatic dome shader complexity | MED | LOW | Fallback: simpler caustic if full sim too expensive. |
| Portal streaming pop-in | LOW | MED | Dithering transitions. Pre-load adjacent at LOD2. |
| Memory fragment A/V integration | LOW | LOW | Simple audio shift + overlay. Low technical risk. |
| Cross-district visibility incorrect | LOW | MED | Verify matrix in P4. Fix sight lines before P8. |

---

## CLOSING STATEMENT

This Production Roadmap defines the complete build plan for the Ark of Genesis. 89 tasks across 9 phases, 10 testing checkpoints, 20+ AI work packages, 13-week timeline. The critical path is 18 tasks. 71 tasks can run in parallel. Every task has clear inputs, outputs, dependencies, and validation criteria.

Production begins with Phase 1, Task 1.01: Create the project folder hierarchy.

---

*Production Roadmap v1.0 — ratified 2026-07-08*
*Technical Director, Production Director, Lead Godot Engineer, AI Pipeline Architect, Project Manager: ArchBishop, by order of Lord Commander Ahmad*
