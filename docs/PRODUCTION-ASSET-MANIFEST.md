# Aperture — Production Asset Manifest: Ark of Genesis

*Complete production catalogue. Every 3D mesh, material, texture, animation, VFX, and audio asset required to construct the Ark of Genesis. This document IS the production manifest. Nothing appears in the world that is not listed here.*

**Classification:** AAA Studio Internal — Art & Production Directorate
**Version:** 1.0
**Date:** 2026-07-08
**Authors:** ArchBishop (Art Director, Technical Art Director, Lead Environment Artist, Asset Production Lead, Modular Environment Designer, Production Pipeline Architect), by order of Lord Commander Ahmad

**Parent Documents:**
- [[ARK-OF-GENESIS-ISLAND-BLUEPRINT]]
- [[ARK-OF-GENESIS-DISTRICT-DESIGN]]
- [[ARK-OF-GENESIS-LANDMARK-CATALOGUE]]
- [[ARK-OF-GENESIS-RESOURCE-ECOLOGY]]
- [[GODOT-PRODUCTION-ARCHITECTURE]]
- [[VISION]] (Art Direction section)

**How to read this document:**
- **Environment Artists** → Sections 1–7 (Terrain, Architecture, Props, Vegetation, Water, Modular Kits)
- **Prop Artists** → Sections 3, 8 (Props, Scientific Equipment)
- **VFX Artists** → Section 9 (Effects & Particles)
- **Lighting Artists** → Section 10 (Light Sources)
- **Audio Designers** → Section 11 (Audio Assets)
- **Creature Artists** → Section 12 (Wildlife)
- **Technical Artists** → Section 13 (Style Guide), Section 14 (Modular Kits)
- **Production** → Section 15 (Priority Tiers)

---

## TABLE OF CONTENTS

1. [Terrain & Geology Assets](#1-terrain--geology-assets)
2. [Architecture — First Delver Stone Kit](#2-architecture--first-delver-stone-kit)
3. [Architecture — Metal & Glass Structures](#3-architecture--metal--glass-structures)
4. [Architecture — Bridges, Platforms & Verticality](#4-architecture--bridges-platforms--verticality)
5. [Architecture — Ruins & Broken Structures](#5-architecture--ruins--broken-structures)
6. [Vegetation — Trees, Shrubs & Flora](#6-vegetation--trees-shrubs--flora)
7. [Vegetation — Ground Cover, Fungi & Decay](#7-vegetation--ground-cover-fungi--decay)
8. [Props — Laboratory & Scientific Equipment](#8-props--laboratory--scientific-equipment)
9. [Props — Furniture & Domestic Objects](#9-props--furniture--domestic-objects)
10. [Props — Containers, Storage & Books](#10-props--containers-storage--books)
11. [Props — Debris, Decay & Ambient Detail](#11-props--debris-decay--ambient-detail)
12. [Water Assets](#12-water-assets)
13. [Crystal & Resonance Assets](#13-crystal--resonance-assets)
14. [Effects & Particles](#14-effects--particles)
15. [Light Sources](#15-light-sources)
16. [Audio Assets](#16-audio-assets)
17. [Wildlife & Environmental Creatures](#17-wildlife--environmental-creatures)
18. [Modular Construction Kits](#18-modular-construction-kits)
19. [Visual Style Guide](#19-visual-style-guide)
20. [Production Priority Tiers](#20-production-priority-tiers)
21. [Asset Count Summary](#21-asset-count-summary)

---

## ASSET SPECIFICATION FORMAT

Every asset in this manifest follows this template:

```
ASSET NAME                    Category | Tier | District Usage
  Purpose:                    Why this asset exists in the world
  Historical Purpose:         What it was during the Golden Age
  Gameplay Purpose:           How the player interacts with it
  Variations:                 How many unique meshes needed
  Poly Budget:                Target triangle count range
  Materials:                  Number of unique materials
  Textures:                   Required texture maps
  Animation:                  Animation requirements (None / Simple / Complex)
  Collision:                  Collision type (None / Simple / Complex / Precise)
  LOD:                        LOD levels needed (1–4)
  Physics:                    Physics requirements (None / Static / Rigidbody)
  Interaction:                Interaction type (None / Examine / Collect / Activate / Sustained)
  Shader:                     Special shader requirements
  Sound:                      Associated audio events
  Reuses With:                Compatible assets that share geometry/materials
  Dependencies:               Assets this depends on
```

**Priority Tiers:** T1 = Essential for first playable. T2 = Polish pass. T3 = Future expansion.

**District codes:** AT = Atrium, GH = Gatehouse, CG = Cascade Gardens, VC = Verdant Creep, LQ = Living Quarters, AV = Aviary, CR = Celestial Ring, SS = Stasis Sanctum

---

## 1. TERRAIN & GEOLOGY ASSETS

### 1.1 — Island Structural Slab

```
ARK_TERRAIN_SLAB                Terrain | T1 | ALL
  Purpose:                    The island's structural foundation — the engineered platform upon which everything sits
  Historical Purpose:         The resonance-stabilized composite platform manufactured in the First Delver Foundries
  Gameplay Purpose:           Walkable surface; reveals crystal inclusions when weathered; teaches composite materials
  Variations:                 3 (intact surface, weathered surface, fractured edge)
  Poly Budget:                5,000–8,000 tris (simplified base mesh for the ~220m×190m slab)
  Materials:                  1 (resonance-stabilized composite stone)
  Textures:                   Albedo (2048×2048), Normal, Roughness, Metallic
  Animation:                  None
  Collision:                  Complex (precise walkable surface — this IS the ground)
  LOD:                        3 levels (full slab → simplified silhouette → island impostor billboard)
  Physics:                    Static
  Interaction:                None (passive terrain)
  Shader:                     Standard PBR + world-aligned triplanar mapping for cliff faces
  Sound:                      Footstep sounds (stone) — referenced by player controller, not emitted by terrain
  Reuses With:                All future islands use variants of this slab mesh
  Dependencies:               None (foundational asset)
```

### 1.2 — Soil & Ground Layers

```
ARK_SOIL_BASIN                  Terrain | T1 | AT, GH, CG-lower, VC-lower
  Purpose:                    Accumulated soil in sheltered low-elevation areas — 0.5m–3m deep
  Historical Purpose:         5,000 years of wind-deposited dust, decomposed vegetation, water-borne sediment
  Gameplay Purpose:           Supports moisture-loving plants; contains humus resource; can be dug
  Variations:                 2 (deep basin soil, transitional slope soil)
  Poly Budget:                2,000–4,000 tris (ground cover mesh conforming to slab surface)
  Materials:                  1 (dark rich soil)
  Textures:                   Albedo (1024×1024), Normal, Roughness
  Animation:                  None
  Collision:                  Simple (ground surface)
  LOD:                        2 levels
  Physics:                    Static
  Interaction:                None (passive terrain) — digging interaction handled by resource system
  Shader:                     Standard PBR with detail normal map for soil texture at close range
  Sound:                      Footstep sounds (soft earth)
  Reuses With:                All future islands with soil accumulation
  Dependencies:               ARK_TERRAIN_SLAB (conforms to slab surface)

ARK_SOIL_SLOPE                  Terrain | T1 | CG-upper, VC-upper, AV
  Purpose:                    Thinner, well-drained soil on mid-elevation slopes — 0.1m–1m deep
  Variations:                 1
  Poly Budget:                (Included in basin mesh as variant)
  Materials:                  1 (medium-brown mineral-rich soil)
  Textures:                   Albedo (1024×1024), Normal, Roughness
  Animation:                  None
  Collision:                  Simple
  LOD:                        2 levels
  Physics:                    Static
  Interaction:                None
  Shader:                     Standard PBR
  Sound:                      Footstep sounds (soft earth)

ARK_SOIL_SUMMIT                 Terrain | T1 | CR, SS-exterior
  Purpose:                    Thin to absent soil on exposed summit — 0m–0.1m deep. Mostly bare stone.
  Variations:                 1 (patchy — covers ~15% of summit surface)
  Poly Budget:                500–1,000 tris (sparse patches)
  Materials:                  1 (grey-brown mineral grit)
  Textures:                   Albedo (512×512), Normal, Roughness
  Animation:                  None
  Collision:                  None (stone surface beneath is the collision)
  LOD:                        1 level (not visible from distance)
  Physics:                    Static
  Interaction:                None
  Shader:                     Standard PBR
  Sound:                      Footstep sounds (stone/grit)
```

### 1.3 — Rock Formations & Geological Features

```
ARK_CLIFF_EXPOSED               Geology | T1 | CG (retaining wall bases), VC (exposed sections), island perimeter
  Purpose:                    Exposed structural stone faces where erosion has revealed the island's interior
  Historical Purpose:         The resonance-stabilized composite, now visible as cliff faces and eroded edges
  Gameplay Purpose:           Source of building stone and weathered stone resources; teaches geological weathering
  Variations:                 4 (sheer cliff, fractured face, crumbled talus, root-penetrated)
  Poly Budget:                1,000–3,000 tris per section
  Materials:                  2 (clean composite, weathered composite with visible inclusions)
  Textures:                   Albedo (2048×2048 tileable), Normal, Roughness, Metallic
  Animation:                  None
  Collision:                  Complex (these ARE walls)
  LOD:                        3 levels
  Physics:                    Static
  Interaction:                None (passive) — resource collection targets small detached fragments, not the cliff
  Shader:                     Standard PBR + triplanar + crystal inclusion emissive (subtle)
  Sound:                      None (ambient wind around cliffs handled by audio system)
  Reuses With:                All future floating islands (identical construction material)
  Dependencies:               ARK_TERRAIN_SLAB (these are exposed sections OF the slab)

ARK_ROCK_BOULDER                Geology | T2 | CG, VC, LQ (courtyard)
  Purpose:                    Large detached stone blocks — fallen from retaining walls or exposed by erosion
  Historical Purpose:         Sections of First Delver architecture that have separated from their structures
  Gameplay Purpose:           Environmental obstacle; visual storytelling (shows structural decay); minor stone source
  Variations:                 5 (size: 0.5m–3m diameter; shape: angular, rounded-weathered, split, moss-covered)
  Poly Budget:                200–800 tris each
  Materials:                  1 (weathered composite stone)
  Textures:                   Albedo (1024×1024), Normal, Roughness
  Animation:                  None
  Collision:                  Simple (capsule or convex hull)
  LOD:                        2 levels
  Physics:                    Static
  Interaction:                None (obstacle only)
  Shader:                     Standard PBR
  Sound:                      None
  Reuses With:                ARK_CLIFF_EXPOSED (same material)

ARK_STONE_SCREE                 Geology | T2 | CG (retaining wall bases), VC (slopes)
  Purpose:                    Accumulated stone fragments forming sloped debris fields
  Historical Purpose:         Talus from 5,000 years of freeze-thaw spalling off exposed stone faces
  Gameplay Purpose:           Source of weathered stone fragments; teaches erosion mechanics
  Variations:                 3 (density: sparse, medium, dense)
  Poly Budget:                500–1,500 tris (combined mesh per scree field)
  Materials:                  1 (mixed stone fragments)
  Textures:                   Albedo (1024×1024), Normal, Roughness
  Animation:                  None
  Collision:                  Simple (sloped collision surface)
  LOD:                        2 levels
  Physics:                    Static
  Interaction:                Resource collection (weathered stone — the player gathers from scree)
  Shader:                     Standard PBR
  Sound:                      Footstep sounds (loose stone)
```

### 1.4 — Ground Surface Materials

```
ARK_GROUND_STONE_PATH           Surfaces | T1 | AT, GH, CG (original paved paths), CR
  Purpose:                    Original First Delver paved walking surfaces — still intact in many areas
  Variations:                 2 (intact dressed stone, worn stone with vegetation in cracks)
  Poly Budget:                N/A (material + vertex blending on terrain, not separate meshes)
  Materials:                  1 (dressed paving stone)
  Textures:                   Albedo (1024×1024 tileable), Normal, Roughness
  Notes:                      Applied as terrain material in areas of original paving. Crack decals overlay for aged variant.

ARK_GROUND_SOIL_PATH            Surfaces | T1 | CG, VC, AV
  Purpose:                    Dirt paths formed by player and animal traffic over centuries — now stabilized
  Variations:                 2 (dry earth, damp earth—near water)
  Materials:                  1 (packed earth)
  Textures:                   Albedo (1024×1024 tileable), Normal, Roughness

ARK_GROUND_MOSS_CARPET          Surfaces | T2 | AT (fountain area), VC (damp zones), CG (pool edges)
  Purpose:                    Thick moss growth on consistently damp stone surfaces
  Variations:                 2 (common green moss, bioluminescent moss)
  Materials:                  1 (moss)
  Textures:                   Albedo (512×512), Normal, Roughness, Emissive (bioluminescent variant only)
  Shader:                     Standard PBR + emissive pulse (bioluminescent variant — slow 10–15s cycle)

ARK_GROUND_LEAF_LITTER          Surfaces | T2 | VC, AT, AV, LQ
  Purpose:                    Accumulated fallen leaves on the ground beneath trees
  Variations:                 3 (density thin/medium/thick; seasonal: autumn leaves/decomposed dark humus)
  Materials:                  1 (leaf litter)
  Textures:                   Albedo (1024×1024 tileable), Normal, Roughness
  Notes:                      Decal or terrain layer — not a separate mesh.
```

### 1.5 — Clay & Sand Deposits

```
ARK_DEPOSIT_CLAY                Geology | T2 | CG (settling pool edges), VC (dried pool beds)
  Purpose:                    Clay accumulation at still-water edges — 5,000 years of sediment deposition
  Gameplay Purpose:           Harvestable clay resource; teaches sedimentation
  Variations:                 2 (wet clay — dark grey-brown, cracked dry clay — lighter geometric polygons)
  Poly Budget:                200–500 tris per deposit (flat surface mesh with cracked normal map)
  Materials:                  1 (clay)
  Textures:                   Albedo (512×512), Normal (cracked pattern), Roughness
  Animation:                  None
  Collision:                  Simple
  LOD:                        1 level
  Physics:                    Static
  Interaction:                Resource collection (clay gathering)
  Shader:                     Standard PBR
  Sound:                      Squelch (wet clay — footstep), crumble (dry clay — harvest)

ARK_DEPOSIT_SAND                Geology | T2 | GH (wind-sheltered corners), CR (platform edges)
  Purpose:                    Wind-deposited sand and grit from ongoing stone erosion
  Gameplay Purpose:           Harvestable sand resource; teaches wind erosion
  Variations:                 2 (fine sand drift, gritty deposit with small stone chips)
  Poly Budget:                100–300 tris per patch
  Materials:                  1 (sand)
  Textures:                   Albedo (512×512), Normal (granular detail), Roughness
  Animation:                  None
  Collision:                  None (terrain surface beneath)
  LOD:                        1 level
  Physics:                    Static
  Interaction:                Resource collection (sand gathering)
  Shader:                     Standard PBR
  Sound:                      Soft crunch (walking on sand)
```

---

## 2. ARCHITECTURE — FIRST DELVER STONE KIT

### 2.1 — Walls

```
ARK_WALL_STRAIGHT               Architecture | T1 | ALL DISTRICTS
  Purpose:                    Primary vertical structural element — forms rooms, corridors, district boundaries
  Historical Purpose:         Precision-cut resonance-stabilized composite stone walls, fitted without mortar
  Gameplay Purpose:           Defines spatial boundaries; creates occlusion; supports environmental storytelling
  Variations:                 9 (3 lengths: 2m/4m/8m × 3 finishes: interior-smooth/exterior-weathered/damaged-cracked)
  Poly Budget:                100–400 tris each
  Materials:                  3 (interior smooth stone, exterior weathered, damaged with exposed crystal)
  Textures:                   Albedo (1024×1024 tileable per finish), Normal, Roughness, Metallic
  Animation:                  None
  Collision:                  Complex (precise — these define walkable boundaries)
  LOD:                        3 levels (full → simplified geometry → flat plane with normal map)
  Physics:                    Static
  Interaction:                None (passive architecture)
  Shader:                     Standard PBR + world-aligned mapping for seamless tiling
  Sound:                      None (footstep on stone handled by surface material)

ARK_WALL_CORNER                 Architecture | T1 | ALL DISTRICTS
  Purpose:                    90° and 45° corner pieces for wall junctions
  Variations:                 4 (inner 90°, outer 90°, inner 45°, outer 45°) × 2 finishes (interior/exterior)
  Poly Budget:                150–300 tris each
  Materials:                  Same as ARK_WALL_STRAIGHT

ARK_WALL_RETAINING              Architecture | T1 | CG (all terraces), VC (structural edges)
  Purpose:                    Horizontal retaining walls defining the five Cascade Garden terraces
  Variations:                 6 (3 heights: 0.5m/1.0m/1.5m × 2 states: intact/crumbled)
  Poly Budget:                200–600 tris each
  Materials:                  2 (intact dressed stone, crumbled weathered stone)
  Notes:                      Includes embedded crystal inclusions visible in damaged sections
```

### 2.2 — Floors & Ceilings

```
ARK_FLOOR_SLAB                  Architecture | T1 | ALL DISTRICTS
  Purpose:                    Horizontal walking surfaces — the floors of every interior and paved exterior
  Variations:                 6 (3 sizes: 2m×2m/4m×4m/8m×8m × 2 finishes: interior-smooth/exterior-weathered)
  Poly Budget:                4–16 tris each (flat planes)
  Materials:                  2 (interior polished stone, exterior textured paving)
  Textures:                   Albedo (1024×1024 tileable), Normal (surface grain + cracks), Roughness
  Collision:                  Complex (these ARE the floor)

ARK_FLOOR_CRACKED               Architecture | T2 | LQ, AT, VC
  Purpose:                    Floor sections displaced by root growth or structural settling
  Variations:                 4 (minor crack, major fracture, lifted by roots, partially collapsed)
  Poly Budget:                50–200 tris each
  Materials:                  1 (damaged floor stone)
  Notes:                      Decal-based crack system for minor damage; geometry deformation for major damage

ARK_CEILING_VAULTED             Architecture | T2 | AT (original dome ring interior), SS
  Purpose:                    High vaulted ceilings in important spaces
  Variations:                 2 (intact vaulted, partially collapsed)
  Poly Budget:                500–1,500 tris per section
  Materials:                  1 (interior stone)
```

### 2.3 — Pillars & Columns

```
ARK_PILLAR_SQUARE               Architecture | T1 | AT, LQ, AV
  Purpose:                    Structural support pillars — load-bearing vertical elements
  Variations:                 4 (2 heights: 4m/8m × 2 states: intact/weathered)
  Poly Budget:                100–300 tris each
  Materials:                  2 (interior finished, weathered exterior)
  Collision:                  Simple (cylinder)

ARK_PILLAR_ENGRAVED             Architecture | T2 | AT (research alcoves), CR (platform perimeter)
  Purpose:                    Pillars with carved scientific engravings — measurement scales, astronomical notations
  Variations:                 2 (astronomy engravings, botany engravings)
  Poly Budget:                200–400 tris each
  Notes:                      Engravings are normal-mapped, not geometry
```

### 2.4 — Arches & Doorways

```
ARK_ARCH_STANDARD               Architecture | T1 | AT, GH, LQ, AV, CG
  Purpose:                    Standard First Delver arch — parabolic curve, wider at base
  Variations:                 4 (2 widths: 2m/4m × 2 states: intact/cracked)
  Poly Budget:                200–500 tris each

ARK_ARCH_PARABOLIC              Architecture | T1 | AV (Grand Archway — hero asset)
  Purpose:                    The monumental parabolic arch marking the Aviary entrance
  Variations:                 1 (hero — unique landmark, not modular)
  Poly Budget:                2,000–4,000 tris (hero asset)
  Materials:                  2 (iron framework, stone base)
  Notes:                      See landmark catalogue for full Grand Archway specification

ARK_DOORWAY_FRAME               Architecture | T1 | ALL DISTRICTS
  Purpose:                    Standard doorframe — opening in a wall without a door (doors were rarely used)
  Variations:                 3 (standard width, wide/cargo width, Sanctum reinforced width)
  Poly Budget:                100–200 tris each

ARK_DOOR_HEAVY                  Architecture | T1 | SS (Sanctum entrance — hero asset)
  Purpose:                    The heavy stone door at the Stasis Sanctum entrance — requires sustained push
  Variations:                 1 (hero — unique interaction, not modular)
  Poly Budget:                1,500–2,500 tris
  Animation:                  Simple (swing open — 90° rotation on hinge, player-triggered)
  Collision:                  Complex (animated collision — closed blocks passage, open allows passage)
  Interaction:                Sustained (3–5 second push to open)
  Sound:                      Stone grinding (opening), heavy thud (closing)
  Notes:                      See landmark catalogue for full Sanctum Entrance specification

ARK_DOORWAY_VINE_CURTAIN        Architecture | T2 | VC, AV, AT
  Purpose:                    Doorways and arches draped in hanging vines — architecture reclaimed
  Variations:                 3 (density: light/medium/heavy vine coverage)
  Poly Budget:                200–500 tris (vine curtain mesh + leaves)
  Materials:                  1 (vines with leaves)
  Animation:                  Simple (gentle sway in wind — vertex animation or shader)
  Shader:                     Foliage shader with wind animation
```

### 2.5 — Stairs & Ramps

```
ARK_STAIRS_STRAIGHT             Architecture | T1 | AT→CG, CG→LQ, LQ→AV, AV→CR
  Purpose:                    Straight staircases connecting elevation tiers
  Variations:                 5 (rise: 1m/2m/4m/8m/12m elevation gain)
  Poly Budget:                100–800 tris (depending on rise)
  Collision:                  Complex (precise step collision)

ARK_STAIRS_SPIRAL               Architecture | T2 | AT (broken dome access), CR (Resonance Core hatch area)
  Purpose:                    Spiral staircase — the broken one in the Atrium that once led above the dome
  Variations:                 2 (intact — SS interior; broken — AT)
  Poly Budget:                500–1,500 tris
  Notes:                      Broken variant has missing steps and collapsed sections — not traversable

ARK_STAIRS_SWITCHBACK           Architecture | T1 | AV→CR (the summit ascent ramp)
  Purpose:                    The broad switchback ramp climbing the southern face of the summit mass
  Variations:                 1 (hero traversal asset — unique to the Ark)
  Poly Budget:                2,000–3,000 tris
  Collision:                  Complex
  Notes:                      Wide (4–5m), engineered, with low retaining walls. The dramatic ascent.
```

### 2.6 — Windows

```
ARK_WINDOW_STANDARD             Architecture | T2 | LQ, AV, AT
  Purpose:                    Standard window openings in walls
  Variations:                 4 (3 sizes × 2 states: frame intact/glass shattered)
  Poly Budget:                50–200 tris each

ARK_WINDOW_DIRECTOR             Architecture | T2 | LQ (Director's Quarters — hero asset)
  Purpose:                    The large north-facing window in the Director's Quarters
  Variations:                 1 (hero)
  Poly Budget:                300–500 tris
  Notes:                      No glass — open frame. Frames the view of the Celestial Ring.
```

### 2.7 — Roofs

```
ARK_ROOF_FLAT_STONE             Architecture | T1 | LQ, CG (Germination Station), AV (Propagation Station)
  Purpose:                    Flat stone roof slabs
  Variations:                 2 (intact, partially collapsed)
  Poly Budget:                50–100 tris each

ARK_ROOF_DOME_RING              Architecture | T1 | AT (hero — the structural ring of the Shattered Dome)
  Purpose:                    The circular stone ring at +15m that once held the dome panels
  Variations:                 1 (hero landmark)
  Poly Budget:                3,000–5,000 tris (hero)
  Materials:                  2 (stone ring, crystal tether points)
  Notes:                      See landmark catalogue — Shattered Dome
```

---

## 3. ARCHITECTURE — METAL & GLASS STRUCTURES

### 3.1 — Iron Framework

```
ARK_IRON_ARCH                   Architecture | T1 | AV (the defining skeletal structure)
  Purpose:                    The iron arches forming the Aviary's structural framework — originally supported glass panels
  Variations:                 5 (arch segment, junction, base mount, damaged/rusted variant, vine-covered variant)
  Poly Budget:                300–800 tris each
  Materials:                  2 (rusted iron with resonance-preserved patches, vine-covered iron)
  Textures:                   Albedo (1024×1024), Normal, Roughness, Metallic
  Notes:                      The arches are the Aviary's visual signature. Modular segments snap together to form
                              the full ~40m×45m glasshouse framework. Vine coverage increases toward the eastern edge.

ARK_IRON_BEAM                   Architecture | T2 | GH (cargo cradle framework), CR (instrument supports)
  Purpose:                    Horizontal and angled iron beams for structural support
  Variations:                 3 (lengths: 2m/4m/8m × rusted finish)
  Poly Budget:                100–400 tris each

ARK_IRON_PLATFORM_FRAME         Architecture | T2 | GH (departure platform understructure), CR
  Purpose:                    Iron framework beneath stone platform surfaces
  Variations:                 2 (exposed — visible from below; concealed — under stone)
  Poly Budget:                500–1,000 tris per section
```

### 3.2 — Metal Details

```
ARK_METAL_HINGE                 Architecture | T2 | GH, LQ, SS
  Purpose:                    Door hinges — large iron fittings on heavy doors
  Variations:                 3 (standard door, heavy cargo door, Sanctum door)
  Poly Budget:                50–150 tris each

ARK_METAL_BRACKET               Architecture | T2 | GH, CR, AV
  Purpose:                    Metal support brackets connecting structural elements
  Variations:                 4 (wall bracket, corner bracket, beam connector, instrument mount)
  Poly Budget:                30–100 tris each

ARK_METAL_FASTENER              Architecture | T3 | ALL DISTRICTS (detail)
  Purpose:                    Bolts, rivets, and fasteners visible on metal structures
  Variations:                 3 (bolt head, rivet, clamp)
  Poly Budget:                8–24 tris each (instanced via MultiMesh for repeated use)
  Notes:                      Detail asset — used sparingly on hero surfaces, omitted on LOD1+
```

### 3.3 — Glass Structures

```
ARK_GLASS_PANE                  Architecture | T2 | AV (glasshouse remains), GH (quarantine windows)
  Purpose:                    Flat glass panels — originally part of the Aviary glasshouses and quarantine station
  Variations:                 4 (clear, amber resonance-treated, shattered, dust-coated)
  Poly Budget:                4 tris each (flat plane)
  Materials:                  3 (clear glass, amber glass, frosted/dusty glass)
  Textures:                   Albedo (512×512), Normal (crack pattern for shattered), Roughness, Emissive (amber only)
  Shader:                     Glass shader (transparent + reflection probe sampling)

ARK_GLASS_DOME_PANEL            Architecture | T1 | AT (Shattered Dome — hero landmark)
  Purpose:                    Individual hexagonal crystal panels of the Shattered Dome
  Variations:                 3 (suspended/floating — intact, tilted/drifting, fallen/on-floor)
  Poly Budget:                100–200 tris each (hexagonal crystal slab)
  Materials:                  3 (charged — glowing, discharged — clear, cracked — fractured)
  Animation:                  Simple (slow drift/rotation for suspended panels — procedural noise)
  Collision:                  None (floating panels — not reachable without flight)
  Interaction:                Examine (look up at dome triggers Journal entry)
  Shader:                     Crystal shader (refraction + emissive glow + caustic light projection)
  Sound:                      Resonance hum (ambient from dome as a whole), crystal chime (occasional contact)
  Notes:                      ~30 suspended panels + ~20 fallen fragments. See landmark catalogue — Shattered Dome.
```

---

## 4. ARCHITECTURE — BRIDGES, PLATFORMS & VERTICALITY

### 4.1 — Bridges

```
ARK_BRIDGE_STONE                Architecture | T1 | SS→CR (Sanctum Bridge — hero), CG→VC (stone bridge over channel)
  Purpose:                    Stone bridges spanning gaps between structures
  Variations:                 2 (10m Sanctum bridge — hero, exposed; 4m garden bridge — standard)
  Poly Budget:                500–2,000 tris (garden bridge), 2,000–4,000 tris (Sanctum bridge — hero)
  Collision:                  Complex
  Notes:                      The Sanctum bridge is the player's first vertical exposure — open sky both sides.
                              Low retaining walls (~0.5m). The garden bridge is narrow (single person width), intact.

ARK_BRIDGE_COLLAPSED            Architecture | T2 | GH-west (the broken bridge to the floating fragment — future hook)
  Purpose:                    A bridge that failed — visible remnant extending from the Gatehouse, ending in empty sky
  Variations:                 1
  Poly Budget:                1,000–2,000 tris
  Notes:                      Future grappling hook traversal. Currently: environmental storytelling (broken connection).

ARK_BRIDGE_VINE_NATURAL         Architecture | T2 | VC (Vine Bridge — natural formation across a structural crack)
  Purpose:                    Intertwined vines creating a natural bridge — teaches unconventional traversal
  Variations:                 1
  Poly Budget:                500–1,000 tris (dense vine mesh)
  Animation:                  Simple (sway under player weight)
  Collision:                  Simple (slightly bouncy surface)
```

### 4.2 — Platforms

```
ARK_PLATFORM_DEPARTURE          Architecture | T1 | GH (hero landmark)
  Purpose:                    The Departure Platform — wide stone platform projecting south from the Gatehouse
  Variations:                 1 (hero)
  Poly Budget:                1,500–2,500 tris
  Notes:                      30m long × 8m wide. No railing. Open sky. Docking clamps at edges.

ARK_PLATFORM_RING               Architecture | T1 | CR (hero landmark)
  Purpose:                    The Ring Platform — circular observation deck at the island's summit
  Variations:                 1 (hero)
  Poly Budget:                2,000–3,000 tris
  Notes:                      25m diameter circle. The highest constructed surface. See landmark catalogue.

ARK_PLATFORM_OBSERVATION        Architecture | T2 | CR (telescope pedestal), AV (upper gallery — inaccessible)
  Purpose:                    Small elevated platforms for specific instruments or viewpoints
  Variations:                 2 (instrument platform, observation platform)
  Poly Budget:                200–500 tris each
```

### 4.3 — Railings & Barriers

```
ARK_RAILING_LOW                 Architecture | T2 | SS bridge, CR platform edge, AV upper level
  Purpose:                    Low stone retaining wall serving as safety barrier — 0.5m height
  Variations:                 2 (intact, partially crumbled)
  Poly Budget:                50–150 tris per meter
  Notes:                      Deliberately low — provides visual security without blocking views.
                              The Departure Platform deliberately has NO railing.

ARK_RAILING_METAL               Architecture | T3 | AV (original glasshouse railings), CR (instrument platform)
  Purpose:                    Iron railings — mostly rusted, some sections missing
  Variations:                 2 (intact section, broken/missing section)
  Poly Budget:                100–200 tris per meter
```

---

## 5. ARCHITECTURE — RUINS & BROKEN STRUCTURES

### 5.1 — Collapsed Sections

```
ARK_RUIN_WALL_COLLAPSE          Ruins | T1 | LQ, VC, AT (northwest corridor)
  Purpose:                    Partially collapsed wall sections — walls that have crumbled, leaving gaps and rubble
  Variations:                 4 (minor collapse — small hole; major collapse — wall mostly gone; collapsed-with-roots;
                              collapsed-exposing-next-room)
  Poly Budget:                300–1,000 tris each
  Notes:                      These create the "partially collapsed corridor" connections described in the
                              Traversal Blueprint. The northwest Atrium→Living Quarters corridor uses this.

ARK_RUIN_CEILING_COLLAPSE       Ruins | T2 | LQ (attic), CG (Germination Station roof)
  Purpose:                    Fallen ceiling sections — roof slabs that have dropped, creating debris and openings
  Variations:                 3 (partially collapsed, fully collapsed — rubble pile, collapsed-with-beam)
  Poly Budget:                300–800 tris each

ARK_RUIN_FLOOR_COLLAPSE         Ruins | T2 | VC (Sunken Lab access), AT
  Purpose:                    Floor sections that have collapsed, revealing the space beneath
  Variations:                 3 (hole-with-rubble-edges, root-broken-floor, sunken-depression)
  Poly Budget:                200–600 tris each
  Notes:                      The Sunken Lab entrance in the Verdant Creep uses this — the player crawls through
                              a root cavity in a collapsed floor section.
```

### 5.2 — Structural Damage Details

```
ARK_DAMAGE_CRACK_LARGE          Detail | T2 | ALL DISTRICTS
  Purpose:                    Large structural cracks in walls and floors — evidence of 5,000 years of settling
  Variations:                 4 (wall crack, floor crack, ceiling crack, root-caused crack)
  Poly Budget:                N/A (decal system)
  Notes:                      Decal-based for minor cracks. Geometry deformation for major (walkable surface) cracks.

ARK_DAMAGE_SPALLING             Detail | T2 | ALL EXTERIOR STONE
  Purpose:                    Surface spalling — stone faces flaking off due to freeze-thaw cycling
  Variations:                 2 (minor surface spall, deep spall exposing crystal inclusions)
  Poly Budget:                N/A (normal map detail + decal for severe cases)
```

### 5.3 — Scattered Debris

```
ARK_DEBRIS_RUBBLE_PILE          Props | T1 | CG, VC, LQ, AT (collapsed corridor)
  Purpose:                    Accumulated stone rubble from collapsed walls and ceilings
  Variations:                 4 (small pile ~0.5m, medium pile ~1m, large pile ~2m, scattered-trail)
  Poly Budget:                100–500 tris each
  Collision:                  Simple (approximate mound shape)

ARK_DEBRIS_STONE_CHUNKS         Props | T2 | ALL DISTRICTS
  Purpose:                    Individual stone fragments scattered on floors — fallen from walls and ceilings
  Variations:                 6 (size: fist to torso; shape: angular, rounded-weathered, flat-slab, with-mortar-edge)
  Poly Budget:                20–100 tris each
  Notes:                      Placed as MultiMesh instances for common scatter. Hand-placed for storytelling.
```

---

## 6. VEGETATION — TREES, SHRUBS & FLORA

### 6.1 — Hero Trees (Unique, Hand-Placed, Full 3D)

```
VEG_TREE_COURTYARD              Vegetation | T1 | LQ (hero landmark — T1)
  Purpose:                    The Courtyard Tree — 45m tall, 1.2m trunk diameter, 25m canopy. The oldest living thing.
  Variations:                 1 (hero — unique mesh set)
  Poly Budget:                  Trunk: 5,000–8,000 tris. Major branches: 8–12 × 500–1,000 tris.
                                Canopy (inner): MultiMesh leaves, ~10,000 instances. Total: ~20,000 tris at LOD0.
  Materials:                  3 (silver-grey bark, deep-green leaves, exposed root wood)
  Textures:                   Albedo (2048×2048 bark), Albedo (512×512 leaf cluster), Normal, Roughness
  Animation:                  Complex (branch sway in wind — vertex animation on major branches;
                                leaf rustle — shader; seasonal leaf color change; seasonal leaf drop/growth)
  Collision:                  Complex (trunk and major roots — precise; canopy — none except climbable branches)
  LOD:                        3 levels (hero LOD0: full → LOD1: reduced branches, billboard canopy → LOD2: silhouette)
  Interaction:                Examine (children's carvings on trunk), Collect (medicinal bark), Climb (late-game)
  Shader:                     Foliage shader (wind, subsurface scattering on leaves, seasonal color)
  Sound:                      Wind through leaves (procedural — based on wind speed), branch creak, bird song
  Notes:                      See landmark catalogue for full specification. This is the most expensive single vegetation
                              asset. Its canopy is visible from most of the island — the LOD system is critical.

VEG_TREE_CANOPY_OAK             Vegetation | T1 | AT (3–4 through the dome), VC (canopy layer)
  Purpose:                    Large broadleaf trees forming the Atrium and Creep canopy — 20–30m tall
  Variations:                 4 (mature, young, root-exposed, Instrument Tree variant)
  Poly Budget:                  Trunk: 1,500–3,000 tris. Canopy leaves: MultiMesh ~5,000 instances. ~8,000 tris LOD0.
  Materials:                  2 (rough brown-grey bark, broad green leaves)
  Textures:                   Albedo (1024×1024 bark, 512×512 leaf), Normal, Roughness
  Animation:                  Complex (wind sway, seasonal leaf cycle)
  Collision:                  Complex (trunk only)
  LOD:                        3 levels
  Shader:                     Foliage shader
  Sound:                      Wind through leaves, branch creak

VEG_TREE_SPECIMEN               Vegetation | T1 | AV (5–8 hand-placed specimen trees — collection)
  Purpose:                    Unique tree species from the Aviary's living collection — ornamental and fruit-bearing
  Variations:                 5 (flowering ornamental, fruit tree, rare surface species, bioluminescent-bark, twisted-form)
  Poly Budget:                  Trunk: 1,000–2,500 tris each. Canopy: MultiMesh ~3,000 instances. ~6,000 tris LOD0.
  Materials:                  5 (species-specific bark and leaf materials)
  Notes:                      Each specimen tree is unique — not modular. They are part of the Aviary's identity as a
                              "living museum." Some bear recognizable fruit; others are the last of their kind.
```

### 6.2 — Instrument Tree (Hero Landmark)

```
VEG_TREE_INSTRUMENT             Vegetation | T1 | VC (hero landmark — T2)
  Purpose:                    The fig-like tree that grew through Monitoring Station 3 — instruments embedded in trunk
  Variations:                 1 (hero — unique)
  Poly Budget:                  Trunk + embedded instruments: 8,000–12,000 tris (hero). Canopy: MultiMesh ~5,000.
                                Total: ~17,000 tris LOD0.
  Materials:                  4 (tree bark, fig leaves, embedded brass instruments, embedded stone station walls)
  Animation:                  Complex (wind sway, instrument display flicker — emissive pulse)
  Collision:                  Complex (trunk — irregular shape around embedded station)
  Interaction:                Examine (coffee cup in trunk, instrument displays, researcher's notebook in root crevice)
  Shader:                     Foliage shader + emissive for instrument displays
  Notes:                      See landmark catalogue. The tree incorporated the station — the two are now one asset.
```

### 6.3 — Shrubs & Bushes

```
VEG_SHRUB_GENERIC               Vegetation | T1 | VC, CG, AV, AT
  Purpose:                    Mid-sized woody shrubs — understory vegetation throughout the island
  Variations:                 6 (size: 0.5m–2.5m tall; shape: rounded, spreading, columnar, arching, ground-hugging)
  Poly Budget:                100–500 tris each
  Materials:                  1 (shared shrub material with variant tinting via MultiMesh custom data)
  Animation:                  Simple (wind sway — vertex shader)
  Collision:                  Simple (capsule)
  LOD:                        2 levels (full → crossed billboard planes)
  Notes:                      Placed via Multimesh. ~500 instances island-wide.

VEG_BUSH_BERRY                  Vegetation | T1 | CG (middle terraces), AV (edges)
  Purpose:                    Berry-producing bushes — 3 species with edible/medicinal fruit
  Variations:                 3 (purple berry, red-orange medicinal berry, golden sweet berry)
  Poly Budget:                200–400 tris each
  Materials:                  3 (species-specific: leaf color, berry color)
  Animation:                  Simple (wind sway)
  Collision:                  Simple
  LOD:                        2 levels
  Interaction:                Resource collection (berries — seasonal)
  Shader:                     Foliage shader + emissive berry highlight (subtle — draws attention to ripe fruit)
  Notes:                      ~30 instances across the island. Seasonal: berries visible only during fruiting season.

VEG_SHRUB_MEDICINAL             Vegetation | T1 | CG (lower terraces), VC (damp areas)
  Purpose:                    Medicinal herb shrubs — 4 species with pharmaceutical properties
  Variations:                 4 (broad-leaf cool, fine-leaf silvery aromatic, succulent pale, tall purple-stem)
  Poly Budget:                100–300 tris each
  Materials:                  4 (species-specific)
  Interaction:                Resource collection (medicinal herbs — harvestable, plant regrows)
  Notes:                      Placed in species-specific habitats. See Resource Ecology document for spawn logic.
```

### 6.4 — Dead Trees & Stumps

```
VEG_TREE_DEAD                  Vegetation | T2 | VC, AT
  Purpose:                    Dead standing trees — killed by lightning, disease, or old age
  Variations:                 3 (recently dead — bark still on, long-dead — barkless weathered, broken-top snag)
  Poly Budget:                1,000–3,000 tris
  Materials:                  1 (weathered dead wood)
  Animation:                  None (no leaves — minimal wind response)
  Notes:                      Rare. A dead tree creates a canopy gap and a surge of wood/fungi resources.

VEG_STUMP_LARGE                Vegetation | T2 | VC, AT, CG
  Purpose:                    Large tree stumps — remains of fallen or cut trees
  Variations:                 3 (fresh cut-like, old weathered, fungi-colonized)
  Poly Budget:                200–600 tris
  Interaction:                Resource collection (rotting wood, fungi)
```

### 6.5 — Tree Roots (Exposed)

```
VEG_ROOT_EXPOSED               Vegetation | T1 | LQ (throughout — Courtyard Tree roots), AT, VC
  Purpose:                    Tree roots that have penetrated above the surface — through floors, along corridors
  Variations:                 6 (thin tendril, thick structural root, root-through-wall, root-lifting-floor,
                              root-cracking-stone, root-network-cluster)
  Poly Budget:                50–500 tris each
  Materials:                  1 (root wood — darker than trunk bark)
  Collision:                  Simple (larger roots are walkable surfaces or trip hazards; small roots are visual only)
  Notes:                      Critical to the Living Quarters' visual identity. Roots create natural ramps and paths.
```

---

## 7. VEGETATION — GROUND COVER, FUNGI & DECAY

### 7.1 — Grasses & Wildflowers

```
VEG_GRASS_WILD                 Vegetation | T1 | CG (upper terraces — meadow), AV (edges), AT (sunlit patches)
  Purpose:                    Wild grasses — feral descendants of cultivated grain on upper terraces; meadow species elsewhere
  Variations:                 4 (feral grain — tall golden, meadow mix — varied greens, short turf, edge/wind-pruned)
  Poly Budget:                N/A (MultiMesh grass cards — 8–24 tris per card, ~2000 instances island-wide)
  Materials:                  2 (feral grain gold, mixed meadow green)
  Animation:                  Complex (wind wave — vertex shader driven by wind system; seasonal color change)
  Collision:                  None (visual only)
  LOD:                        2 levels (full cards → simplified cards → faded)
  Shader:                     Grass shader (wind wave, camera-facing cards with variation)

VEG_FLOWER_WILD                Vegetation | T1 | AV (Pollinator Garden — highest density), CG (meadow), VC (clearings)
  Purpose:                    Wildflowers — 12 species, descendants of Aviary collection and wind-borne colonists
  Variations:                 12 (species by color: white, yellow, pink, red, blue, purple — each with 2 bloom stages)
  Poly Budget:                Camera-facing cards: 4–8 tris per flower. ~1500 instances in Aviary, ~500 elsewhere.
  Materials:                  12 (species-specific petal color + leaf)
  Animation:                  Simple (gentle sway)
  Collision:                  None
  LOD:                        2 levels (full flower → single card → faded)
  Shader:                     Foliage + emissive (subtle — for bioluminescent species at night)
  Notes:                      Eight of the 12 species are Ark-endemic. Four are surface colonists. The player
                              learns to distinguish them through observation.
```

### 7.2 — Vines & Climbing Plants

```
VEG_VINE_HANGING               Vegetation | T1 | AV (arch covering), VC (structural colonization), AT (walls)
  Purpose:                    Hanging and climbing vines — the primary vegetation reclaiming the architecture
  Variations:                 5 (thin tendril, thick woody vine, flowering vine — purple, flowering vine — white jasmine,
                              bioluminescent vine — blue-white night bloom)
  Poly Budget:                Variable — 50–300 tris per linear meter
  Materials:                  5 (species-specific)
  Animation:                  Simple (wind sway)
  Collision:                  None (visual only, except the Vine Bridge in VC which has collision)
  LOD:                        2 levels
  Shader:                     Foliage shader + emissive (bioluminescent variant — night only)

VEG_VINE_CURTAIN               Vegetation | T2 | AV (between arches), VC (dome interiors)
  Purpose:                    Dense hanging vine curtains — create natural walls and thresholds
  Variations:                 3 (density: light/medium/dense)
  Poly Budget:                300–800 tris per curtain section
  Collision:                  None (player walks through with vine push animation — vertex displacement)
  Animation:                  Complex (player interaction — vines part when walked through; wind sway;
                              vertex displacement on contact)
  Shader:                     Foliage + vertex displacement
```

### 7.3 — Moss & Lichens

```
VEG_MOSS_STONE                 Vegetation | T2 | ALL DISTRICTS (on damp stone surfaces)
  Purpose:                    Moss colonizing stone — indicates moisture and age
  Variations:                 3 (common green moss, resonance moss — blue-green bioluminescent, crustose lichen — grey)
  Poly Budget:                N/A (surface decal or shader-based — not geometry)
  Materials:                  3 (moss variants)
  Shader:                     Moss shader (applied to stone surface at specific angles/slopes during material blending)
  Notes:                      Resonance moss is a resource and prospecting indicator. Common moss is purely visual.

VEG_MOSS_CARPET                Vegetation | T2 | AT (fountain basin), VC (Fungal Grotto), CG (pool edges)
  Purpose:                    Thick moss carpet on consistently wet surfaces — soft underfoot
  Variations:                 2 (green moss, bioluminescent moss)
  Poly Budget:                Ground cover mesh: 100–300 tris per patch
  Materials:                  2
  Animation:                  Simple (slow bioluminescent pulse — 10–15s cycle)
  Interaction:                Resource collection (bioluminescent material)
```

### 7.4 — Fungi

```
VEG_FUNGI_MUSHROOM             Vegetation | T1 | VC (Fungal Grotto, fallen logs), CG (compost beds), AT (shade)
  Purpose:                    Mushrooms — the fruiting bodies of the island's fungal decomposition network
  Variations:                 9 (edible — tan cap, medicinal — dark red-gilled, bioluminescent — blue-green glow,
                              bracket — shelf on wood, tiny decomposer — leaf litter, tall slender,
                              clustered, cup-shaped, brain-textured)
  Poly Budget:                20–200 tris each (species-dependent)
  Materials:                  9 (species-specific cap and stem colors)
  Animation:                  Simple (bioluminescent species: slow glow pulse; growth animation: sprout → mature → decay)
  Collision:                  None (visual only — small)
  Interaction:                Resource collection (edible fungi, medicinal fungi, bioluminescent material)
  Shader:                     Foliage + emissive (bioluminescent species)
  Notes:                      Seasonal: most species fruit after rain. Bioluminescent species present year-round
                              in the stable Grotto conditions. ~200 instances total across the island.

VEG_FUNGI_MYCELIUM             Vegetation | T3 | VC (visible on rotting wood surfaces), CG (compost)
  Purpose:                    Visible fungal mycelium — white thread-like networks on decaying wood
  Variations:                 2 (fine web, thick cord-like)
  Poly Budget:                Decal or thin geometry overlay — 50–100 tris
  Materials:                  1 (white-translucent mycelium)
  Shader:                     Translucent with subtle animation (slow growth pulse)
```

### 7.5 — Fallen Wood & Organic Debris

```
VEG_LOG_FALLEN                 Vegetation | T1 | VC, AT, LQ (beneath Courtyard Tree)
  Purpose:                    Fallen tree trunks and large branches — the primary wood resource on the island
  Variations:                 5 (recently fallen — bark intact, decaying — bark peeling, heavily decayed — spongy,
                              fungi-colonized — mushrooms present, moss-covered)
  Poly Budget:                200–800 tris each
  Materials:                  3 (fresh wood, decaying wood, heavily decayed)
  Collision:                  Simple (players step over small logs, walk along large ones)
  Interaction:                Resource collection (wood, rotting wood, fungi)
  Notes:                      ~30 instances across the island. Decay state progresses over time (years).

VEG_BRANCH_FALLEN              Vegetation | T2 | LQ (Courtyard Tree), AT, VC
  Purpose:                    Individual fallen branches — smaller than logs, collected for wood
  Variations:                 4 (thin twig, medium branch, thick limb, forked branch)
  Poly Budget:                20–150 tris each
  Interaction:                Resource collection (wood)
  Notes:                      Seasonal: more appear after storms. ~100 instances at any time.
```

---

## 8. PROPS — LABORATORY & SCIENTIFIC EQUIPMENT

### 8.1 — Laboratory Furniture

```
PROP_WORKBENCH_LAB             Props | T1 | VC (Sunken Lab), AV (Propagation Station), CG (Germination Station)
  Purpose:                    Laboratory work surface — where Golden Age researchers conducted experiments
  Historical:                 Standard First Delver laboratory furniture — stone top, metal frame, built-in instrument mounts
  Variations:                 3 (large research bench, medium workstation, small instrument table)
  Poly Budget:                300–800 tris each
  Materials:                  3 (polished stone top, iron frame — rusted, brass fittings — patina)
  Collision:                  Simple
  Interaction:                Examine (notebooks, tools on surface)

PROP_SHELVING_LAB              Props | T1 | VC (Sunken Lab), AV, SS (Data Vault), LQ (Library)
  Purpose:                    Laboratory shelving — for specimen jars, equipment, and records
  Variations:                 4 (wall-mounted shelf, freestanding unit, data vault rack, specimen jar rack)
  Poly Budget:                100–400 tris each
  Materials:                  2 (stone shelving, metal brackets)

PROP_STOOL_LAB                 Props | T2 | VC, AV, CG
  Purpose:                    Simple wooden stool for laboratory seating
  Variations:                 2 (intact, broken/tilted)
  Poly Budget:                100–200 tris
```

### 8.2 — Scientific Instruments

```
PROP_INSTRUMENT_PANEL          Props | T1 | VC (Sunken Lab — monitoring panels), CR (Resonance Monitors), SS (Regulator)
  Purpose:                    Wall-mounted or desk-mounted instrument panel — displays, dials, controls
  Variations:                 6 (monitoring panel — readings only; control panel — interactive; damaged — flickering;
                              crystal interface — resonance; data recorder — mechanical; small sensor unit)
  Poly Budget:                200–800 tris each
  Materials:                  4 (brass face, crystal display, iron housing, amber glass indicators)
  Animation:                  Complex (functional panels: animated dial movement, flickering displays, glowing indicators.
                              Non-functional: static or dark.)
  Collision:                  Simple (wall-mounted — no player collision)
  Interaction:                Examine (read data), Activate (functional panels — view readings, access logs)
  Shader:                     Standard PBR + emissive for displays and indicators
  Sound:                      Soft hum (active panels), click (interaction)

PROP_TELESCOPE_GREAT           Props | T1 | CR (hero landmark — T2)
  Purpose:                    The Great Telescope — primary astronomical instrument of the Ark
  Variations:                 1 (hero — unique landmark)
  Poly Budget:                  Tube: 2,000–3,000 tris. Equatorial mount: 2,000–3,000 tris. Crystal optics: 500 tris.
                                Total: ~6,000 tris LOD0.
  Materials:                  4 (brass tube — patina, iron mount — rusted, crystal optics — clouded, stone pedestal)
  Animation:                  Complex (mount rotation — currently frozen, becomes interactive after repair;
                                optics focus — interactive after repair)
  Collision:                  Complex (pedestal — walkable around; tube — overhead obstacle)
  Interaction:                Examine, Activate (look through — currently blurry; align optics — repair interaction)
  Sound:                      Mechanical creak (on attempted movement), resonance hum, satisfying click (aligned)
  Notes:                      See landmark catalogue for full specification. Repairable — states: clouded, cleaned,
                              aligned, enhanced.

PROP_MONITOR_RESONANCE         Props | T1 | CR (hero — part of Ring Platform)
  Purpose:                    The Resonance Monitors — display panels showing array health, crystal stability, decay curves
  Variations:                 1 (hero — unique, part of Celestial Ring)
  Poly Budget:                1,000–2,000 tris (panel array)
  Animation:                  Complex (animated readouts, pulsing indicators, scrolling data)
  Interaction:                Examine (read array status, notice 200-year-old maintenance anomaly)
  Sound:                      Low resonance hum, soft data-scroll sound

PROP_WEATHER_STATION           Props | T1 | CR, CG (smaller agricultural unit)
  Purpose:                    Meteorological instruments — anemometer, barometer, rain gauge, data recorder
  Variations:                 2 (full station — CR; small agricultural unit — CG)
  Poly Budget:                500–1,500 tris
  Animation:                  Complex (anemometer spins — wind-driven; barometer needle moves; data drum rotates)
  Interaction:                Examine (read current weather, access 5,000-year data archive)
  Sound:                      Anemometer whir (wind-speed-dependent), ticking (data recorder)

PROP_INSTRUMENT_OPTICAL        Props | T2 | CR, AV, VC
  Purpose:                    Small optical instruments — lenses, spectrometers, measurement devices
  Variations:                 4 (lens assembly, spectrometer tube, measurement caliper, optical bench)
  Poly Budget:                100–400 tris each

PROP_INSTRUMENT_CHEMISTRY      Props | T2 | VC (Sunken Lab), AV (Propagation Station)
  Purpose:                    Chemistry apparatus — flasks, beakers, condensers, retorts, tubing
  Variations:                 8 (round flask, beaker, condenser tube, retort, mortar/pestle, tubing coil,
                              crystal growth vessel, heating element)
  Poly Budget:                50–300 tris each
  Materials:                  2 (clear glass, amber glass)
```

### 8.3 — Observatory Equipment

```
PROP_OBSERVATORY_CHART         Props | T2 | CR, AT (research alcoves)
  Purpose:                    Star charts, celestial maps, and astronomical diagrams — mounted on walls or tables
  Variations:                 4 (star chart — wall-mounted, lunar map, planetary orbit diagram, spectral chart)
  Poly Budget:                4 tris (flat plane with texture) — the texture IS the asset
  Textures:                   Albedo (1024×1024 per chart — hand-illustrated astronomical diagrams)
  Notes:                      These are information assets as much as visual assets. The player reads actual data from them.

PROP_STANDING_STONE            Props | T1 | CR (hero landmark — 8 unique monoliths)
  Purpose:                    The Standing Stones — celestial calibration markers ringing the Ring Platform
  Variations:                 8 (each is unique — different shape, different alignment, different inscriptions)
  Poly Budget:                500–1,500 tris each
  Materials:                  2 (dark blue-grey stone, crystal inclusions — emissive)
  Animation:                  None (static monoliths)
  Collision:                  Complex (tall narrow obstacles)
  Interaction:                Examine (read layered inscriptions — Golden Age to K)
  Shader:                     Standard PBR + emissive crystal inclusions (glow at night)
  Notes:                      See landmark catalogue. The crystal inclusions make each stone a functional resonance marker.
```

### 8.4 — Ancient Machinery

```
PROP_MACHINERY_SLUICE          Props | T1 | CG (all terraces)
  Purpose:                    Sluice gate mechanism — controls water flow through the irrigation channels
  Variations:                 3 (intact — movable, partially stuck, broken/seized)
  Poly Budget:                300–600 tris each
  Animation:                  Complex (gate raises/lowers — player-interactive; water flow changes in response)
  Collision:                  Simple
  Interaction:                Activate (adjust water flow — teaches environmental manipulation)
  Sound:                      Stone grinding (movement), water flow change

PROP_MACHINERY_CARGO_CRADLE    Props | T1 | GH
  Purpose:                    Cargo handling equipment — the docking clamps and cradles for supply airships
  Variations:                 3 (cradle frame, docking clamp — open, docking clamp — closed/seized)
  Poly Budget:                500–1,000 tris each
  Materials:                  2 (iron framework — heavily rusted, stone base)
  Interaction:                Examine (read cargo labels, manifests)

PROP_MACHINERY_LIFT             Props | T2 | CG (beside reservoir — broken), CR (Resonance Core hatch area)
  Purpose:                    Mechanical lift mechanisms — for vertical transport of equipment and personnel
  Variations:                 2 (broken lift — CG, sealed hatch lift — CR)
  Poly Budget:                500–1,000 tris
  Notes:                      CG lift is broken — environmental storytelling (maintenance deferred).
                              CR hatch is sealed — future progression gate.
```

---

## 9. PROPS — FURNITURE & DOMESTIC OBJECTS

### 9.1 — Seating

```
PROP_CHAIR_WOODEN              Props | T1 | LQ (all rooms), AT (research alcoves)
  Purpose:                    Simple wooden chair — standard seating throughout the Ark
  Variations:                 4 (intact, overturned, broken leg, root-entangled)
  Poly Budget:                100–250 tris each
  Materials:                  1 (aged wood)

PROP_BENCH_STONE               Props | T1 | AT, GH (waiting area), AV (Memory Garden)
  Purpose:                    Stone bench — fixed seating in public areas
  Variations:                 3 (standard, weathered, moss-covered)
  Poly Budget:                150–300 tris

PROP_STOOL_WORK                Props | T2 | VC, AV, CG
  Purpose:                    Simple work stool — for laboratory and garden use
  Variations:                 2 (intact, broken)
  Poly Budget:                80–150 tris
```

### 9.2 — Tables & Surfaces

```
PROP_TABLE_DINING              Props | T1 | LQ (Common Room)
  Purpose:                    Communal dining table — where the Ark's residents ate together
  Variations:                 2 (intact — with place settings, cleared)
  Poly Budget:                300–600 tris
  Materials:                  1 (aged wood top, stone base)

PROP_TABLE_WORK                Props | T1 | LQ (Director's Quarters, private rooms), AV
  Purpose:                    Personal work desk — for writing, reading, small tasks
  Variations:                 4 (Director's desk — with papers, standard desk, overturned, cluttered-with-personal-effects)
  Poly Budget:                200–500 tris each
  Notes:                      The Director's desk is a specific storytelling prop — positioned facing the window,
                              with the Director's journal and a resonance-locked drawer.

PROP_TABLE_SIDE                Props | T2 | LQ, AT (alcoves)
  Purpose:                    Small side table — next to beds, beside seating
  Variations:                 2 (intact, tilted/broken leg)
  Poly Budget:                80–200 tris
```

### 9.3 — Beds & Bedding

```
PROP_BED_SINGLE                Props | T1 | LQ (private quarters)
  Purpose:                    Simple bed frame with bedding — where residents slept
  Variations:                 4 (neatly made, blankets turned down, disheveled/abandoned, child's bed — smaller)
  Poly Budget:                300–600 tris each
  Materials:                  2 (wooden frame, fabric bedding — faded colors)
  Notes:                      The "blankets turned down" variant is a specific storytelling detail — someone
                              was about to sleep when the evacuation was called. Highly evocative.
```

### 9.4 — Domestic Objects

```
PROP_MUG_CERAMIC               Props | T1 | AT (alcove — half-finished cup), LQ (kitchen)
  Purpose:                    Ceramic drinking vessel — everyday object, powerfully humanizing
  Variations:                 4 (intact, half-full — petrified contents, overturned, chipped)
  Poly Budget:                50–100 tris each

PROP_PLATE_BOWL                Props | T2 | LQ (kitchen, Common Room)
  Purpose:                    Ceramic plates and bowls — dining ware
  Variations:                 3 (plate, bowl, serving dish)
  Poly Budget:                30–80 tris each

PROP_UTENSIL                   Props | T3 | LQ (kitchen)
  Purpose:                    Metal and wooden eating/cooking utensils
  Variations:                 4 (spoon, fork, knife, cooking ladle)
  Poly Budget:                20–50 tris each

PROP_MUSIC_BOX                 Props | T1 | LQ (family quarters — hero T3 landmark)
  Purpose:                    Child's mechanical music box — plays a lullaby when wound
  Variations:                 1 (hero — unique interactive prop)
  Poly Budget:                300–500 tris
  Animation:                  Complex (winding key rotates, internal mechanism visible through small window,
                              music plays — timed audio)
  Interaction:                Activate (wind the music box — triggers Memory Fragment: The Lullaby)
  Sound:                      Lullaby melody — the first music the player hears. Delicate, mechanical, fragile.
  Notes:                      One of the most emotionally significant objects on the Ark. See landmark catalogue.

PROP_LUGGAGE_CASE              Props | T1 | GH (Left Luggage — hero storytelling prop)
  Purpose:                    A single abandoned case on the Gatehouse bench — someone packed but never left
  Variations:                 1 (hero — specific storytelling object)
  Poly Budget:                200–400 tris
  Materials:                  2 (aged leather/fabric exterior, brass fittings)
  Interaction:                Examine (contains personal effects — humanizing detail about the evacuation)

PROP_FRAME_PICTURE             Props | T3 | LQ (private quarters)
  Purpose:                    Picture frames — personal images of Ark residents and families
  Variations:                 3 (family portrait, landscape of surface world, child's drawing — framed)
  Poly Budget:                50–100 tris (frame) + 4 tris (image plane)
  Textures:                   Albedo (512×512 — hand-painted personal images)
```

---

## 10. PROPS — CONTAINERS, STORAGE & BOOKS

### 10.1 — Storage Containers

```
PROP_JAR_STORAGE               Props | T1 | CG (Germination Station), AV (Propagation Station), SS (sample repository)
  Purpose:                    Ceramic storage jars — for seeds, specimens, and supplies
  Variations:                 6 (small, medium, large × labeled with coding system, unlabeled)
  Poly Budget:                50–200 tris each
  Materials:                  1 (glazed ceramic with coded label bands)
  Notes:                      The label bands use the Ark's information coding system — color + symbol. The player
                              learns to read these. ~40 instances across the island.

PROP_CRATE_WOODEN              Props | T2 | GH, CG, AV
  Purpose:                    Wooden shipping crates — for cargo transport between islands
  Variations:                 3 (intact sealed, open empty, broken)
  Poly Budget:                100–250 tris

PROP_CHEST_RESONANCE           Props | T1 | LQ (Director's Quarters — hero)
  Purpose:                    Resonance-locked personal chest — contains the Director's most private items
  Variations:                 1 (hero — unique)
  Poly Budget:                400–800 tris
  Materials:                  2 (stone body, crystal lock mechanism — glowing)
  Animation:                  Complex (lock responds to resonance frequency matching — crystal glow changes;
                              lid opens when unlocked)
  Interaction:                Activate (resonance tuning puzzle — match the Director's frequency)
  Sound:                      Resonance hum (locked), satisfying crystal chime (unlocked)
  Notes:                      Locked until the player recovers the memory of the frequency. Major progression gate.

PROP_CABINET_STONE             Props | T2 | SS (Data Vault), LQ (Library)
  Purpose:                    Stone storage cabinets — built-in, durable, designed for document preservation
  Variations:                 2 (closed, open — shelves visible)
  Poly Budget:                200–500 tris
```

### 10.2 — Books, Scrolls & Documents

```
PROP_BOOK_STACK                Props | T1 | LQ (Library, Common Room, Director's Quarters)
  Purpose:                    Books — the Ark's accumulated knowledge in physical form
  Variations:                 6 (single book — closed, single book — open, stack of 3, stack of 5,
                              scattered pile, book with bookmark)
  Poly Budget:                20–100 tris per book; stacks are combined meshes
  Materials:                  2 (aged leather binding, aged paper)
  Textures:                   Albedo (512×512 — book covers with legible titles at close range)
  Interaction:                Examine (read excerpts — triggers Codex entries and lore)
  Notes:                      ~150 individual books across the island (stacks count as one asset each).
                              Some have specific readable text. Most have atmospheric generic content.

PROP_SCROLL                    Props | T2 | LQ, SS
  Purpose:                    Rolled scrolls and documents — alternative recording medium
  Variations:                 3 (rolled — tied, unrolled — flat, partially unrolled)
  Poly Budget:                30–100 tris

PROP_PAPER_LOOSE               Props | T2 | LQ (Director's desk, Common Room), AT (alcoves)
  Purpose:                    Loose papers, letters, notes — scattered on surfaces
  Variations:                 5 (single sheet, stack of papers, letter — folded, note — crumpled, half-written letter)
  Poly Budget:                4–20 tris each (flat planes)
  Notes:                      The half-written letter in the Living Quarters is a specific storytelling prop —
                              "Dearest [name], The evacuation is scheduled..."
```

### 10.3 — Seed & Specimen Storage

```
PROP_SEED_TRAY                 Props | T1 | CG (Germination Station), AV (Propagation Station)
  Purpose:                    Seed starting trays — where new plants were germinated
  Variations:                 3 (empty, with soil, with seedlings — ancient, desiccated)
  Poly Budget:                100–250 tris
  Notes:                      The Germination Station trays contain ancient seeds in dried mud — some still viable.

PROP_SPECIMEN_CASE             Props | T2 | SS, AV
  Purpose:                    Glass-fronted specimen display/storage case — for the botanical collection
  Variations:                 2 (empty, with preserved specimen inside)
  Poly Budget:                200–400 tris
  Materials:                  2 (stone/wood frame, glass front)
```

---

## 11. PROPS — DEBRIS, DECAY & AMBIENT DETAIL

### 11.1 — Structural Debris

```
PROP_DEBRIS_STONE_FRAGMENT     Props | T1 | ALL DISTRICTS
  Purpose:                    Small stone fragments — chips, flakes, and chunks from weathered architecture
  Variations:                 8 (size: pebble to head-sized; shape: angular fresh, rounded weathered, flat slab,
                              with crystal inclusion, with moss, with lichen)
  Poly Budget:                10–80 tris each — placed as MultiMesh (~500 instances island-wide)
  Notes:                      Ambient detail. Not individually interactive.

PROP_DEBRIS_METAL_SCRAP        Props | T2 | GH, CR, VC
  Purpose:                    Small metal fragments — rusted flakes, broken fittings, wire remnants
  Variations:                 4 (iron flake, bent nail, wire coil, broken bracket)
  Poly Budget:                10–50 tris each — MultiMesh
```

### 11.2 — Organic Debris

```
PROP_DEBRIS_LEAF_PILE          Props | T2 | VC, AT, AV, LQ
  Purpose:                    Accumulated fallen leaves in corners and depressions
  Variations:                 3 (fresh leaves, dry leaves, decomposing dark mass)
  Poly Budget:                50–200 tris per pile (combined mesh)
  Notes:                      Seasonal variation. Denser in autumn. Decomposing piles transition toward humus.

PROP_DEBRIS_BIRD_NEST          Props | T2 | AV (arches), AT (canopy), LQ (Courtyard Tree)
  Purpose:                    Bird nests — in structural corners and tree branches
  Variations:                 3 (active — with eggs/feathers, abandoned — empty, ancient — accumulated layers)
  Poly Budget:                100–300 tris
```

### 11.3 — Personal Debris (Storytelling)

```
PROP_DRAWING_CHILD             Props | T1 | AT (under crystal fragment), LQ (Children's Room)
  Purpose:                    Children's drawings — the Ark from a child's perspective. Powerful humanizing detail.
  Variations:                 4 (Ark-and-sun drawing, stick-figure family, airship arriving, "Goodbye" departure drawing)
  Poly Budget:                4 tris (paper plane) — the texture IS the asset
  Textures:                   Albedo (512×512 — hand-drawn child's artwork, colored with crayon/paint equivalents)
  Notes:                      Found in specific locations as storytelling props. The "Goodbye" drawing shows
                              a figure on the Departure Platform waving. Labeled in child's handwriting.

PROP_HEIGHT_MARKINGS           Props | T1 | GH (doorframe — hero detail)
  Purpose:                    A child's growth recorded on a doorframe — dated marks spanning ~8 years
  Variations:                 1 (hero detail — unique to the Gatehouse doorframe)
  Poly Budget:                N/A (decal on doorframe mesh)
  Textures:                   Albedo (512×512 — hand-marked lines with dates)
  Interaction:                Examine (triggers Journal entry about the child who grew up here)
```

---

## 12. WATER ASSETS

### 12.1 — Water Bodies

```
WATER_RESERVOIR                Water | T1 | CG
  Purpose:                    The Central Reservoir — 15m×8m stone basin, primary water source
  Poly Budget:                500–1,000 tris (basin geometry) + water surface plane
  Materials:                  2 (stone basin, water surface)
  Shader:                     Water shader (reflection, refraction, subtle flow animation, sky reflection)
  Animation:                  Complex (water surface — procedural ripple, overflow cascade, seasonal level change)
  Sound:                      Gentle lapping, overflow cascade, rain-on-water (weather-dependent)

WATER_CHANNEL                  Water | T1 | CG (throughout — irrigation channels)
  Purpose:                    Stone-lined irrigation channels carrying water from reservoir to terraces
  Variations:                 3 (straight section, curved section, junction/sluice point)
  Poly Budget:                100–300 tris per meter (channel geometry) + flowing water surface
  Animation:                  Complex (flowing water — velocity varies by channel section and sluice gate position)
  Sound:                      Flowing water (variable by flow rate), water-over-stone

WATER_POOL_SETTLING            Water | T1 | CG (3 pools at terrace transitions)
  Purpose:                    Settling pools — still water for sediment filtration, aquatic plant habitat
  Poly Budget:                200–500 tris each (pool geometry) + water surface
  Animation:                  Simple (still water — subtle surface movement, aquatic plant sway)
  Sound:                      Still water ambience, frog calls (evening), insect sounds

WATER_FOUNTAIN                 Water | T1 | AT
  Purpose:                    The Atrium fountain — the visible endpoint of the Ark's water system
  Poly Budget:                300–600 tris (fountain basin + central spout) + falling water particles
  Animation:                  Complex (falling water — particle system; bioluminescent moss glow — emissive pulse;
                              water surface — procedural ripple)
  Sound:                      Falling water (constant, gentle), water-in-basin
  Notes:                      The fountain is the first thing most players examine. Flowing water + bioluminescent
                              moss = immediate visual and audio interest. Still functioning after 5,000 years.
```

### 12.2 — Water Effects

```
VFX_WATERFALL_SMALL            VFX | T2 | CG (reservoir overflow, channel drops)
  Purpose:                    Small waterfalls where water drops between terrace levels
  Poly Budget:                Particle system — not geometry
  Animation:                  Complex (particle-based falling water, mist at impact point)
  Sound:                      Falling water (pitch/intensity varies by drop height)

VFX_WATER_DRIP                 VFX | T2 | VC (Fungal Grotto, drainage areas), AT
  Purpose:                    Dripping water — from ceilings, roots, and structural cracks
  Poly Budget:                Particle system (single droplets) + decal (wet spot on ground)
  Animation:                  Complex (irregular drip timing — procedural)
  Sound:                      Water drip (random interval — 2–15 seconds), echo in enclosed spaces

VFX_WATER_RAIN_RIPPLES         VFX | T2 | ALL EXTERIOR WATER
  Purpose:                    Rain impact ripples on water surfaces — weather-responsive
  Poly Budget:                Shader effect on water surface (not geometry)
  Animation:                  Complex (procedural ripple generation at rain impact points — driven by weather system)
```

---

## 13. CRYSTAL & RESONANCE ASSETS

### 13.1 — Crystal Formations

```
CRYSTAL_SHARD_SMALL            Crystal | T1 | ALL DISTRICTS (where resonance infrastructure exposed)
  Purpose:                    Small crystal fragments — thumbnail to palm-sized. The player's first resonance resource.
  Variations:                 6 (size gradations × 2 charge states: charged — glowing blue-white; discharged — clear)
  Poly Budget:                20–100 tris each
  Materials:                  2 (charged crystal — emissive, discharged crystal — transparent)
  Animation:                  Simple (charged: subtle glow pulse; discharged: static)
  Collision:                  None (small — visual and collectible)
  Interaction:                Collect (resource gathering)
  Shader:                     Crystal shader (refraction + interior lattice structure + emissive pulse when charged)
  Sound:                      Soft hum (charged — audible at close range), glassy clink (when collected)

CRYSTAL_SHARD_LARGE            Crystal | T1 | CR (telescope optics, monitors), SS (stasis chambers, Regulator)
  Purpose:                    Large crystal elements — fist-sized or larger. Purpose-grown for Golden Age instruments.
  Variations:                 4 (optical lens, sensor crystal, stasis field generator, regulator interface crystal)
  Poly Budget:                200–800 tris each
  Materials:                  4 (application-specific — each has unique visual properties)
  Animation:                  Complex (stasis crystals: slow field shimmer; regulator: interactive glow; monitors: data pulse)
  Collision:                  Simple
  Interaction:                Examine, Collect (from non-functional equipment — consequential choice)
  Notes:                      Each large crystal is a unique, irreplaceable resource. See Resource Ecology document.

CRYSTAL_DOME_PANEL             Crystal | T1 | AT (Shattered Dome — see Section 3.3 ARK_GLASS_DOME_PANEL)
  Purpose:                    Hexagonal dome panels — the largest crystal elements on the Ark
  Notes:                      Detailed in Architecture section. Listed here for crystal category completeness.
```

### 13.2 — Resonance Effects

```
VFX_RESONANCE_GLOW             VFX | T1 | ALL DISTRICTS (where charged crystals present)
  Purpose:                    The characteristic blue-white luminescence of charged resonance crystals
  Poly Budget:                Shader effect — not geometry
  Animation:                  Complex (slow pulse — frequency varies by crystal; intensity proportional to charge;
                              color shifts subtly with crystal health)
  Shader:                     Emissive pulse shader (on crystal materials)
  Notes:                      This is the game's signature visual effect. Applied to all charged crystal materials.
                              The glow is information — color = crystal type, intensity = charge level, pulse = health.

VFX_RESONANCE_HUM_AMBIENT      Audio | T1 | AT (dome), CR (monitors), SS (stasis fields), VC (near Sunken Lab)
  Purpose:                    The ambient resonance hum — the sound of the island's crystal arrays
  Notes:                      Detailed in Audio section. Listed here for cross-reference.

VFX_STASIS_FIELD               VFX | T1 | SS (all stasis chambers)
  Purpose:                    Visible preservation field — shimmering air within active stasis chambers
  Poly Budget:                Shader effect on chamber interior volume
  Animation:                  Complex (slow shimmer — like heat haze but more ordered; geometric interference patterns;
                              color: pale blue-white; the Empty Chamber's field is the most visible)
  Shader:                     Volumetric shimmer shader (rayleigh scattering approximation + geometric patterns)
  Notes:                      The stasis field is the visual indicator that these chambers are ACTIVE — they are
                              not dead ruins, they are functioning preservation systems.
```

---

## 14. EFFECTS & PARTICLES

### 14.1 — Atmospheric Particles

```
VFX_DUST_MOTES                 VFX | T2 | AT (in sun shafts), LQ, SS
  Purpose:                    Floating dust particles visible in light beams — indicates still air and age
  Poly Budget:                GPU particle system
  Animation:                  Complex (slow drift — influenced by player movement and air currents)

VFX_SPORES                     VFX | T1 | VC (Fungal Grotto, throughout)
  Purpose:                    Fungal spores drifting in the Creep's humid air — visible in light shafts
  Poly Budget:                GPU particle system
  Animation:                  Complex (slow drift, gentle upward bias — thermal currents; bioluminescent particles glow)
  Shader:                     Particle shader + emissive (bioluminescent variant)

VFX_POLLEN                     VFX | T2 | AV, CG (during flowering season)
  Purpose:                    Pollen particles in the air — visible near flowering plants
  Poly Budget:                GPU particle system
  Animation:                  Complex (wind-driven drift; seasonal — appears only during flowering periods)
```

### 14.2 — Environmental Particles

```
VFX_FOG_VOLUME                 VFX | T1 | VC (interior humidity), CG (lower terraces — morning mist), AT (dawn)
  Purpose:                    Volumetric fog and mist — creates atmosphere, limits visibility strategically
  Poly Budget:                Shader effect (not geometry) + fog volume zones
  Animation:                  Complex (density varies with time of day, weather, and season;
                              flows with wind; dissipates in direct sun)
  Shader:                     Volumetric fog shader (ray-marched or analytical based on performance budget)
  Notes:                      Used sparingly. The Creep's disorienting quality comes partially from fog reducing
                              visibility to 3–8 meters. The Gatehouse has no fog (wind clears it).

VFX_CLOUDS_VOLUMETRIC          VFX | T1 | Sky system (all exterior views)
  Purpose:                    Volumetric cloud layer below and around the island
  Poly Budget:                Procedural sky shader + cloud texture sampling
  Animation:                  Complex (cloud formation, movement, dissipation — driven by weather system;
                              player can see other islands appear/disappear as clouds shift)
  Notes:                      Critical to the game's visual identity. The Ark is ABOVE the clouds — they are
                              below and around, not above. Cloud breaks reveal the surface world.
```

### 14.3 — Light & Prismatic Effects

```
VFX_LIGHT_PRISMATIC            VFX | T1 | AT (Shattered Dome — signature effect)
  Purpose:                    Prismatic light patterns from sunlight passing through crystal dome panels
  Poly Budget:                Shader + light function (not geometry)
  Animation:                  Complex (moving color patterns on walls and floor; shifts with sun angle;
                              intensity varies with cloud cover; different crystal panels create different patterns)
  Shader:                     Caustic-like light projection shader (crystal refraction simulation)
  Notes:                      This is THE signature visual effect of the Atrium. It communicates: this place is
                              special, this place is scientific, this place is beautiful.

VFX_LIGHT_BIOLUMINESCENT       VFX | T1 | AT (fountain moss), VC (Fungal Grotto fungi), AV (Memory Garden flower)
  Purpose:                    Bioluminescent glow — living light from moss, fungi, and the Director's flower
  Poly Budget:                Emissive material + subtle point light (limited — only hero bioluminescent sources)
  Animation:                  Complex (slow pulse cycle: 10–15s; intensity increases at night; some species
                              respond to player proximity — subtle brightening)
  Shader:                     Emissive pulse shader on biological materials
  Notes:                      Bioluminescence is the Ark's nighttime lighting system. It is not bright enough
                              to navigate by (except in the Fungal Grotto) but creates atmosphere and direction.

VFX_LIGHT_GODRAYS              VFX | T2 | VC, AT, AV
  Purpose:                    Volumetric light shafts — sunbeams through canopy gaps and structural openings
  Poly Budget:                Screen-space effect (not geometry)
  Animation:                  Complex (shafts shift with sun angle; visible only when dust/spores/mist present;
                              intensity varies with atmospheric conditions)
```

### 14.4 — Weather Particles

```
VFX_RAIN                       VFX | T1 | ALL EXTERIOR
  Purpose:                    Rainfall — driven by the weather system
  Poly Budget:                GPU particle system (screen-space rain + world-space splash particles)
  Animation:                  Complex (intensity varies: drizzle → steady rain → storm; wind affects angle;
                              sound varies with surface type)
  Sound:                      Rain-on-stone, rain-on-leaves, rain-on-water (multi-layered, surface-dependent)

VFX_WIND_LINE                  VFX | T2 | CR (visible wind streaks), GH (wind through open doors)
  Purpose:                    Visualized wind — dust/particle streaks showing airflow
  Poly Budget:                GPU particle system (sparse, directional)
  Animation:                  Complex (direction and speed driven by wind system)
```

---

## 15. LIGHT SOURCES

### 15.1 — Natural Light

```
LIGHT_SUN                      Lighting | T1 | ALL EXTERIOR
  Purpose:                    Directional sunlight — the primary illumination source
  Type:                       DirectionalLight3D (Godot) or equivalent directional light
  Animation:                  Complex (day/night cycle — color temperature shifts: warm dawn → neutral midday →
                              warm dusk; intensity varies with cloud cover; seasonal angle variation)
  Notes:                      Driven by TimeManager autoload. Not an "asset" in the mesh sense but listed for
                              production completeness.

LIGHT_MOON_DUAL                Lighting | T1 | ALL EXTERIOR (night)
  Purpose:                    Dual moon lighting — Luth (primary, warm silver) and Kell (secondary, cool blue-white)
  Type:                       DirectionalLight3D (moonlight) × 2
  Animation:                  Complex (lunar phase cycles — Luth: 28-day, Kell: irregular; both track across sky)
  Notes:                      Moonlight is cooler and dimmer than sunlight. Creates silver-blue night ambience.
```

### 15.2 — Artificial Light (Golden Age — Still Functional)

```
LIGHT_AMBER_STRIP              Lighting | T1 | SS (emergency ceiling/floor strips), GH (Quarantine Station)
  Purpose:                    Amber emergency lighting — still functioning after 5,000 years
  Type:                       Emissive material (primary) + subtle point light for hero instances
  Variations:                 2 (ceiling strip, floor strip)
  Animation:                  Simple (constant glow — no flicker; these systems are stable)
  Color:                      Warm amber (#D8A040)
  Notes:                      The Sanctum's only light source. Creates the distinctive amber-dark atmosphere.

LIGHT_CRYSTAL_GLOW             Lighting | T1 | AT (dome panels), SS (stasis chambers), CR (monitors, stone inclusions)
  Purpose:                    Crystal luminescence — the side-effect glow of charged resonance crystals
  Type:                       Emissive material (all instances) + point light for hero crystals
  Color:                      Pale blue-white (#C8D8F0)
  Animation:                  Complex (slow pulse — intensity varies with crystal charge and health)
```

### 15.3 — Bioluminescent Light

```
LIGHT_BIOLUM_MOSS              Lighting | T1 | AT (fountain), VC (Grotto), AV (Memory Garden flower)
  Purpose:                    Bioluminescent moss and fungi glow — living light
  Type:                       Emissive material (ambient) + subtle area light for dense clusters
  Color:                      Blue-green (#7EB8B0)
  Animation:                  Complex (slow pulse — 10–15s cycle. The fountain moss pulses differently than
                              the Grotto fungi — the player learns to distinguish them by rhythm.)
```

### 15.4 — Interactive Light (Player-Carried)

```
LIGHT_PLAYER_TORCH             Lighting | T2 | Player
  Purpose:                    Torch or resonance-powered handheld light carried by the player
  Type:                       SpotLight3D attached to player
  Notes:                      Craftable. Required for deep Creep exploration and Underworld navigation.
                              Not listed as an "island asset" but included for lighting design completeness.
```

---

## 16. AUDIO ASSETS

### 16.1 — Ambient Beds (Looping)

```
AUDIO_AMBIENT_ATRIUM           Audio | T1 | AT
  Purpose:                    The Atrium's ambient soundscape
  Content:                    Fountain water (constant, gentle) + wind through shattered dome (airy, musical) +
                              muted birdsong (canopy above) + crystal resonance hum (subtle, multi-layered) +
                              occasional crystal chime (random, unrepeated)
  Duration:                    8-minute loop with procedural variation layers
  Notes:                      The first audio the player hears. Must communicate: safe, ancient, beautiful, interesting.

AUDIO_AMBIENT_GATEHOUSE        Audio | T1 | GH
  Content:                    Wind through open doors (strong, constant, exposed) + distant sky sounds +
                              creaking metal (cargo cradles shifting) + very sparse — mostly silence and wind
  Emotion:                    Melancholy, exposed, empty

AUDIO_AMBIENT_CASCADE          Audio | T1 | CG
  Content:                    Flowing water (multiple channels — complex aquatic soundscape) + rustling crops/grasses +
                              insect drone (gentle) + bird calls + wind-through-terraces
  Emotion:                    Alive, productive, scientific excitement

AUDIO_AMBIENT_CREEP            Audio | T1 | VC
  Content:                    Dense insect chorus (constant, layered — the Creep's defining sound) +
                              rustling vegetation + muffled wind through canopy + water drip (irregular) +
                              occasional animal calls (the Escapees) + bioluminescent fungi hum (subtle)
  Emotion:                    Immersive, slightly disorienting, intensely alive

AUDIO_AMBIENT_QUARTERS         Audio | T1 | LQ
  Content:                    Near-silence dominant + creaking wood (Courtyard Tree flexing) +
                              wind through tree canopy (softer than open wind) + muted birdsong +
                              music box (if activated — one-time) + occasional settling sounds (old building)
  Emotion:                    Empty, personal, sad, tender

AUDIO_AMBIENT_AVIARY           Audio | T1 | AV
  Content:                    Birdsong (constant, layered — multiple species) + buzzing insects (bees, butterflies) +
                              wind through arches (musical, airy) + rustling flowers + gentle water (propagation station)
  Emotion:                    Joyful, alive, beautiful, hopeful

AUDIO_AMBIENT_RING             Audio | T1 | CR
  Content:                    Wind (strong, constant, exposed — the primary sound) + resonance hum (stronger here) +
                              instrument sounds (anemometer whir, soft monitor hum) + near-silence when wind drops +
                              occasional bird flyovers
  Emotion:                    Vast, exposed, awe-inspiring, contemplative

AUDIO_AMBIENT_SANCTUM          Audio | T1 | SS
  Content:                    Near-silence + resonance hum (strongest on island — multi-frequency drone) +
                              electrical hum (amber lights) + player's own footsteps (echoing) +
                              stasis field shimmer (just at threshold of hearing) + occasional regulator click
  Emotion:                    Sacred, mysterious, suspended, anticipatory
```

### 16.2 — One-Shot Sound Effects

```
AUDIO_SFX_DOOR_HEAVY_OPEN      SFX | T1 | SS
  Purpose:                    The Sanctum door opening — stone grinding on stone, heavy mechanism
  Notes:                      First sustained interaction. Must feel weighty, significant.

AUDIO_SFX_DOOR_HEAVY_CLOSE     SFX | T1 | SS
  Purpose:                    The Sanctum door closing — heavy stone thud, resonance seal engaging

AUDIO_SFX_CRYSTAL_CHIME        SFX | T1 | AT (dome), CR (standing stones contact)
  Purpose:                    Crystal-on-crystal contact — delicate, glassy, musical, unrepeated
  Notes:                      Occasional random trigger in Atrium (dome panels touching in wind). Player-triggered
                              when interacting with crystals.

AUDIO_SFX_CRYSTAL_COLLECT      SFX | T1 | ALL
  Purpose:                    Picking up a small crystal fragment — glassy clink, slight resonance hum decay

AUDIO_SFX_RESOURCE_HARVEST     SFX | T1 | ALL
  Purpose:                    Generic resource collection sounds — varies by resource type
  Sub-assets:                   plant_pick (soft snap), stone_chip (hard clink), wood_crack (dry break),
                                clay_scoop (wet squelch), fungi_pluck (soft pop)

AUDIO_SFX_MUSIC_BOX            SFX | T1 | LQ
  Purpose:                    The music box lullaby — delicate mechanical melody
  Duration:                    45-second melody loop
  Notes:                      The first music the player hears. Emotionally devastating in context.

AUDIO_SFX_FOOTSTEPS            SFX | T1 | Player system (all surfaces)
  Purpose:                    Player footstep sounds — varies by surface material
  Sub-assets:                   stone, soil, wood, metal grating, water-shallow, leaf-litter, crystal-debris

AUDIO_SFX_INTERACT_EXAMINE     SFX | T2 | ALL
  Purpose:                    Subtle sound when examining objects — soft rustle, paper crinkle, object handling

AUDIO_SFX_INTERACT_ACTIVATE    SFX | T2 | ALL
  Purpose:                    Sound when activating mechanisms — lever click, button press, sluice gate movement

AUDIO_SFX_MEMORY_TRIGGER       SFX | T1 | ALL
  Purpose:                    Audio transition into memory fragment — brief auditory flash, then fade
  Notes:                      Each memory fragment has a unique audio signature — a phrase, a sound, a voice.
                              These are designed individually per fragment.
```

### 16.3 — Creature Sounds

```
AUDIO_CREATURE_BIRDSONG        Audio | T1 | AV, AT, LQ, CG
  Purpose:                    Bird vocalizations — species-specific calls and songs
  Sub-assets:                   golden_songbird (4-note phrase — Ark signature sound), finch_chatter,
                                hummingbird_whir (wing sound), flycatcher_chirp, swift_screech

AUDIO_CREATURE_INSECTS         Audio | T1 | VC, CG, AV
  Purpose:                    Insect chorus — the dense background hum of the Creep and garden
  Sub-assets:                   cricket_chorus, cicada_drone (seasonal), bee_hum, butterfly (silent — visual only)

AUDIO_CREATURE_FROGS           Audio | T2 | CG (settling pools), VC (damp areas)
  Purpose:                    Frog calls — evening and night, near water. Indicators of clean water.
```

### 16.4 — Music

```
AUDIO_MUSIC_ATRIUM             Music | T1 | AT
  Purpose:                    The Atrium theme — solo piano (felt-treated), string pad, crystal tones
  Notes:                      District-specific music design detailed in District Design Document.

AUDIO_MUSIC_GATEHOUSE          Music | T1 | GH
AUDIO_MUSIC_CASCADE            Music | T1 | CG
AUDIO_MUSIC_CREEP              Music | T1 | VC
AUDIO_MUSIC_QUARTERS           Music | T1 | LQ
AUDIO_MUSIC_AVIARY             Music | T1 | AV
AUDIO_MUSIC_RING               Music | T1 | CR
AUDIO_MUSIC_SANCTUM            Music | T1 | SS
  Notes:                      Full music direction (instrumentation, tempo, dynamics, harmony, adaptive layers,
                              emotional quality) specified per district in the District Design Document.
```

---

## 17. WILDLIFE & ENVIRONMENTAL CREATURES

### 17.1 — Birds

```
CRITTER_BIRD_SONGBIRD          Wildlife | T1 | AV (primary), AT, LQ, CG
  Purpose:                    The golden-breasted Ark-endemic songbird — the island's signature bird
  Variations:                 1 species, 3 animation states (perched, flying, nesting)
  Poly Budget:                200–400 tris
  Animation:                  Complex (idle — head movements, preening; takeoff; flight — flap + glide;
                              landing; nesting — feeding chicks)
  AI Behavior:                Perch → sing → forage → return to nest. Flies between districts.
                              Curious about player — will approach if player is still.
  Sound:                      Distinctive 4-note song phrase
  Notes:                      ~50 individuals across the island. The player's most common wildlife encounter.

CRITTER_BIRD_HUMMINGBIRD      Wildlife | T2 | AV (Pollinator Garden)
  Purpose:                    Nectar-feeding hummingbird analog — hovers at flowers
  Poly Budget:                150–300 tris
  Animation:                  Complex (hover — rapid wing blur; dart between flowers; territorial chase)
  Sound:                      Wing whir (distinctive — audible before visible)

CRITTER_BIRD_FINCH             Wildlife | T2 | CG (grain stands), AV
  Purpose:                    Seed-eating finch — forages in the feral grain
  Poly Budget:                150–250 tris
  Sound:                      Chatter call

CRITTER_BIRD_SWIFT             Wildlife | T2 | GH (nests in doorframe), CR (underside nesting)
  Purpose:                    Swift-like species — the only bird that nests in the exposed summit
  Poly Budget:                100–200 tris
  Animation:                  Complex (aerial — rarely lands; fast, agile flight)
```

### 17.2 — Pollinators

```
CRITTER_BUTTERFLY              Wildlife | T1 | AV (highest density), CG, AT
  Purpose:                    Butterflies — 8–12 species, descendants of the Ark's managed pollinators
  Variations:                 8 (species by wing color and pattern)
  Poly Budget:                50–100 tris (camera-facing animated cards)
  Animation:                  Complex (flutter flight — procedural path; land on flowers — wing folding;
                              cloud behavior — multiple individuals moving together)
  AI Behavior:                Visit flowers → rest on warm stone → flee from sudden movement
  Notes:                      ~200 individuals in Aviary, ~50 elsewhere. GPU particle for distant flocks,
                              individual meshes for close butterflies. Seasonal — peak in spring/summer.

CRITTER_BEE                    Wildlife | T1 | AV (hives in arches), CG (foraging)
  Purpose:                    Honeybees — descendants of the managed hive population
  Poly Budget:                30–60 tris
  Animation:                  Complex (flight path between hive and flowers — procedural; hive activity —
                              crawling on comb surface; swarming — defensive response)
  AI Behavior:                Forage → return to hive → dance communication. Defensive if player attacks hive.
  Sound:                      Buzzing (individual — soft; swarm — intense)

CRITTER_MOTH                   Wildlife | T2 | AV, VC, AT (night only)
  Purpose:                    Moths — nocturnal pollinators, some bioluminescent
  Variations:                 3 (common brown, large hawkmoth, bioluminescent)
  Poly Budget:                50–100 tris
  Animation:                  Complex (erratic flutter — attracted to light sources; bioluminescent: soft glow pulse)
```

### 17.3 — The Escapees (Small Mammals)

```
CRITTER_ESCAPEE_RABBIT         Wildlife | T1 | VC (territories throughout)
  Purpose:                    Rabbit-like descendant of research animals — the most commonly seen Escapee
  Poly Budget:                300–600 tris
  Animation:                  Complex (idle — nose twitch, ear rotation; hop; run; alert — freeze;
                              forage — nibbling vegetation; groom)
  AI Behavior:                Territory-based. Curious — approaches still player. Flees from sudden movement.
                              Active dawn/dusk. Rests in burrows at night.
  Collision:                  Simple (small capsule — player cannot walk through)
  Sound:                      Soft thump (warning — foot stamp), rustle (movement through vegetation)

CRITTER_ESCAPEE_GUINEA         Wildlife | T2 | VC (undergrowth)
  Purpose:                    Guinea pig-like descendant — smaller, shyer
  Poly Budget:                200–400 tris
  AI Behavior:                Skittish — flees from player. Whistles to warn colony.

CRITTER_ESCAPEE_DEER           Wildlife | T2 | VC (deep interior — rare)
  Purpose:                    Small deer-like descendant — the largest Escapee. Graceful, alert.
  Poly Budget:                800–1,500 tris (hero creature)
  Animation:                  Complex (walk, bound, alert — head up, ear rotation, graze, lie down)
  AI Behavior:                Solitary. Very shy — maintains distance from player. Most active at dawn.
  Notes:                      Rare — only 2–3 individuals. Seeing one is a special moment.
```

### 17.4 — Small Creatures

```
CRITTER_LIZARD                 Wildlife | T2 | AT, GH, CG (sun-warmed stone)
  Purpose:                    Small lizards basking on stone — harmless. One of the first creatures the player notices.
  Poly Budget:                100–200 tris
  Animation:                  Simple (basking — still; skitter — fast movement into cracks; head-bob display)
  AI Behavior:                Bask on warm stone. Flee into wall cracks when approached.

CRITTER_FROG                   Wildlife | T2 | CG (settling pools), VC (damp areas)
  Purpose:                    Tree frogs and pool frogs — near water. Indicators of clean water.
  Poly Budget:                100–200 tris
  Sound:                      Croak (evening chorus near water)

CRITTER_SPIDER                 Wildlife | T3 | VC, AV (web locations)
  Purpose:                    Web-spinning spiders — predators controlling insect populations
  Poly Budget:                100–200 tris
  Notes:                      Non-aggressive. Webs are environmental detail — visible in morning dew.
```

### 17.5 — Insects (Ambient)

```
CRITTER_DRAGONFLY              Wildlife | T2 | CG (over settling pools), AV
  Purpose:                    Dragonflies — iridescent predators hovering over water. Visually striking.
  Poly Budget:                80–150 tris
  Animation:                  Complex (hover, dart, perch on reeds)

CRITTER_FIREFLY                Wildlife | T2 | CG, AV, AT (night only — seasonal)
  Purpose:                    Fireflies — bioluminescent beetles. Nighttime visual spectacle.
  Poly Budget:                GPU particles with emissive pulse (not individual meshes)
  Animation:                  Complex (floating drift — procedural; flash pattern — species-specific timing)
  Notes:                      ~200 lights in Aviary/Gardens on summer nights. Creates magical atmosphere.
```

---

## 18. MODULAR CONSTRUCTION KITS

### 18.1 — Kit Philosophy

A modular kit is a set of assets designed to be combined in multiple configurations. Kits reduce unique asset count, ensure visual consistency, and enable level designers to assemble spaces without waiting for custom assets.

### 18.2 — Kit Catalogue

#### KIT: First Delver Stone Architecture

```
Purpose:              Construct all interior and exterior stone spaces — walls, floors, corridors, rooms.
Contained Assets:     ARK_WALL_STRAIGHT, ARK_WALL_CORNER, ARK_WALL_RETAINING, ARK_FLOOR_SLAB,
                      ARK_FLOOR_CRACKED, ARK_PILLAR_SQUARE, ARK_ARCH_STANDARD, ARK_DOORWAY_FRAME,
                      ARK_STAIRS_STRAIGHT, ARK_CEILING_VAULTED, ARK_ROOF_FLAT_STONE
Reuse Strategy:       Every district uses this kit. District identity comes from: (a) finish variant
                      (interior vs exterior vs damaged), (b) prop and vegetation dressing, (c) lighting.
                      The same wall mesh is the Atrium wall and the Living Quarters wall — only the
                      context (props, light, plants) changes.
Compatible Kits:      Metal & Glass, Ruins, Laboratory, Domestic
```

#### KIT: Metal & Glass Structures

```
Purpose:              Construct the Aviary glasshouse framework, Gatehouse cargo equipment,
                      and instrument support structures.
Contained Assets:     ARK_IRON_ARCH, ARK_IRON_BEAM, ARK_IRON_PLATFORM_FRAME, ARK_METAL_HINGE,
                      ARK_METAL_BRACKET, ARK_METAL_FASTENER, ARK_GLASS_PANE, ARK_RAILING_METAL
Reuse Strategy:       Iron arches snap together to form the full Aviary framework. Beams and
                      brackets are used wherever metal structural support is visible. Glass panes
                      are placed in arch frames for intact glasshouse sections.
Compatible Kits:      Stone Architecture, Ruins
```

#### KIT: Ruins & Decay

```
Purpose:              Apply damage, age, and reclamation to architecture. Turn intact spaces into ruins.
Contained Assets:     ARK_RUIN_WALL_COLLAPSE, ARK_RUIN_CEILING_COLLAPSE, ARK_RUIN_FLOOR_COLLAPSE,
                      ARK_DAMAGE_CRACK_LARGE, ARK_DAMAGE_SPALLING, ARK_DEBRIS_RUBBLE_PILE,
                      ARK_DEBRIS_STONE_CHUNKS, ARK_DEBRIS_METAL_SCRAP
Reuse Strategy:       Applied as an overlay kit — start with intact Stone Architecture, then apply
                      Ruin assets to create age and history. Different districts have different
                      ruin density: Stasis Sanctum = 0%, Verdant Creep = 80%, others between.
Compatible Kits:      Stone Architecture, Metal & Glass, Nature Reclamation
```

#### KIT: Bridges & Verticality

```
Purpose:              Construct all traversal infrastructure — bridges, platforms, stairs, ramps.
Contained Assets:     ARK_BRIDGE_STONE, ARK_BRIDGE_COLLAPSED, ARK_PLATFORM_DEPARTURE,
                      ARK_PLATFORM_RING, ARK_PLATFORM_OBSERVATION, ARK_STAIRS_STRAIGHT,
                      ARK_STAIRS_SPIRAL, ARK_STAIRS_SWITCHBACK, ARK_RAILING_LOW
Reuse Strategy:       Bridge and stair pieces snap together for custom spans. Platform pieces
                      create observation points, docking areas, and elevated workspaces.
Compatible Kits:      Stone Architecture, Metal & Glass
```

#### KIT: Laboratory & Scientific

```
Purpose:              Outfit research spaces — laboratories, observatories, propagation stations.
Contained Assets:     PROP_WORKBENCH_LAB, PROP_SHELVING_LAB, PROP_STOOL_LAB, PROP_INSTRUMENT_PANEL,
                      PROP_INSTRUMENT_OPTICAL, PROP_INSTRUMENT_CHEMISTRY, PROP_OBSERVATORY_CHART,
                      PROP_MACHINERY_SLUICE, PROP_MACHINERY_LIFT
Reuse Strategy:       Any room designated "laboratory" or "research" uses this kit. The Sunken Lab
                      and Propagation Station are kit-assembled. The Resonance Monitors and
                      Great Telescope are hero assets placed within kit-constructed spaces.
Compatible Kits:      Stone Architecture, Domestic (storage overlaps)
```

#### KIT: Domestic

```
Purpose:              Outfit living spaces — bedrooms, common rooms, kitchens, children's rooms.
Contained Assets:     PROP_CHAIR_WOODEN, PROP_BENCH_STONE, PROP_TABLE_DINING, PROP_TABLE_WORK,
                      PROP_TABLE_SIDE, PROP_BED_SINGLE, PROP_SHELVING_LAB (repurposed as bookshelves),
                      PROP_CABINET_STONE, PROP_MUG_CERAMIC, PROP_PLATE_BOWL, PROP_UTENSIL,
                      PROP_BOOK_STACK, PROP_PAPER_LOOSE, PROP_FRAME_PICTURE
Reuse Strategy:       Every private room uses domestic kit. Variations in arrangement, state
                      (intact vs disturbed), and personal effects create individual identities.
Compatible Kits:      Stone Architecture, Laboratory (storage and shelving overlap)
```

#### KIT: Garden & Cultivation

```
Purpose:              Outfit agricultural and botanical spaces — terraces, gardens, propagation areas.
Contained Assets:     (All vegetation assets — see Sections 6–7) + PROP_SEED_TRAY, PROP_JAR_STORAGE,
                      PROP_MACHINERY_SLUICE, ARK_WALL_RETAINING, VEG_SHRUB_GENERIC, VEG_BUSH_BERRY,
                      VEG_SHRUB_MEDICINAL
Reuse Strategy:       Terraces are defined by retaining walls + soil + vegetation. The Cascade
                      Gardens and Aviary use this kit in different configurations — the Gardens
                      emphasize food/medicine plants; the Aviary emphasizes ornamental/collection plants.
Compatible Kits:      Stone Architecture, Water System
```

#### KIT: Water System

```
Purpose:              Construct all water features — reservoir, channels, pools, fountain.
Contained Assets:     WATER_RESERVOIR, WATER_CHANNEL, WATER_POOL_SETTLING, WATER_FOUNTAIN,
                      VFX_WATERFALL_SMALL, VFX_WATER_DRIP, PROP_MACHINERY_SLUICE
Reuse Strategy:       Water assets are placed along the defined hydrological path. Channels connect
                      reservoir → terraces → pools → cistern → fountain. Sluice gates at junction
                      points allow the player to modify flow.
Compatible Kits:      Stone Architecture, Garden & Cultivation
```

#### KIT: Nature Reclamation

```
Purpose:              Apply vegetation overgrowth to any architecture — the "5,000 years of abandonment" layer.
Contained Assets:     VEG_VINE_HANGING, VEG_VINE_CURTAIN, VEG_MOSS_STONE, VEG_MOSS_CARPET,
                      VEG_ROOT_EXPOSED, VEG_FUNGI_MUSHROOM, VEG_TREE_CANOPY_OAK, VEG_GRASS_WILD,
                      VEG_FLOWER_WILD, ARK_DOORWAY_VINE_CURTAIN, PROP_DEBRIS_LEAF_PILE
Reuse Strategy:       Applied as an overlay kit — start with stone architecture, then add reclamation
                      based on district conditions: moisture (more moss/fungi near water), light
                      (more flowers in sunny areas), structural damage (more vines/roots in cracked areas).
                      Reclamation density per district:
                        SS: 0% (environmental control prevents growth)
                        GH: 5% (wind exposure limits growth)
                        CR: 5% (above tree line)
                        CG: 40% (managed garden → meadow transition)
                        AT: 45% (trees through dome, moss on damp stone)
                        LQ: 60% (Courtyard Tree roots throughout)
                        AV: 70% (vines on arches, flowers merged with wild)
                        VC: 95% (the most reclaimed — near-total consumption)
Compatible Kits:      ALL (overlay kit — applies to any constructed space)
```

#### KIT: Crystal & Resonance

```
Purpose:              Place all resonance-related visual elements — crystals, glow effects, stasis fields.
Contained Assets:     CRYSTAL_SHARD_SMALL, CRYSTAL_SHARD_LARGE, CRYSTAL_DOME_PANEL,
                      VFX_RESONANCE_GLOW, VFX_STASIS_FIELD, LIGHT_CRYSTAL_GLOW,
                      PROP_MONITOR_RESONANCE, PROP_CHEST_RESONANCE
Reuse Strategy:       Small crystals placed via MultiMesh in areas of exposed infrastructure.
                      Large crystals hand-placed in specific instruments. Glow effects applied
                      to all charged crystal materials.
Compatible Kits:      ALL (resonance elements exist in every district)
```

---

## 19. VISUAL STYLE GUIDE

### 19.1 — The Visual Identity of Aperture

From the Vision Document: *"The world is rendered with the clarity of scientific illustration and the warmth of a hand-drawn field journal. Lines are clean and intentional. Colors are observed, not invented. Every visual element communicates information about the underlying system."*

### 19.2 — Edge Treatment

| Element | Edge Style | Rationale |
|---------|-----------|-----------|
| **First Delver Stone Architecture** | Sharp, precise edges where intact; chipped and rounded where weathered | Communicates engineering precision. 5,000 years of wear reads as rounding and spalling. |
| **Natural Stone (cliffs, boulders)** | Angular fracture faces (fresh) transitioning to rounded (weathered) | Geological authenticity. Sharp = recent break; round = ancient surface. |
| **Wood (fallen branches, exposed roots)** | Organic, flowing, no perfectly straight lines | Trees are living geometry — no right angles in nature. |
| **Metal (iron, brass)** | Sharp when manufactured; jagged when broken; softened by rust/patina | Manufactured precision degraded by chemical processes. |
| **Crystal** | Geometric, faceted, planar | Crystal lattice structure is mathematically ordered — edges are straight, angles are consistent. |

### 19.3 — Surface Wear & Aging

All assets must communicate their 5,000-year age through surface treatment:

| Age Indicator | Visual Implementation | Where Applied |
|---------------|---------------------|---------------|
| **Stone weathering** | Roughened normal map, pitting in albedo, darker in crevices (moisture accumulation), lighter on exposed faces (sun bleaching) | All exterior stone |
| **Metal corrosion** | Iron: orange-brown rust in crevices, flaking edges. Brass: green-brown patina at edges, original color in protected recesses. Copper: blue-green verdigris spreading from edges. | All exposed metal. Rate varies by exposure — Gatehouse metal is most corroded; Sanctum metal is near-pristine. |
| **Wood aging** | Silver-grey on exposed surfaces (UV bleaching), darker where protected. Checking (small cracks along grain) on large surfaces. | All exterior wood. Interior wood (Living Quarters) is less weathered. |
| **Glass degradation** | Microscopic pitting → clouded transparency. Crack networks from thermal stress. Dust accumulation on upward-facing surfaces. | Aviary glasshouse panels, dome panels, quarantine windows. |
| **Crystal aging** | Discharged crystals become clear (no glow). Charged crystals maintain luminescence. Crystal lattice imperfections visible as internal fracture planes. | All crystal assets. |

### 19.4 — Nature Reclamation Guidelines

Vegetation colonizes architecture according to consistent rules — never random:

| Reclamation Type | Where It Appears | Visual Density |
|-----------------|------------------|----------------|
| **Moss** | North-facing stone surfaces (less sun, more moisture), within 2m of water sources, in structural cracks where water accumulates | Thin film → thick carpet depending on moisture |
| **Vines** | Vertical surfaces with structural cracks (root purchase), within reach of soil (roots in ground, vines climbing up) | Thickest on Aviary arches and Verdant Creep structures |
| **Root penetration** | Where large trees are within 30m of architecture. Roots follow water seepage and structural seams. | Living Quarters: extensive. Atrium: moderate. Other districts: where trees are adjacent. |
| **Leaf litter** | Beneath deciduous trees. Depth proportional to tree size and proximity. | Thickest under Courtyard Tree and Verdant Creep canopy |
| **Fungi** | On dead wood (fallen logs, stumps), in consistently damp areas, on compost/rich humus | Highest density in Verdant Creep. Seasonal flushes after rain. |

### 19.5 — Color Palette

**Global palette derived from First Delver materials and the Ark's ecosystem:**

| Color Role | Color | Hex | Usage |
|------------|-------|-----|-------|
| **Stone — Warm Grey** | Base architectural color | #B8B0A8 | Walls, floors, pillars, structural elements |
| **Stone — Cool Grey** | Standing stones, darker variant | #989098 | Summit monoliths, some interior finishes |
| **Stone — Weathered** | Lighter, sun-bleached | #C8C0B8 | Exposed exterior surfaces |
| **Soil — Rich Dark** | Basin humus | #3A2A20 | Verdant Creep, Cascade compost |
| **Soil — Mineral Brown** | Slope soil | #6B5A4A | Mid-elevation terraces |
| **Iron — Rusted** | Warm orange-brown | #B07040 | All iron assets |
| **Brass — Patina** | Warm gold with green edges | #B89860 | Instruments, fittings |
| **Copper — Verdigris** | Blue-green | #609080 | Original plumbing remnants |
| **Crystal — Charged** | Pale blue-white glow | #C8D8F0 | Active resonance crystals |
| **Crystal — Discharged** | Clear to milky white | #E8E8F0 | Depleted crystals |
| **Amber Glass** | Warm amber | #D8A040 | Quarantine windows, Sanctum lights |
| **Vegetation — Canopy** | Deep forest green | #3A5A3A | Tree canopies |
| **Vegetation — Meadow** | Yellow-green to mid-green | #8AAA59 → #6B8B4A | Grasses, shrubs |
| **Vegetation — Wetland** | Blue-green | #4A7A5A | Damp area foliage |
| **Bioluminescence** | Blue-green glow | #7EB8B0 | Moss, fungi, Memory Garden flower |
| **Flowers** | Full spectrum — saturated accents | Various | Aviary, Cascade wildflowers |

### 19.6 — Silhouette Design

**Low-poly silhouette principle:** Every asset must be identifiable by its silhouette alone. If the player sees a shape against the sky, they should know what it is without color, texture, or detail.

- **Trees:** Distinctive branching patterns per species. Courtyard Tree = broad dome. Canopy oak = irregular rounded. Specimen trees = species-specific forms.
- **Architecture:** First Delver parabolic arch is the signature silhouette — taller and narrower than Roman arches. Recognizable from any angle.
- **Instruments:** Telescope = angled tube on complex mount. Standing stones = vertical monoliths with unique profiles.
- **Props:** Simplified to essential geometry at distance. A chair reads as a chair from 50m because the silhouette is correct.

### 19.7 — Surface Detail Philosophy

**Hand-painted where information is conveyed; procedural where texture is repeated.**

| Detail Type | Method | Rationale |
|-------------|--------|-----------|
| **Scientific engravings** | Hand-painted textures | These convey specific information — they must be legible |
| **Children's drawings** | Hand-painted textures | Unique storytelling assets |
| **Stone grain** | Procedural/tileable + detail maps | Repeated across thousands of square meters |
| **Wood grain** | Tileable with unique hero textures for landmark trees | Courtyard Tree bark is hand-painted; generic tree bark is tileable |
| **Crystal lattice** | Procedural + hand-crafted hero crystals | Small crystals: procedural. Large hero crystals: hand-modeled internal structure |
| **Moss/lichen coverage** | Shader-based (world-aligned blend) | Applies to any surface based on slope, moisture, and light parameters |

---

## 20. PRODUCTION PRIORITY TIERS

### 20.1 — Tier Assignment

| Tier | Definition | Count | Sprint Target |
|------|-----------|-------|---------------|
| **T1 — Essential** | Must exist for the first playable build. The player cannot experience the Ark without these. | ~180 assets | Sprint 1–4 |
| **T2 — Polish** | Needed for visual and gameplay completeness. The game functions without them but feels unfinished. | ~120 assets | Sprint 5–8 |
| **T3 — Detail** | Ambient detail, decorative variants, future expansion. Adds richness but not required for ship. | ~60 assets | Sprint 9+ |

### 20.2 — Tier 1 Assets (First Playable)

**Must deliver:** Player can awaken, explore all 8 districts, see all 20 landmarks, collect all resource types, experience the emotional arc.

- Terrain: ARK_TERRAIN_SLAB, ARK_SOIL_BASIN, ARK_SOIL_SLOPE, ARK_CLIFF_EXPOSED
- Architecture: All Stone Kit (walls, floors, pillars, arches, doorways, stairs — interior finish only for first pass)
- Hero Landmarks: Shattered Dome (structural ring + 15 panels), Courtyard Tree (trunk + simplified canopy), Ring Platform (platform + 8 stone monoliths), Great Table, Departure Platform, Grand Archway, Great Telescope (static), Instrument Tree, Sanctum Entrance, Hollow Dome shell
- Vegetation: Canopy oaks, Courtyard Tree, shrubs (3 variants), berry bushes (3), medicinal shrubs (4), wild grasses, wildflowers (6 of 12 species), hanging vines (2 variants), fallen logs, exposed roots
- Props: Workbench, shelving, wooden chair, stone bench, dining table, work desk, single bed, ceramic mug, book stack, loose papers, seed tray, storage jar, laboratory instrument panel, sluice gate, cargo cradle
- Water: Reservoir, channels (straight + junction), settling pools, fountain
- Crystals: Small shards (charged + discharged), dome panels (15 suspended + 10 floor)
- Effects: Prismatic light (dome), fog (Creep), bioluminescent glow (moss + fungi)
- Lighting: Sun directional, amber strips (Sanctum), crystal glow (emissive)
- Audio: 8 district ambient beds, footstep sounds, door heavy open/close, crystal chime, resource harvest, birdsong (songbird primary), insect chorus (Creep)
- Wildlife: Songbird, butterfly (4 species), bee, Escapee rabbit

### 20.3 — Tier 2 Assets (Polish)

- Architecture: Exterior/weathered finishes, damaged wall variants, cracked floors, vaulted ceilings, engraved pillars, spiral stairs, window frames, iron beams, metal brackets, glass panes, collapsed sections, spalling decals
- Vegetation: Dead trees, stumps, remaining 6 flower species, vine curtains, moss variants, all fungi species, fallen branches, specimen trees (3 of 5)
- Props: Laboratory stool, instrument panel variants, optical instruments, chemistry apparatus, observatory charts, sluice gate variants, broken lift, side table, plates/bowls, scrolls, specimen cases, metal scrap debris, leaf piles, bird nests, wooden crates, stone cabinets
- Crystals: Large instrument crystals, stasis chamber crystals
- Effects: Dust motes, pollen, godrays, waterfall small, water drip, wind lines, rain particles, rain ripples
- Lighting: Player torch, moonlight system
- Audio: Music box, creature sounds (frogs, moths, finch), interaction sounds, memory trigger SFX
- Wildlife: Hummingbird, finch, swift, moth, Escapee guinea, lizard, frog, dragonfly

### 20.4 — Tier 3 Assets (Future Expansion)

- Architecture: Roof variants, metal fasteners, remaining prop variants
- Vegetation: Mycelium detail, remaining 2 specimen trees
- Props: Utensils, picture frames, remaining debris variants
- Remaining wildlife: Escapee deer, spider, firefly
- Expansion hooks: Collapsed bridge detail, sealed dome fragment, attic storage access

---

## 21. ASSET COUNT SUMMARY

| Category | Tier 1 | Tier 2 | Tier 3 | Total |
|----------|--------|--------|--------|-------|
| **Terrain & Geology** | 7 | 5 | 0 | 12 |
| **Architecture — Stone** | 14 | 12 | 4 | 30 |
| **Architecture — Metal & Glass** | 5 | 9 | 3 | 17 |
| **Architecture — Bridges & Platforms** | 5 | 3 | 1 | 9 |
| **Architecture — Ruins** | 4 | 5 | 0 | 9 |
| **Vegetation — Trees** | 3 | 2 | 2 | 7 |
| **Vegetation — Shrubs & Plants** | 13 | 6 | 0 | 19 |
| **Vegetation — Ground & Fungi** | 8 | 10 | 2 | 20 |
| **Vegetation — Vines & Roots** | 4 | 3 | 0 | 7 |
| **Props — Laboratory** | 8 | 14 | 0 | 22 |
| **Props — Furniture** | 12 | 6 | 2 | 20 |
| **Props — Containers & Books** | 5 | 6 | 0 | 11 |
| **Props — Debris & Detail** | 5 | 7 | 3 | 15 |
| **Water** | 5 | 3 | 0 | 8 |
| **Crystals** | 4 | 2 | 0 | 6 |
| **Effects & Particles** | 6 | 9 | 0 | 15 |
| **Light Sources** | 4 | 2 | 0 | 6 |
| **Audio** | 18 | 12 | 0 | 30 |
| **Wildlife** | 5 | 11 | 4 | 20 |
| **Modular Kits** | 8 | 3 | 0 | 11 |
| **TOTAL** | **~143** | **~130** | **~20** | **~293** |

*Note: Counts represent unique asset definitions. Many assets have multiple variations (LOD levels, damage states, finish types). Total unique mesh files: approximately 350–400.*

---

## CLOSING STATEMENT

This Production Asset Manifest defines every object that appears in the world of the Ark of Genesis. Approximately 293 unique asset definitions organized across 21 categories, 11 modular construction kits, and 3 production priority tiers.

Every asset answers: why it exists, where it is used, how many variations exist, whether it can be reused, how it supports gameplay, and how it supports storytelling. The modular kit system ensures maximum reuse — the same stone wall builds the Atrium, the Living Quarters, and the Gatehouse. District identity comes from context, not unique geometry.

The visual style guide ensures consistency: every asset reads as First Delver, every surface communicates its 5,000-year age, every plant follows ecological logic, every crystal glows with the signature blue-white resonance luminescence.

Production can begin immediately. Tier 1 assets (~143 definitions) enable a fully playable first build. Tier 2 assets (~130) add polish and completeness. Tier 3 assets (~20) provide future expansion.

The Ark of Genesis is ready to be built.

---

*Production Asset Manifest v1.0 — ratified 2026-07-08*
*Art Director, Technical Art Director, Lead Environment Artist, Asset Production Lead, Modular Environment Designer, Production Pipeline Architect: ArchBishop, by order of Lord Commander Ahmad*
