# The Ark of Genesis — Topographical Blueprint

*Engineering-grade terrain specification. Defines the naked landform only — no vegetation, no ruins, no resources, no gameplay. Level designers and terrain artists build from this document alone.*

**Classification:** AAA Studio Internal — Terrain Directorate
**Version:** 1.0
**Date:** 2026-07-08
**Authors:** ArchBishop (Lead Terrain Architect, Senior World Topographer), by order of Lord Commander Ahmad

**Parent Document:** [[ARK-OF-GENESIS-ISLAND-BLUEPRINT]] — this document converts that design into buildable terrain. Do not redesign. Follow exactly.

---

## TABLE OF CONTENTS

1. [Terrain Philosophy](#1-terrain-philosophy)
2. [Overall Silhouette & Massing](#2-overall-silhouette--massing)
3. [Island Dimensions & Bounding Box](#3-island-dimensions--bounding-box)
4. [Elevation Map — The Three Tiers](#4-elevation-map--the-three-tiers)
5. [Cliff Locations](#5-cliff-locations)
6. [Plateaus](#6-plateaus)
7. [Ravines & Water Channels](#7-ravines--water-channels)
8. [Waterfalls](#8-waterfalls)
9. [Rivers & Streams](#9-rivers--streams)
10. [Lakes & Pools](#10-lakes--pools)
11. [Natural Arches & Stone Bridges](#11-natural-arches--stone-bridges)
12. [Caves & Undercuts](#12-caves--undercuts)
13. [Rock Formations & Outcrops](#13-rock-formations--outcrops)
14. [Floating Fragments](#14-floating-fragments)
15. [Underside Shape](#15-underside-shape)
16. [Walkable Surfaces](#16-walkable-surfaces)
17. [Dangerous Drop-Offs](#17-dangerous-drop-offs)
18. [Natural Chokepoints](#18-natural-chokepoints)
19. [Viewpoints](#19-viewpoints)
20. [Future Expansion Connection Points](#20-future-expansion-connection-points)
21. [Terrain Construction Order](#21-terrain-construction-order)
22. [ASCII Top-Down Map](#22-ascii-top-down-map)
23. [Elevation Diagram](#23-elevation-diagram)
24. [Modular Terrain Pieces](#24-modular-terrain-pieces)

---

## 1. TERRAIN PHILOSOPHY

### 1.1 — The Prime Directive

**This island is an engineered platform, not a natural landmass.**

Every landform is either:
- **Original structure** — the shaped stone, level platforms, and engineered water channels the First Delvers built (now weathered).
- **Accumulation** — 5,000 years of wind-deposited soil, decomposed vegetation, and water-borne sediment that softened the hard edges.
- **Erosion** — where structural stone has cracked, crumbled, or collapsed, producing scree slopes, ravines, and exposed strata.

There is no "natural terrain" in the geological sense. There is only engineered infrastructure that time has reshaped.

### 1.2 — The Three Construction Layers

When building the terrain, think in three layers applied in order:

| Layer | Composition | Thickness | Coverage |
|-------|-------------|-----------|----------|
| **1. Structural Platform** | Shaped resonance-stabilized stone | 3–8m (the structural slab) | 100% of island footprint |
| **2. Engineered Surface** | Paving stones, retaining walls, channel linings, foundation pads | 0.3–1.5m | ~60% (where original surfaces survive) |
| **3. Accumulated Overburden** | Wind-deposited soil, decomposed organics, water-borne sediment | 0.1–3m | ~85% (thickest in basins, thinnest on exposed heights) |

Terrain artists build Layer 1 first, then Layer 2, then Layer 3. Where Layer 2 has collapsed, Layer 3 fills the gaps. Where Layer 2 survives intact, it remains exposed as "ruin surface."

### 1.3 — The Erosion Ruleset

Five millennia of exposure have reshaped the surface according to these rules:

1. **Water follows the original channels** — the engineered drainage system still directs flow. Erosion is concentrated along these routes.
2. **Wind scours the heights** — the upper tier has thinner soil, more exposed stone, sharper edges.
3. **Freeze-thaw fractures stone** — at the Ark's altitude, diurnal freeze-thaw cycles have cracked exposed stone surfaces, producing talus at cliff bases.
4. **Roots split seams** — where soil has accumulated deep enough for large plants, roots have penetrated structural seams and widened cracks.
5. **Edge spalling** — the island perimeter sheds fragments continuously. The underside is littered with detached blocks held in place by residual resonance fields.

### 1.4 — What This Document Does NOT Define

- Vegetation placement
- Ruin/architecture placement (beyond the retaining walls that define terrain tiers)
- Resource nodes
- Gameplay volumes
- Lighting or atmosphere
- Material textures beyond geological types

Those are defined in the Island Blueprint and subsequent implementation documents.

---

## 2. OVERALL SILHOUETTE & MASSING

### 2.1 — Plan-View Silhouette

The Ark, seen from above, is a **rounded hexagon elongated north-south** with three lobe extensions:

```
                    ┌──────────┐
                   /            \
                  /              \
                 /                \
                /                  \
               |                    |
               |                    |
               |                    |
               |                    |
                \                  /
                 \                /
                  \              /
                   └────────────┘
```

This is the idealized plan. The actual silhouette deviates as follows:

- **North lobe:** The Celestial Ring forms a near-perfect circular projection at the north end — a distinct bulge of radius ~25m centered on the north apex.
- **Northeast lobe:** The Stasis Sanctum plateau projects ~20m beyond the main hexagon edge, connected by a narrow neck.
- **East lobe:** The Aviary's structural expansion creates a broad, shallow bulge along the east face.
- **Southeast lobe:** The Verdant Creep's original simulation domes created a reinforced projection, now softened by 5,000 years of accumulated debris.
- **South lobe:** The Gatehouse Departure Platform extends ~30m south of the main body as a narrow, rectangular projection.
- **Southwest lobe:** A smaller structural expansion, now mostly eroded, creates an irregular indentation.

### 2.2 — Profile Silhouette (Viewed from East or West)

```
                    ┌──┐                    ← Celestial Ring platform (+42m)
                   /    \
                  /      \________________  ← Stasis Sanctum (+35m)
                 /                        \
                /         ┌───┐            \  ← Aviary arches (+28m)
               /         /     \            \
              /         /       \            \
             /─────────/         \────────────\  ← Central Ridge
            /                                 \
           /                                   \
          /                                     \
─────────/                                       \──────  ← Island edge (0m)
```

The profile is a stepped pyramid with three distinct levels, the north end higher than the south. The southern edge drops to the departure platform at 0m. The northern edge rises to +42m.

### 2.3 — Three-Dimensional Massing Summary

| Axis | Dimension | Description |
|------|-----------|-------------|
| North-South | 220m | Long axis. South = low, North = high. |
| East-West (max) | 190m | At the middle tier (Living Quarters to Aviary). |
| East-West (min) | ~140m | At the neck between the Atrium basin and the northern heights. |
| Height (max) | 42m | Celestial Ring platform surface relative to departure platform. |
| Structural slab thickness | 8–12m | The island's total vertical depth (surface to underside). |
| Soil depth (max) | 3m | In the Verdant Creep basin and Cascade Garden settling pools. |
| Soil depth (min) | 0.1m | On the Celestial Ring platform and exposed ridge lines. |

---

## 3. ISLAND DIMENSIONS & BOUNDING BOX

### 3.1 — Absolute Bounding Box

```
Origin: Center of the Atrium floor (the Great Table location)
       X=0, Y=0, Z=+8m (relative elevation)

Min corner: X=-95m  (west edge)
            Y=-120m (south tip of Departure Platform)
            Z=0m    (lowest walkable surface)

Max corner: X=+95m  (east edge)
            Y=+100m (north edge of Celestial Ring)
            Z=+42m  (highest walkable surface)

Total bounding box: 190m (X) × 220m (Y) × 42m (Z)
```

### 3.2 — District Footprints (Plan Areas)

| District | X Range | Y Range | Z Range | Area (approx) |
|----------|---------|---------|---------|---------------|
| Gatehouse | -40 to +10 | -120 to -80 | 0 to +5 | ~1,200 m² |
| Atrium | -35 to +35 | -85 to -50 | +5 to +12 | ~2,450 m² |
| Cascade Gardens | +15 to +60 | -75 to -35 | +5 to +20 | ~1,800 m² |
| Verdant Creep | +40 to +90 | -95 to -50 | 0 to +15 | ~2,000 m² |
| Living Quarters | -70 to -25 | -45 to -5 | +15 to +25 | ~1,800 m² |
| Aviary | +10 to +55 | -25 to +25 | +20 to +30 | ~2,000 m² |
| Celestial Ring | -25 to +25 | +30 to +80 | +30 to +42 | ~1,750 m² |
| Stasis Sanctum | +30 to +55 | +55 to +85 | +28 to +38 | ~750 m² |

### 3.3 — Island Perimeter

Total perimeter length (walkable edge): approximately **580 meters**.

The edge is not uniform. Three edge types exist:

| Edge Type | Length | Character |
|-----------|--------|-----------|
| **Sheer drop** | ~280m (48%) | Vertical or near-vertical face dropping to open sky. The original structural edge, exposed. |
| **Gradual slope** | ~200m (35%) | Accumulated soil and debris creating a sloped transition that terminates at the structural edge 2–5m below the visible surface. |
| **Retaining edge** | ~100m (17%) | Original retaining wall still intact, creating a clean boundary between walkable surface and void. |

---

## 4. ELEVATION MAP — THE THREE TIERS

### 4.1 — Tier System Overview

The Ark's surface is organized into three engineered tiers, each a remnant of the original structural design:

```
+42m ─── TIER 3 SUMMIT ─── (Celestial Ring, Stasis Sanctum)
        │
        │  Retaining Wall / Scree Slope
        │  Height differential: 12–14m
        │
+28m ─── TIER 2 PLATEAU ─── (Aviary, Living Quarters, upper Cascade)
        │
        │  Retaining Wall / Scree Slope
        │  Height differential: 8–16m
        │
+12m ─── TIER 1 PLATFORM ── (Atrium, lower Cascade, upper Verdant Creep)
        │
        │  Gentle slope + local retaining walls
        │  Height differential: 0–7m
        │
  0m ─── TIER 0 BASE ─────── (Gatehouse, Departure Platform, lower Verdant Creep)
```

### 4.2 — Tier 0: The Base Platform (0m to +7m)

**Footprint:** The southern third of the island plus the eastern Verdant Creep basin.

**Surface character:** The flattest terrain on the Ark. This was the arrival, processing, and heavy-equipment level. The original paving stones survive in large patches, particularly in the Gatehouse area (south) and along the approach to the Atrium. The Verdant Creep area was originally a series of enclosed domes whose foundations survive as circular depressions in the terrain.

**Key elevation features:**
- **Departure Platform surface:** Perfectly flat, +0m, rectangular, 30m × 15m. The original docking surface. Edges are clean vertical drops.
- **Gatehouse floor:** +0m to +2m. Very slight slope toward the Departure Platform for drainage. Original paving mostly intact.
- **Atrium approach:** +2m to +5m. A broad, gentle ramp rising north from the Gatehouse. Original ramp surface, now covered in 0.3–0.5m of accumulated soil.
- **Verdant Creep basin:** 0m to +7m. Irregular terrain. Circular depressions (former dome foundations) 8–15m diameter, 1–3m deep. The terrain undulates — the original flat floor has been deformed by root pressure, freeze-thaw, and accumulated debris.

### 4.3 — Tier 1: The Mid-Lower Platform (+5m to +12m)

**Footprint:** The central belt of the island, anchored by the Atrium.

**Surface character:** The transition zone between the working lower level and the residential/research middle levels. The Atrium is a large, roughly circular basin (the original gathering hall's floor) at +8m, ringed by slightly higher ground where the original walls stood. To the east, the Cascade Gardens begin their terraced ascent. To the west and north, the ground rises toward the Living Quarters and Aviary.

**Key elevation features:**
- **Atrium floor:** +8m. A circular basin ~35m diameter, deliberately level. The original floor surface survives beneath 0.2–0.4m of soil.
- **Atrium rim:** +10m to +12m. The circumference of the original dome structure, now a low ridge where wall foundations remain. Gaps in the rim correspond to the original corridor exits.
- **Cascade Gardens lower terraces:** +5m to +12m. Three distinct level platforms (the lower growing terraces), each ~1.5–2.5m above the previous. The terrace edges are the remains of retaining walls, now partially collapsed into ramps.
- **Verdant Creep upper transition:** +7m to +12m. Where the Creep basin rises to meet the mid-level. Steep, broken terrain where the original dome structures climbed the slope.

### 4.4 — Tier 2: The Mid-Upper Plateau (+15m to +28m)

**Footprint:** The central-northern belt. Living Quarters (west), central ridge, Aviary (east), and upper Cascade Gardens (east).

**Surface character:** The primary living and research level. This tier has the most varied surface — platforms for buildings, shallow basins for gardens, level paths connecting districts, and the Central Ridge that forms the spine.

**Key elevation features:**
- **Living Quarters platform:** +15m to +20m. A broad, gently undulating surface. The original residential foundations create subtle terracing — rectangular level areas ~5–8m across where rooms once stood. The Courtyard depression at +17m is a circular basin ~12m diameter (the original courtyard).
- **Central Ridge:** +20m to +25m. A natural spine running east-west across the island at approximately Y=-15m. This is the remnant of a major structural cross-beam — a reinforced stone spine that supported the upper tier. It presents as a low, rounded ridge with exposed stone along its crest.
- **Aviary platform:** +20m to +25m. Broad, relatively flat area. The original glasshouse floors create large rectangular level zones. The eastern edge of this platform drops sharply.
- **Upper Cascade Gardens:** +15m to +20m. The upper three terraces of the garden system. Each terrace is a level platform ~8–10m wide. The Central Reservoir sits at the highest terrace (+20m).
- **Cascade Reservoir basin:** +20m. A rectangular excavated basin ~15m × 10m, 2m deep. The bottom is lined with the original stone (still watertight). The overflow edge is at +20m; the basin floor is at +18m.

### 4.5 — Tier 3: The Summit (+30m to +42m)

**Footprint:** The northern fifth of the island. The Celestial Ring and the Stasis Sanctum.

**Surface character:** The most exposed terrain. Thin soil. Abundant exposed structural stone. The wind is constant. This tier feels like the top of a mountain — but the "mountain" is an engineered platform.

**Key elevation features:**
- **Celestial Ring platform:** +40m. A near-perfect circular platform ~45m diameter. The surface is the original observatory deck — shaped stone, precisely level, marked with calibration grooves and inlays. Soil accumulation is minimal (0–0.15m) due to wind scour.
- **Ring perimeter stones:** +40m to +42m. Sixteen shaped monoliths ringing the platform, each 1.5–2m tall, forming the visual crown of the island. These are the Standing Stones — calibration markers for celestial observations.
- **Ring approach ramp:** +30m to +40m. A broad, engineered ramp rising from the Aviary level to the Ring platform, switchbacking once along the southern face of the summit. The ramp is 4–5m wide with a low retaining wall on the outer edge.
- **Stasis Sanctum platform:** +35m. A separate plateau ~25m × 30m, set slightly lower than the Celestial Ring. The surface is perfectly level — the original Sanctum floor. This plateau is separated from the main summit mass by a 5–8m gap.
- **Sanctum approach bridge:** +35m. A narrow natural land bridge (actually the remnant of the original structural connector) spanning the gap between the Celestial Ring mass and the Sanctum plateau. Width: 3–4m. Length: 8m. Both sides drop to the Central Ridge below.

---

## 5. CLIFF LOCATIONS

### 5.1 — Primary Cliff: The Island Perimeter

The entire island is a cliff. The edge is the defining vertical feature.

**Perimeter cliff characteristics:**
- **Height:** 8–12m (distance from walkable surface to the underside of the structural slab).
- **Face angle:** 70°–90° (near-vertical to vertical). The original structural edge was cut clean. Erosion has produced irregularity — some sections overhang slightly, others have sloughed to 70°.
- **Edge treatment:** The structural slab is 3–8m thick. At the perimeter, this slab is exposed as a continuous stone face. Above the slab, accumulated soil creates a lip of 0.5–2m. In places, this lip has collapsed, leaving the raw structural edge exposed at the walkable surface.
- **Danger level:** Fatal fall. Stepping off the edge means falling through cloud layer to the surface thousands of feet below. The player character (vampire) catches themselves on the edge if they walk off accidentally — deliberate jumps are not prevented but are fatal.

### 5.2 — Secondary Cliffs: Tier Transition Faces

Each tier transition presents as a cliff or near-cliff face where the original retaining walls remain intact, and as a steep scree slope where they have collapsed.

**Tier 1→2 Transition (south face of Central Ridge):**
- Location: Running approximately east-west at Y=-15m to Y=-25m.
- Total length: ~110m.
- Intact retaining wall sections: ~40m (35%). Vertical or near-vertical stone face, 6–10m tall. The original engineered walls.
- Collapsed/scree sections: ~70m (65%). Slopes of 35°–50°, composed of stone blocks, gravel, and accumulated soil. Traversable on foot with effort.
- Key breaks: The main path from Atrium to Living Quarters cuts through this cliff line via the original staircase (now a steep but navigable stone ramp). The eastern approach to the Aviary similarly cuts through via the Aviary approach ramp.

**Tier 2→3 Transition (south face of Summit mass):**
- Location: Arcing across the north end of the island, approximately Y=+20m to Y=+35m.
- Total length: ~90m.
- Intact retaining wall sections: ~50m (55%). Better preserved than the lower transition — the summit walls were built to higher specification. Vertical stone face, 10–14m tall.
- Collapsed/scree sections: ~40m (45%).
- Key breaks: The Celestial Ring approach ramp is the only surface route to the summit. A collapsed stair on the east face (near the Stasis Sanctum bridge) is impassable without climbing ability (future).

### 5.3 — Isolated Cliffs

**Aviary Eastern Drop:**
- Location: Eastern edge of the Aviary platform, X=+50m to X=+55m, Y=-10m to Y=+15m.
- Height: 20–25m (from the Aviary platform at +25m to the Verdant Creep basin at +5m).
- Character: A near-vertical structural face. This was the east wall of the Aviary complex — the glasshouse framework was anchored to it. Without the glass, it presents as a dramatic cliff overlooking the wild Creep below.
- Navigability: Impassable without climbing. A future grappling anchor point.

**Cascade Gardens East Face:**
- Location: Eastern edge of the upper Cascade terraces.
- Height: 8–12m.
- Character: The retaining wall of the upper terraces, now partially collapsed. The exposed face shows the strata of the original construction — shaped stone blocks alternating with thinner bedding layers.

**Stasis Sanctum North Face:**
- Location: Northern edge of the Stasis Sanctum plateau.
- Height: 35m (from plateau surface at +35m to the cloud layer below).
- Character: The Sanctum was built at the absolute northern edge of the structural platform. Its north wall is the island's perimeter — a clean vertical drop into sky. The most dramatic cliff on the island.

---

## 6. PLATEAUS

### 6.1 — Plateau Definition

For this document, a "plateau" is a deliberately level surface of engineered origin, of sufficient size to host a district. All plateaus on the Ark are the original structural platforms the First Delvers built.

### 6.2 — The Atrium Plateau

- **Location:** Center-south. X=-30 to +30, Y=-80 to Y=-55.
- **Elevation:** +8m (floor), +10m to +12m (rim).
- **Area:** ~2,000 m².
- **Shape:** Roughly circular, 35m diameter.
- **Surface:** Original stone floor, level to within 0.1m across the entire surface. The floor has expansion joints at 3m intervals that now serve as drainage channels for accumulated soil.
- **Origin:** The floor of the central gathering hall. This was the largest single interior space on the Ark.

### 6.3 — The Departure Platform

- **Location:** Southern tip. X=-15 to +15, Y=-120 to Y=-105.
- **Elevation:** 0m.
- **Area:** ~450 m².
- **Shape:** Rectangular, 30m (E-W) × 15m (N-S).
- **Surface:** Original docking surface. Heavy-duty stone paving, designed to bear the weight of cargo vessels. The surface has tie-down points (recessed metal rings) at regular intervals.
- **Origin:** The primary arrival/departure dock. Every person and supply that ever reached the Ark crossed this platform.

### 6.4 — The Living Quarters Platform

- **Location:** West-central. X=-70 to X=-30, Y=-45 to Y=-10.
- **Elevation:** +15m to +20m.
- **Area:** ~1,600 m².
- **Shape:** Irregular rectangle, subdivided by original foundation walls into smaller level pads.
- **Surface:** Original residential foundations. Multiple level platforms at slightly different elevations (0.5–1.5m differences), connected by original steps and ramps. The Courtyard depression at the center is a level circle at +17m.
- **Origin:** The residential complex. Individual room foundations create the micro-terracing.

### 6.5 — The Aviary Plateau

- **Location:** East-central. X=+15 to X=+55, Y=-20 to Y=+20.
- **Elevation:** +20m to +25m.
- **Area:** ~1,800 m².
- **Shape:** Broad rectangle with a curved eastern edge.
- **Surface:** Original glasshouse floors — large, level stone platforms. Three connected level zones corresponding to the three original glasshouse chambers. The level changes between zones are gentle (0.3–0.5m).
- **Origin:** The greenhouse complex. The platforms are the original growing beds, now empty of their contained soil (which has mixed with the accumulated overburden).

### 6.6 — The Celestial Ring Plateau

- **Location:** North. X=-25 to +25, Y=+35 to Y+80.
- **Elevation:** +40m (platform), +42m (standing stone tops).
- **Area:** ~1,600 m².
- **Shape:** Perfect circle, 45m diameter.
- **Surface:** Original observatory deck. The most precisely engineered surface on the Ark. Calibration grooves (5cm wide, 2cm deep) radiate from the center. The surface is slightly domed (0.3m rise from edge to center) for drainage — the only non-level engineered surface on the Ark.
- **Origin:** The astronomical and atmospheric observation platform. The highest point of the Ark.

### 6.7 — The Stasis Sanctum Plateau

- **Location:** Northeast. X=+30 to X=+55, Y=+55 to Y=+85.
- **Elevation:** +35m.
- **Area:** ~750 m².
- **Shape:** Roughly rectangular, 30m (E-W) × 25m (N-S).
- **Surface:** Original archive floor. Level to within 0.05m. The surface is marked with layout lines for the original stasis chamber installations — subtle grooves indicating where equipment was positioned.
- **Origin:** The secure archive. This plateau was deliberately separated from the main summit mass for both security (single access point) and stability (isolated from vibrations that might affect sensitive stasis equipment).
- **Separation:** The plateau is disconnected from the main summit by a 5–8m wide gap. The only crossing is the narrow land bridge at +35m.

---

## 7. RAVINES & WATER CHANNELS

### 7.1 — Engineered vs. Eroded Channels

Two types of watercourse exist on the Ark:

| Type | Origin | Cross-Section | Distribution |
|------|--------|---------------|--------------|
| **Engineered channels** | Original water management system | Rectangular, stone-lined, 0.5–1.5m wide, 0.3–0.8m deep | Cascade Gardens, Atrium |
| **Erosion ravines** | 5,000 years of water following structural cracks | V-shaped, irregular, 0.3–3m wide, 0.2–2m deep | Throughout, concentrated at tier transitions |

### 7.2 — The Cascade Channel System (Engineered)

**Primary Channel:**
- **Course:** Central Reservoir (+20m) → south through the upper three terraces → Atrium rim (+10m) → Atrium fountain (+8m) → south through the Gatehouse → Departure Platform edge (0m).
- **Length:** ~110m.
- **Cross-section:** Rectangular cut stone, 1.2m wide, 0.6m deep at the upper section. Widens to 1.8m at the mid section where volume increases. Narrows to 0.6m at the Atrium fountain feed.
- **Condition:** Largely intact. Some sections are choked with accumulated debris. The stone lining is cracked in places but still directs flow.
- **Flow:** Continuous. The reservoir feeds the channel by gravity. Flow rate varies with rainfall.

**Distribution Channels (Terraces):**
- **Course:** Branch from the primary channel at each terrace level, running east-west along the terrace edges to distribute water across the growing beds.
- **Number:** 6 channels (one per growing terrace, three upper + three lower).
- **Cross-section:** Smaller — 0.5m wide, 0.3m deep. Some are silted and no longer flow.
- **Condition:** Variable. Upper terrace channels are mostly intact. Lower terrace channels are partially collapsed or buried.

**Settling Pool Feeds:**
- **Course:** Short channels (2–4m) connecting the distribution channels to the settling pools.
- **Cross-section:** 0.4m wide, 0.2m deep. The smallest engineered channels.

### 7.3 — The Atrium Drainage (Engineered)

- **Course:** Atrium fountain basin → underground channel → southern perimeter outflow.
- **Length:** ~35m (partially subterranean beneath the Atrium floor).
- **Cross-section:** Circular stone pipe, 0.4m diameter, running beneath the Atrium floor slabs.
- **Condition:** Intact but partially blocked. Flow is reduced. Some water backs up into the fountain basin, creating the bioluminescent moss habitat.

### 7.4 — The Central Ridge Ravine (Erosion)

- **Location:** Cutting through the Central Ridge approximately at X=-5m, from Y=-30m to Y=-10m.
- **Length:** ~25m.
- **Width:** 2–4m at the top, 0.5–1m at the bottom.
- **Depth:** 3–6m (cuts through the entire ridge depth to the underlying platform).
- **Origin:** A structural expansion joint in the Central Ridge that water exploited over 5,000 years. The ravine exposes the internal strata of the ridge — layers of structural stone, fill material, and the original platform surface at the bottom.
- **Cross-section:** V-shaped, with exposed stone blocks on both faces.
- **Navigability:** Passable at the bottom (narrow but walkable). Steep sides. A natural shortcut between the Living Quarters approach and the Aviary approach.

### 7.5 — The Verdant Creep Drainage Ravines (Erosion)

- **Location:** Multiple small ravines throughout the Verdant Creep basin, radiating from the higher eastern ground toward the lower western edge.
- **Number:** 5–8 distinct channels.
- **Typical dimensions:** 0.5–2m wide, 0.3–1.5m deep, 10–30m long.
- **Origin:** Water draining from the Aviary platform above, finding paths through the structural cracks in the dome foundations. The ravines follow the original floor drainage pattern.
- **Character:** Soft-edged (heavy soil accumulation), often damp or muddy. The primary fungal habitat on the island.

### 7.6 — The Southern Edge Ravine (Erosion)

- **Location:** Running along the southern edge of the island, east of the Departure Platform, from X=+15 to X=+40, Y=-110 to Y=-95.
- **Length:** ~30m.
- **Width:** 1–3m.
- **Depth:** 2–5m.
- **Origin:** A structural crack near the southern perimeter that has widened dramatically. The ravine opens directly to the sky at its deepest point — you can see clouds through the crack. A dramatic feature that emphasizes the island's nature.
- **Hazard:** The crack narrows toward the bottom. A player who falls in would be wedged, not fall through — but the sensation of seeing open sky beneath their feet is the intended effect.

---

## 8. WATERFALLS

### 8.1 — Primary Waterfall: The Reservoir Overflow

- **Location:** South face of the Central Reservoir, Cascade Gardens, at approximately X=+30, Y=-35.
- **Height:** 4m (from the reservoir overflow lip at +20m to the upper terrace pool at +16m).
- **Width:** 1.5–3m (varies with flow rate).
- **Type:** Engineered overflow — a rectangular notch in the reservoir's south wall designed to spill excess water.
- **Flow:** Continuous moderate flow, increasing significantly after rain. The waterfall never runs dry — the reservoir's catchment area is sufficient to maintain base flow year-round.
- **Sound:** The dominant water sound in the Cascade Gardens. Audible from the Atrium in quiet conditions. A navigation cue.
- **Visual:** A clean sheet of water falling onto a stone apron at the base, then channeling into the primary distribution channel.
- **Erosion effect:** The stone apron at the base shows 5,000 years of water impact — a shallow bowl worn into the stone, 0.3m deep.

### 8.2 — Cascade Terrace Waterfalls (×5)

- **Location:** At each terrace step in the Cascade Gardens, where water transitions from one level to the next.
- **Heights:** 1.5–2.5m each.
- **Type:** Mixed — some are engineered overflow lips, others are now cascading over collapsed retaining wall sections.
- **Flow:** Variable. The upper three are reliable (fed by the reservoir). The lower two are intermittent (fed by distribution channels that are partially blocked).
- **Character:** These are small, intimate waterfalls — not dramatic features but gentle, musical cascades. The sound of falling water is the defining audio of the Cascade Gardens.

### 8.3 — Atrium Fountain

- **Location:** Center of the Atrium, X=0, Y=-68, Z=+8m.
- **Height:** 1.5m (from the fountain head to the basin).
- **Type:** Engineered fountain — the original central water feature of the gathering hall. A vertical stone column with water emerging from the top and falling into a circular basin.
- **Flow:** Continuous but reduced from original output. The feed pipe is partially blocked.
- **Basin:** Circular, 4m diameter, 0.5m deep. The basin overflows into the Atrium drainage channel.
- **Significance:** This is the first water sound the player hears upon awakening. It draws them to the center of the Atrium.

### 8.4 — Southern Perimeter Spill (Hidden)

- **Location:** Where the Atrium drainage exits at the southern face of the island, beneath the Departure Platform.
- **Height:** 10m (from the outflow pipe to the underside of the structural slab, where the water disperses into mist).
- **Type:** Subterranean pipe outflow — water emerges from a stone pipe on the island's underside face and falls as a diffuse spray.
- **Visibility:** Not visible from the island surface. Can be seen from below (if the player ever accesses an underside viewing position) as a wisp of mist emerging from the southern face.
- **Flow:** Continuous, small volume.

---

## 9. RIVERS & STREAMS

### 9.1 — The Primary Stream

- **Course:** Reservoir overflow → Cascade primary channel → Atrium fountain → underground drain → southern perimeter outflow.
- **Length:** ~110m total (85m surface, 25m subterranean).
- **Character:** An engineered channel for most of its length, transitioning to a more naturalistic stream in sections where the channel lining has broken and the water has found its own path.

### 9.2 — Terrace Distribution Streams

- **Number:** 6 (one per growing terrace).
- **Length:** 8–15m each.
- **Character:** Shallow, slow-moving. The intact ones are clearly engineered — straight lines, stone-lined. The broken ones meander through soil, creating small wetland patches.

### 9.3 — Verdant Creep Seeps

- **Number:** 3–5 small streams.
- **Source:** Groundwater seepage from the Aviary plateau above, emerging at the base of the Aviary eastern cliff.
- **Length:** 10–30m each.
- **Character:** Naturalistic — these are not engineered. They follow the paths of least resistance through the accumulated soil, creating damp corridors in the Creep. Several terminate in small muddy pools. One reaches the island edge and spills over as a thin, wind-scattered trickle.
- **Flow:** Intermittent. Strongest after rain. Some dry up during extended dry periods.

### 9.4 — The Courtyard Spring

- **Location:** Living Quarters Courtyard depression, X=-50, Y=-25.
- **Source:** A crack in the courtyard basin floor that taps into a subsurface water pocket — likely a broken section of the Ark's internal plumbing.
- **Flow:** A constant trickle — too small to call a stream, but enough to keep the courtyard basin damp year-round.
- **Significance:** This spring is why the Courtyard Tree survived. Its roots found water here.

---

## 10. LAKES & POOLS

### 10.1 — The Central Reservoir

- **Location:** Cascade Gardens upper terrace, X=+25 to X=+40, Y=-30 to Y=-40.
- **Elevation:** Surface at +20m, floor at +18m.
- **Dimensions:** 15m (N-S) × 10m (E-W).
- **Area:** ~150 m².
- **Depth:** 2m.
- **Type:** Engineered water storage basin. Rectangular, stone-lined. The walls and floor are the original construction, still watertight. The east and west walls have stone steps descending into the water (original access for cleaning and maintenance).
- **Water quality:** Clear, cold, potable. Filtered through the Ark's original catchment and filtration system, which still functions passively.
- **Inflow:** Rainwater catchment from the Celestial Ring plateau above, directed through an internal channel system.
- **Outflow:** The primary channel (south) and the distribution channels (east and west).
- **Edge character:** The north edge butts against the Tier 3 retaining wall. The south edge is the overflow lip. The east and west edges are level with the surrounding terrace surface.

### 10.2 — The Settling Pools (×5)

- **Location:** Cascade Gardens, one at each terrace transition.
- **Typical dimensions:** 3–5m diameter, 0.5–1.2m deep.
- **Type:** Engineered water treatment features. Rectangular or circular stone basins where sediment settles before water continues to the next terrace.
- **Condition:** Variable. The upper three are intact and still function — water is clear, stone lining visible. The lower two are partially silted, with accumulated organic matter.
- **Ecology:** The intact pools support aquatic plants. The silted pools have become boggy margins — the primary clay source on the island.

### 10.3 — The Atrium Fountain Basin

- **Location:** Atrium center, X=0, Y=-68.
- **Elevation:** Water surface at +7.5m, basin floor at +7m.
- **Dimensions:** Circular, 4m diameter.
- **Depth:** 0.5m.
- **Type:** Original decorative/functional water feature. Stone basin with carved edges.
- **Condition:** Functional. The basin is intact. The water is clear but stained amber by tannins from accumulated leaf litter.
- **Special feature:** Bioluminescent moss grows on the basin walls below the waterline, producing a soft blue-green glow visible in low light.

### 10.4 — The Verdant Creep Pools

- **Location:** Scattered throughout the Verdant Creep basin, in natural depressions.
- **Number:** 4–6 pools.
- **Typical dimensions:** 1–3m diameter, 0.2–0.5m deep.
- **Type:** Natural accumulations — water collecting in structural depressions (former dome floor features) lined with accumulated clay and organic matter.
- **Character:** Dark, still, tannin-stained. The primary amphibian habitat. Some pools are seasonal; others are permanent (fed by the Aviary seeps).

### 10.5 — The Courtyard Pool

- **Location:** Living Quarters Courtyard depression, at the base of the Courtyard Tree.
- **Dimensions:** 2m diameter, 0.2m deep.
- **Type:** A natural pool formed where the Courtyard Spring emerges and collects in a shallow basin worn into the original courtyard paving.
- **Character:** Small, intimate, perpetually shaded by the Courtyard Tree's canopy. The most sheltered water feature on the island.

---

## 11. NATURAL ARCHES & STONE BRIDGES

### 11.1 — The Sanctum Bridge (Engineered Remnant)

- **Location:** Spanning the gap between the Celestial Ring mass and the Stasis Sanctum plateau, X=+28 to X=+36, Y=+55.
- **Type:** Original structural connector — a reinforced stone span that was the only access to the Sanctum.
- **Dimensions:** 8m long, 3–4m wide, ~2m thick.
- **Elevation:** Walkway surface at +35m. Underside at +33m. Gap below: open to +25m (the Central Ridge surface).
- **Condition:** Structurally sound. The original construction was over-engineered for security. Surface shows 5,000 years of weather exposure but no cracking.
- **Character:** Narrow enough to feel exposed. No railings (the original had them; they've since corroded or fallen away). Crossing this bridge is the player's first experience of true exposure on the Ark — open sky on both sides, a 10m drop to the ridge below, and the cloud layer far beneath that.

### 11.2 — The Cascade Arch (Erosion Feature)

- **Location:** Cascade Gardens middle terraces, X=+35, Y=-45.
- **Type:** A section of retaining wall where erosion has undercut the stone, creating a natural arch.
- **Dimensions:** 3m span, 2m height at the opening center, the wall above is 1.5m thick.
- **Origin:** Water from a distribution channel found a weakness between two stone blocks and eroded the fill behind them. Over millennia, the water carved through completely, leaving the upper blocks spanning the gap.
- **Character:** A small, intimate arch. Water still trickles through the opening during wet periods. The arch serves as an informal shortcut between adjacent terraces.

### 11.3 — The Creep Root Arch (Biological-Structural Hybrid)

- **Location:** Verdant Creep, X=+60, Y=-70.
- **Type:** A structural crack across which a large root has grown, creating a natural bridge of living wood and stone.
- **Dimensions:** 4m span, 1.5m wide at the narrowest.
- **Origin:** A crack in the dome foundation created a gap ~3m wide. A tree root from the Aviary plateau above grew down through the gap, then laterally across it, thickening over centuries into a traversable surface.
- **Condition:** Stable but organic — it flexes slightly underfoot.
- **Note:** While this feature involves vegetation, the ROOT is defined here as terrain because it functions as a structural landform. The tree that produced it belongs to the vegetation layer. The terrain artist sculpts the crack, the gap, and the root mass protruding from the west face. The vegetation artist adds the tree, bark texture, and foliage.

### 11.4 — The Perimeter Arch (Erosion Feature)

- **Location:** Southern edge of the island, east of the Departure Platform, X=+20, Y=-108.
- **Type:** A section of the island perimeter where the structural slab has eroded from both sides, leaving a stone bridge between two sections of the edge.
- **Dimensions:** 5m span, 3m wide, with open sky visible through the gap below.
- **Origin:** The Southern Edge Ravine (Section 7.6) has cut through the structural slab near the perimeter, leaving a remnant bridge of harder stone that has resisted erosion.
- **Character:** The most dramatic natural arch on the island. Walking across it means seeing clouds through cracks in the stone beneath your feet. The arch is solid but looks fragile.
- **Safety:** The arch is structurally sound (it is the original structural slab material, which supported the entire island's weight for 15,000 years). But it *feels* dangerous, which is the point.

---

## 12. CAVES & UNDERCUTS

### 12.1 — The Sunken Lab Cavern (Structural Cavity)

- **Location:** Verdant Creep, X=+65, Y=-80, Z=+3m (floor).
- **Type:** A subsurface chamber — the original control room for the ecological simulation domes, now buried beneath accumulated soil and accessible only through a collapsed section of its roof.
- **Dimensions:** Interior: ~8m × 12m, height 2.5–3m. Access opening: irregular hole in the "ceiling," ~2m × 3m.
- **Entry:** The player descends through a root cavity (a gap between large roots that have grown over the collapsed roof) into the chamber below.
- **Interior:** The original control room floor at +3m. Walls are the original structural stone. The room is dark (no natural light except through the entry hole). Dry. The air is still.
- **Connections:** A corridor leads north from the chamber but is blocked by structural collapse after 6m. Debris from the collapsed roof forms a rubble pile in the chamber's southeast corner.
- **Terrain note:** The terrain artist sculpts the depression above, the root cavity opening, the chamber interior, and the blocked corridor stub. The ruin elements (consoles, equipment) are architecture layer.

### 12.2 — The Perimeter Undercuts (Erosion Features)

- **Location:** Multiple locations around the island perimeter where the structural slab has eroded more rapidly than the overlying material, creating shallow undercuts.
- **Number:** 8–12.
- **Typical dimensions:** 1–3m deep, 2–5m wide, 1–2m high.
- **Character:** Shallow overhangs at the island edge. They provide sheltered nooks and a visceral sense of the edge — standing in one, the player has stone above them and open sky in front of and below them.
- **Hazard:** The floor of these undercuts is the structural slab surface, which may be cracked or unstable near the edge. Some undercuts have collapsed sections.

### 12.3 — The Cascade Reservoir Maintenance Tunnel (Engineered)

- **Location:** Beneath the Central Reservoir east wall, X=+38, Y=-32, Z=+17m.
- **Type:** Original access tunnel for reservoir maintenance — a rectangular stone passage.
- **Dimensions:** 1.2m wide, 1.8m high, currently accessible for ~5m before a collapse blocks further progress.
- **Entry:** A stone archway set into the east face of the reservoir basin, partially hidden by accumulated soil and vegetation. The lower half is often submerged (the entry is at +18.5m; the reservoir surface is at +20m, but can drop below the entry during dry periods).
- **Interior:** Dark, damp, stone-lined. The floor has a shallow drainage channel. The walls have original tool markings.
- **Collapse:** The tunnel is blocked by a ceiling collapse 5m in. Beyond the collapse, the tunnel continues to the Ark's internal plumbing system (future content).

### 12.4 — The Atrium Sub-Floor Void (Engineered)

- **Location:** Beneath the Atrium floor, accessible through a displaced floor slab at X=+10, Y=-65.
- **Type:** The service space between the Atrium's finished floor and the structural platform beneath it. Original utility crawlspace.
- **Dimensions:** 0.8–1.2m height (crawl space only), extending ~15m × 15m beneath the Atrium.
- **Entry:** A single displaced floor slab (2m × 1.5m) that has tilted, creating an opening.
- **Interior:** Dark, confined. The underside of the floor slabs above. Original pipes and conduits (architecture layer). The floor is the raw structural platform surface.
- **Accessibility:** Crawl-only. Not intended as a primary navigation route — a hidden area for the thorough explorer.

---

## 13. ROCK FORMATIONS & OUTCROPS

### 13.1 — The Standing Stones (Engineered Monoliths)

- **Location:** Ringing the Celestial Ring platform.
- **Number:** 16 stones.
- **Dimensions:** Each 0.8–1.2m wide, 1.5–2m tall, 0.4–0.6m thick.
- **Material:** Shaped resonance-stabilized stone, distinct from the platform stone — darker, denser, with visible crystal inclusions that catch light.
- **Arrangement:** Irregularly spaced around the 45m diameter circle — the spacing corresponds to specific celestial alignments, not aesthetic symmetry. Gaps between stones vary from 4m to 9m.
- **Condition:** Excellent. The stones were engineered for permanence. Weathering is superficial. Inscriptions (architecture layer) are still legible.
- **Terrain note:** The terrain artist places the stones as part of the summit rock formation set. The inscriptions and calibration markings are detail-layer work.

### 13.2 — The Central Ridge Outcrop

- **Location:** The crest of the Central Ridge, X=-5 to +5, Y=-15 to Y=-20.
- **Type:** Exposed structural stone — the uppermost surface of the reinforced cross-beam that forms the ridge.
- **Character:** A low, rounded spine of darker, denser stone. Unlike the surrounding terrain (which has accumulated soil), the outcrop is bare rock, scoured clean by wind. The surface is smooth — polished by millennia of wind abrasion.
- **Dimensions:** 15m long, 3–6m wide, standing 0.5–2m above the surrounding soil level.
- **Features:** Natural seating — wind has sculpted shallow hollows in the softer bands of the stone. Several hollows are large enough to sit in.

### 13.3 — The Gatehouse Pillars (Eroded Structural Remnants)

- **Location:** Flanking the approach from the Gatehouse to the Atrium, X=-10 and X=+10, Y=-85.
- **Type:** The eroded remnants of the original Gatehouse entrance portal — two large stone pillars.
- **Dimensions:** Each ~2m diameter at base, 3–5m tall (irregular — the tops are fractured).
- **Material:** Original structural stone, now heavily weathered. Vertical fissures run through both pillars.
- **Character:** They read as "ruined gateway" — clearly shaped, clearly broken. They frame the approach to the Atrium and create a natural threshold.

### 13.4 — Scattered Talus

- **Location:** At the base of all retaining walls and cliff faces.
- **Type:** Accumulated stone debris — blocks that have detached from the structural faces above and accumulated in scree slopes and talus fans.
- **Block sizes:** Range from gravel (0.02m) to large blocks (1.5m diameter).
- **Character:** Angular, not rounded — no water transport. The blocks at the top of talus slopes are larger (more recent falls). The blocks at the bottom are smaller and partially buried in accumulated soil (older falls, partially decomposed).
- **Key talus fields:**
  - Below the Tier 2→3 retaining wall (north face): the largest talus field, ~40m long, blocks up to 1m diameter.
  - Below the Aviary eastern cliff: a steep talus slope descending into the Verdant Creep.
  - Below the Tier 1→2 retaining wall: scattered talus, mostly buried in accumulated soil.

### 13.5 — Exposed Crystal Veins

- **Location:** Specific exposed rock faces where the structural stone has cracked to reveal resonance crystal inclusions.
- **Number:** 5–8 visible outcrops.
- **Dimensions:** Veins 0.1–0.5m wide, 1–3m long.
- **Character:** Crystalline material — distinct from the structural stone. The crystals have a faint natural luminescence (visible only in low light). The rock around the veins is discolored by millennia of resonance field exposure — darker, with a subtle iridescent patina.
- **Key locations:**
  - Celestial Ring southern face (largest exposure — a vein ~3m long, 0.5m wide)
  - Cascade Gardens east face (two smaller veins)
  - Central Ridge Outcrop (one vein visible on the west face)
  - Stasis Sanctum north face (one vein at the absolute edge — dramatic location)
- **Terrain note:** The terrain artist sculpts the crack that exposes the vein and defines the vein's shape in the rock face. The crystal material and glow effect are material/texture layer.

---

## 14. FLOATING FRAGMENTS

### 14.1 — Fragment Definition

Floating fragments are detached pieces of the Ark — structural elements that have broken away from the main island but remain aloft due to residual resonance charge in their crystal inclusions. Each fragment is a smaller floating island in its own right, held in a fixed relative position by resonance field interactions with the main Ark.

### 14.2 — The Western Fragment (Gatehouse Outpost)

- **Location:** West of the Gatehouse, centered at approximately X=-65, Y=-90, Z=+3m.
- **Distance from main island:** ~15m at the closest point.
- **Dimensions:** ~20m × 12m, irregular shape.
- **Elevation:** Surface ranges from +3m to +7m (slightly lower than the Gatehouse).
- **Character:** A broken-off piece of the Ark's western structural expansion. The upper surface is the original structural platform with a small structure foundation (a supply depot or communication relay station). The break face (facing the Ark) is jagged — exposed structural strata and snapped crystal veins are visible.
- **Connection to Ark:** The Collapsed Bridge (a broken stone span) extends ~6m from the Ark's west edge toward the fragment. The remaining gap is ~9m. Grappling hook range.
- **Stability:** The fragment has a slight wobble — a slow, barely perceptible oscillation (period ~30 seconds, amplitude ~0.3m at the edges). This is a clue that its resonance array is damaged and will eventually fail.
- **Future access:** Grappling hook ability.

### 14.3 — The Eastern Fragment (Detached Laboratory)

- **Location:** East of the Verdant Creep, centered at approximately X=+100, Y=-60, Z=+5m.
- **Distance from main island:** ~20m.
- **Dimensions:** ~15m × 10m.
- **Elevation:** +5m to +9m.
- **Character:** A small detached section that appears to have been a standalone laboratory module. A single small structure (intact — the module was sealed when it detached). The break suggests it was a deliberate jettison rather than an accident — the separation face is cleaner than the Western Fragment.
- **Visibility:** Partially obscured by the Creep canopy from most angles. Visible from the Aviary eastern edge.
- **Future access:** Gliding or grappling.

### 14.4 — The Southern Debris Field

- **Location:** Scattered south of the Departure Platform, ranging from X=-30 to X=+40, Y=-130 to Y=-160.
- **Number of fragments:** 8–15 small pieces.
- **Typical dimensions:** 0.5m to 5m across.
- **Character:** Small debris — detached edge blocks, a broken cargo cradle, what appears to be a section of railing. These fragments are too small to land on but create visual interest below the Departure Platform. They are held in a loose cloud by residual resonance.
- **Movement:** The smaller fragments drift slightly — their positions shift by 0.5–1m over the course of a day. They are not fixed in place like the larger fragments.
- **Danger:** None (they are below the player). Purely visual.

### 14.5 — The Underside Fragments

- **Location:** Attached to or suspended just below the underside of the main structural slab.
- **Number:** 20–30 fragments.
- **Typical dimensions:** 1–8m across.
- **Character:** Blocks of structural stone that have partially separated from the underside but remain held in place by residual resonance fields. They appear to be "peeling away" from the underside — some are attached by a thin remaining connection, others float in place with a 0.5–2m gap between them and the main slab.
- **Visibility:** Visible only from below or from the Perimeter Arch where the player can see through the slab crack.
- **Significance:** These fragments communicate that the Ark is slowly degrading — the resonance arrays are losing their grip on the structural mass, one block at a time.

---

## 15. UNDERSIDE SHAPE

### 15.1 — General Form

The underside of the Ark is an inverted, simplified version of the top surface. It is the exposed structural slab — the engineering floor from which the entire island was constructed.

The underside is **not flat**. It is shaped by:
- The original structural geometry (honeycomb reinforcement pattern, thicker at the center, thinner at the edges)
- Resonance crystal array housings (distinct circular and linear features)
- Partial detachment of surface blocks (Section 14.5)
- The outflow of the internal drainage system (Section 8.4)

### 15.2 — Cross-Section Profile

```
     TOP SURFACE (varied terrain)
╔═══════════════════════════════════════╗
║                                       ║  ← Accumulated soil (0.1–3m)
║  ───────────────────────────────────  ║  ← Original surface (engineered stone)
║                                       ║
║  STRUCTURAL SLAB (8–12m thick)       ║  ← Resonance-stabilized stone matrix
║                                       ║     with embedded crystal arrays
║  ───────────────────────────────────  ║
║                                       ║  ← Underside surface
║  Crystal array housings (recessed)   ║
║  Drainage outflow points             ║
║  Detaching fragments                 ║
╚═══════════════════════════════════════╝
```

### 15.3 — Underside Features

**Central Reinforcement Hub:**
- Location: Directly beneath the Atrium, at the center of mass.
- Character: A massive, thickened section of the structural slab — a circular reinforced zone ~40m diameter that extends 3–4m below the general underside level. This is the primary structural anchor — the point from which the Ark's mass is supported.
- Surface: The underside of the hub is patterned with concentric rings — the resonance array anchor points. At the center, a single large crystal housing (now dark, but originally the primary lift node) sits in a recessed socket.

**Radial Reinforcement Ribs:**
- Number: 8 ribs radiating from the Central Hub to the perimeter.
- Character: Thickened ribs in the structural slab, visible on the underside as raised bands 2–3m wide and 1–2m deep. These distributed the resonance lift from the central hub across the entire platform.
- Pattern: Not perfectly radial — they follow the internal stress paths of the hexagonal platform shape. Some ribs align with the tier retaining walls above.

**Crystal Array Housings:**
- Location: Distributed across the underside, concentrated along the reinforcement ribs and at the perimeter.
- Number: 30–40 visible housings.
- Character: Circular recesses 1–3m diameter, 1–2m deep, set into the underside surface. Each housing once contained a resonance crystal array. Most are now dark, but a few still emit faint amber light (functioning arrays). The pattern of lit vs. dark housings is not uniform — the eastern quadrant has more active arrays (the ones recharged 200 years ago).

**Drainage Outflow Points:**
- Number: 5–8.
- Character: Stone pipe openings on the underside, mostly near the perimeter. Water emerges from these as a diffuse mist or trickle. The southern outflow (beneath the Departure Platform) is the largest.

**Perimeter Underside Edge:**
- The transition from the vertical perimeter face to the underside surface. At this transition, the structural slab thickness is visible in cross-section. Crystal veins and construction strata are exposed.

### 15.4 — Underside Accessibility

The underside is not accessible from the top surface in the initial game state. Future content may provide:
- Access from the Resonance Core (beneath the Celestial Ring) to underside maintenance gantries.
- Grappling routes along the underside, using the crystal housings and reinforcement ribs as anchor points.
- An underside traversal experience — navigating the "ceiling" of the world, with the surface thousands of feet below.

---

## 16. WALKABLE SURFACES

### 16.1 — Definition

A "walkable surface" is any terrain with a slope ≤ 45° that does not require climbing or special traversal to navigate. The player can walk, run, and jump on walkable surfaces.

### 16.2 — Walkable Surface Map

| Surface Type | Coverage (% of island area) | Typical Slope | Surface Material |
|-------------|----------------------------|---------------|------------------|
| Level engineered surfaces (plateaus, platforms) | ~30% | 0–5° | Original stone paving (often beneath thin soil) |
| Gentle slopes (accumulated soil) | ~35% | 5–20° | Soil with embedded stone fragments |
| Moderate slopes (scree, terrace transitions) | ~15% | 20–35° | Loose stone, gravel, exposed structural stone |
| Steep but walkable (ravine floors, narrow ridges) | ~8% | 35–45° | Exposed structural stone |
| Non-walkable (cliffs, drop-offs, vertical faces) | ~12% | >45° | Various |

### 16.3 — Continuous Walkable Network

The entire island is connected by continuous walkable terrain. There are no jumps required to reach any district. The player can walk from the Departure Platform (0m) to the Celestial Ring (+42m) without climbing or jumping.

Key transitions:
- **Gatehouse to Atrium:** Broad ramp, 2–5° slope, ~30m long.
- **Atrium to Cascade Gardens lower:** Level transition.
- **Cascade Gardens ascent (lower to upper):** Terrace steps, each 1.5–2.5m rise, via intact staircase remnants or collapsed wall ramps.
- **Atrium to Living Quarters:** Steep but walkable path through a break in the Tier 1→2 retaining wall, 20–35° slope in sections. The original staircase has collapsed into a navigable stone ramp.
- **Atrium to Verdant Creep:** Level to gentle slope.
- **Aviary to Celestial Ring:** The switchback ramp, 10–15° slope, 4–5m wide.
- **Celestial Ring to Stasis Sanctum:** The Sanctum Bridge, level, 3–4m wide.

### 16.4 — Marginal Walkable Surfaces

Some surfaces are technically walkable but narratively or mechanically significant:

- **The Perimeter Arch (Section 11.4):** Walkable but feels dangerous. The surface has visible cracks with sky showing through.
- **The Sanctum Bridge (Section 11.1):** Walkable but narrow with no railings. Wind gusts can be felt.
- **The Departure Platform edge:** The last 2m of the platform surface slopes slightly (1–2°) toward the edge — subtle but perceptible. Designed to make the player slow down as they approach the edge.
- **Ravine floors:** Walkable but confined. The Central Ridge Ravine floor is 0.5–1m wide — the player must walk single-file through the bottom.

### 16.5 — Future Non-Walkable Surfaces (Currently Inaccessible)

Areas that exist as terrain but are not yet reachable:

- The Western Fragment surface.
- The Eastern Fragment surface.
- The Aviary Upper Gallery (the floor exists but is at +30m, accessible only via unsafe structure).
- The Resonance Core interior (subterranean, entrance locked).
- The Sunken Lab deeper levels (blocked by collapse).

---

## 17. DANGEROUS DROP-OFFS

### 17.1 — Classification

| Class | Description | Consequence | Edge Treatment |
|-------|-------------|-------------|----------------|
| **Class A — Perimeter Edge** | The island boundary. Drop to open sky. | Fatal fall (thousands of feet to surface). | Natural barriers preferred. Player character catches themselves on edge if walking. Deliberate jump = death. |
| **Class B — Tier Transition** | Internal cliff faces between tiers. | Injury (10–14m fall to hard surface below). | Some edges have retaining walls; others are open. |
| **Class C — Ravine Edge** | Edges of deep ravines and cracks. | Injury (3–6m fall into confined space). | Edges are often overgrown — vegetation layer provides warning cues. |
| **Class D — Undercut Edge** | Perimeter undercuts where the surface overhangs void. | If the undercut floor collapses: fatal fall. | These edges are inherently unstable. The terrain should communicate "don't stand here long." |

### 17.2 — Class A: Perimeter Edge Detail

**Total length:** ~580m.

**Edge treatments (from most to least common):**

1. **Soil lip with vegetation buffer (35%):** A 1–3m band of thicker soil at the edge, supporting dense vegetation (vegetation layer). The soil lip creates a natural "slow down" zone — the ground becomes softer and less even as you approach the edge. The vegetation provides a visual barrier.

2. **Exposed structural edge (25%):** The raw stone edge of the structural slab. No soil. No buffer. Clean, sharp, dangerous. These sections are the original perimeter faces where wind scour has prevented soil accumulation. They read as "don't get close."

3. **Retaining edge with low wall (20%):** The original retaining wall still stands at the perimeter, creating a knee-to-waist-high stone barrier. The wall may be partially crumbled but still defines the edge. These sections feel safer but still exposed.

4. **Scree slope to edge (15%):** Where the edge has partially collapsed, creating a slope of loose stone that terminates at the drop. These sections are treacherous — the footing is unstable near the edge. The player character will visibly struggle (foot slides, stones dislodge) when approaching.

5. **Platform edge (Departure Platform) (5%):** The original docking surface. No barrier. A clean line between level stone and open sky. The most dramatic single edge on the island. Designed for ships to dock — not designed to prevent falls.

### 17.3 — Class B: Tier Transition Detail

**Total length of internal cliffs:** ~200m (both tier transitions combined).

These are navigational barriers, not fatal hazards. Falling off a tier transition means:
- Landing on the tier below (hard stone or soil surface)
- Injury but not death
- Having to find the path back up

The tier transition edges are marked by:
- Intact retaining wall sections (clearly visible, waist-high or taller)
- Collapsed sections where the edge is a scree slope (traversable but steep)
- The original staircases and ramps that provide the legitimate routes between tiers

### 17.4 — Warning Language (Terrain Cues)

The terrain itself must communicate danger before the player reaches the edge. The terrain artist uses these cues:

- **Slope increase:** The ground tilts slightly toward the edge in the last 2–3m.
- **Surface change:** Soil becomes thinner, exposing stone beneath. Footsteps change sound.
- **Debris size gradient:** Near edges, accumulated debris is smaller (wind removes loose material).
- **Vegetation stunting:** In the vegetation layer, plants near edges are shorter, wind-shaped, or absent (flagging to the vegetation artist).
- **Crack patterns:** Fissures in the stone run parallel to the edge in the last 1–2m, indicating stress.

---

## 18. NATURAL CHOKEPOINTS

### 18.1 — Definition

A chokepoint is any location where the walkable terrain narrows to ≤ 5m width, naturally constricting player movement. Chokepoints serve as implicit navigation guides — they funnel the player toward specific paths and create memorable spatial transitions.

### 18.2 — Primary Chokepoints

| # | Name | Location | Width | Character |
|---|------|----------|-------|-----------|
| 1 | **The Gatehouse Portal** | Between Gatehouse and Atrium approach, Y=-82 | 8m → 5m → 8m | The ruined pillars narrow the path, creating a threshold |
| 2 | **The Cascade Narrows** | Between the Central Reservoir and the east perimeter, X=+35, Y=-35 | 4m | The path between the reservoir wall and the tier retaining wall |
| 3 | **The Ridge Gap** | Where the Central Ridge Ravine cuts through the ridge crest, X=-5, Y=-18 | 6m | The ravine interrupts the ridge; the path crosses at a natural bridge |
| 4 | **The Sanctum Bridge** | Approach to the Stasis Sanctum, X=+32, Y=+55 | 3–4m | The only surface route to the Sanctum plateau |
| 5 | **The Aviary Approach** | Eastern ascent from the Atrium to the Aviary, X=+18, Y=-45 | 5m | A ramp between two retaining wall sections |
| 6 | **The Departure Neck** | Where the Departure Platform joins the main island, Y=-105 | 12m | The platform widens beyond this point — the neck is the transition from "island" to "sky" |
| 7 | **The Summit Switchback** | The turn in the Celestial Ring approach ramp, Y=+30 | 5m | The ramp turns 180° here — the only place on the ascent where the player changes direction |
| 8 | **The Creep Entrance** | Where the path from the Atrium enters the Verdant Creep, X=+40, Y=-65 | 6m | The transition from open terrain to dense understory (vegetation layer will narrow this further) |

### 18.3 — Chokepoint Design Principles

- **No chokepoint blocks progress.** Every chokepoint is passable without special abilities.
- **Each chokepoint marks a transition.** District boundaries, tier changes, or significant environmental shifts occur at chokepoints.
- **Chokepoints are memorable.** The player should remember "the narrow bridge," "the switchback," "the gap between the pillars." These become navigation references.
- **Chokepoints are naturally formed.** They arise from the terrain, not from placed barriers. The Sanctum Bridge is narrow because the gap it spans is real. The Cascade Narrows exist because the reservoir and the retaining wall are real structures that happen to be close together.

---

## 19. VIEWPOINTS

### 19.1 — Definition

A viewpoint is a location where the terrain naturally encourages the player to stop and look. Viewpoints are created by:
- A level or slightly raised standing area at the edge of a vertical drop
- A natural "frame" (cliffs, pillars, arches) that directs the gaze
- An arrival point after a significant ascent where the player naturally pauses

### 19.2 — Primary Viewpoints

| # | Name | Location | Elevation | What You See | Emotional Beat |
|---|------|----------|-----------|--------------|----------------|
| 1 | **The Awakening Point** | Atrium center, on the Great Table location, X=0, Y=-68 | +8m | The Shattered Dome above, the fountain, corridors leading away | First view of the game world |
| 2 | **The Departure Edge** | Departure Platform tip, X=0, Y=-120 | 0m | Open sky, clouds below, surface world distantly visible through breaks | Realization: "I'm floating" |
| 3 | **The Reservoir Overlook** | Central Reservoir south edge, X=+30, Y=-35 | +20m | The entire Cascade Gardens descending below, the Atrium beyond, the Gatehouse in the distance | The Ark as an engineered system becoming visible |
| 4 | **The Courtyard Clearing** | Living Quarters Courtyard, X=-50, Y=-25 | +17m | The Courtyard Tree canopy above, the rooms ringing the courtyard | Intimacy, shelter, "people lived here" |
| 5 | **The Aviary Vista** | Aviary eastern edge, X=+55, Y=0 | +25m | The Verdant Creep basin below, the Eastern Fragment, distant islands on the eastern horizon | The world beyond the Ark; other islands as future destinations |
| 6 | **The Ring Panorama** | Celestial Ring platform, any point near the edge, X=0, Y=+65 | +40m | 360° view — the entire Ark below, cloud sea, distant islands in all directions, the surface far beneath | Awe, scale, "the world is vast" |
| 7 | **The Sanctum Threshold** | Stasis Sanctum entrance, just inside the heavy door, X=+40, Y=+60 | +35m | Looking back across the Sanctum Bridge toward the Celestial Ring | "I've arrived somewhere important" |
| 8 | **The Cliff Shadow** | Beneath the Aviary eastern cliff, in the Verdant Creep, X=+55, Y=-15 | +5m | Looking up at the 20m cliff face, the Aviary platform silhouetted against the sky | Smallness, being "beneath" the Ark's scale |
| 9 | **The Perimeter Perch** | The Perimeter Arch mid-span, X=+20, Y=-108 | 0m | Clouds visible through cracks beneath feet, the Southern Debris Field below | Vertigo, exhilaration |
| 10 | **The Western Edge** | West edge of the Living Quarters platform, X=-70, Y=-20 | +18m | The Western Fragment, the Collapsed Bridge, the distant Spire Island | Mystery, "I can't reach that yet" |

### 19.3 — Viewpoint Design Requirements

Each viewpoint must have:
- A flat or near-flat standing area at least 3m × 3m (room for the player to stand and rotate the camera)
- At least one direction of high visual interest (the "view target")
- Natural framing from terrain features (rock outcrops, cliff edges, archways) that direct the player's initial gaze toward the view target
- A clear "arrival" moment — the player should know they have reached somewhere special
- No immediate gameplay pressure — the player should feel they can linger

---

## 20. FUTURE EXPANSION CONNECTION POINTS

### 20.1 — Definition

Connection points are locations on the terrain where future content will physically connect to the Ark. These must be designed into the terrain now so that the connections feel organic when activated later.

### 20.2 — Connection Point Catalogue

| # | Name | Location | Type | Future Connection |
|---|------|----------|------|-------------------|
| 1 | **Collapsed Bridge Abutment** | West edge, X=-55, Y=-90, Z=+5m | Broken stone bridge extending 6m toward Western Fragment; ends in jagged fracture | Grappling hook anchor point → Western Fragment |
| 2 | **Eastern Launch Shelf** | East edge of Aviary, X=+58, Y=-5, Z=+25m | Level platform at cliff edge, 5m × 8m, with clear sightline to Eastern Fragment | Gliding launch point → Eastern Fragment |
| 3 | **Resonance Core Hatch** | Center of Celestial Ring platform, X=0, Y=+65, Z=+40m | Circular recessed hatch in the Ring floor, 3m diameter, locked | Descent point → Resonance Core dungeon |
| 4 | **Sunken Lab Deep Door** | Sunken Lab north wall, X=+68, Y=-75, Z=+3m | Blocked corridor with visible door beyond the collapse | Excavation → deeper ecological simulation levels |
| 5 | **Attic Staircase Stub** | Living Quarters north building, X=-45, Y=-10, Z=+20m | Broken staircase ascending to ceiling height; upper stairs gone | Repair → attic storage level |
| 6 | **Aviary Upper Gallery Ledge** | Aviary, X=+30, Y=+10, Z=+25m | Visible ledge and floor surface at +30m, currently only reachable via unsafe structure | Repair or grappling → upper gallery |
| 7 | **Sanctum Upper Stair** | Stasis Sanctum interior, X=+45, Y=+70, Z=+35m | Spiral staircase ascending into ceiling; upper portion collapsed | Repair → Sanctum upper maintenance level |
| 8 | **Northern Dock Abutment** | North edge beneath Celestial Ring, X=0, Y=+85, Z=+30m | Structural mounting points for a docking cradle, visible on the north face | Airship dock construction → inter-island travel hub |

### 20.3 — Connection Point Design Rules

- **Visible but inaccessible.** Each connection point must communicate its future purpose through its form — a broken bridge should look like a bridge that was broken, not a random rock formation.
- **Diegetically logical.** Each connection makes sense within the Ark's original design. The Collapsed Bridge connected to a supply depot. The Northern Dock Abutment was where larger vessels berthed. Nothing exists solely to be a future hook.
- **Non-blocking.** Connection points must not obstruct current navigation or create false paths that lead to disappointment.
- **Intriguing.** The player should think "I want to go there" — not "this is obviously DLC bait." The terrain should make the destination visible enough to be tantalizing.

---

## 21. TERRAIN CONSTRUCTION ORDER

### 21.1 — Build Phases

The terrain is constructed in 12 sequential phases. Each phase builds upon the previous. No phase can begin before the previous phase is complete and verified.

**Phase 1: Structural Slab Base**
- Build the full 190m × 220m structural platform at Z=-10m to Z=0m (the underside reference plane).
- Include the hexagonal plan shape with all lobe extensions.
- Include the Central Reinforcement Hub (thickened zone beneath the Atrium).
- Include the 8 radial reinforcement ribs on the underside.
- Verify: platform shape matches Section 2 and Section 3 dimensions.

**Phase 2: Tier 3 Summit Mass**
- Build the northern summit mass from Z=+30m to Z=+42m.
- Include the Celestial Ring circular platform at +40m (+42m at standing stones).
- Include the Stasis Sanctum plateau at +35m, separated by the 5–8m gap.
- Include the Sanctum Bridge spanning the gap.
- Include the Ring platform's subtle dome profile (0.3m rise from edge to center).
- Verify: platforms are level, elevations match Section 4.5.

**Phase 3: Tier 2 Mid-Upper Plateau**
- Build the Central Ridge, Living Quarters platform, Aviary platform, and upper Cascade terraces from Z=+15m to Z=+28m.
- Include the Courtyard depression at +17m.
- Include the Central Reservoir basin at +20m.
- Include the Central Ridge Outcrop.
- Include the Aviary eastern cliff face.
- Verify: surfaces match Section 4.4, tier transition faces are clean.

**Phase 4: Tier 1 Mid-Lower Platform**
- Build the Atrium plateau, lower Cascade terraces, and Verdant Creep upper transition from Z=+5m to Z=+12m.
- Include the Atrium circular basin at +8m.
- Include the Atrium rim at +10m to +12m.
- Include the lower Cascade terrace steps.
- Verify: Atrium basin is level, terrace steps are consistent.

**Phase 5: Tier 0 Base Platform**
- Build the Gatehouse platform, Departure Platform, and Verdant Creep basin from Z=0m to Z=+7m.
- Include the Departure Platform at 0m (level, rectangular).
- Include the Verdant Creep circular depressions (former dome foundations).
- Include the Gatehouse Pillars.
- Verify: Departure Platform is level and correctly positioned.

**Phase 6: Tier Transition Faces & Retaining Walls**
- Carve the vertical and near-vertical faces between tiers.
- Add intact retaining wall sections (vertical stone faces).
- Add collapsed wall sections (35–50° scree slopes).
- Ensure the tier breaks follow the original structural lines — they should read as engineered features, not natural erosion.
- Verify: face angles match Section 5, walkable routes between tiers exist.

**Phase 7: Water System**
- Carve the primary channel from Reservoir to Departure Platform.
- Carve the 6 distribution channels along terrace edges.
- Excavate the Central Reservoir basin (if not already in Phase 3).
- Excavate the 5 settling pool basins.
- Carve the Atrium fountain basin.
- Carve the underground drainage tunnel (Atrium to southern perimeter).
- Carve the Reservoir maintenance tunnel.
- Verify: water flow path is continuous downhill, all basins hold water, overflow lips are at correct elevations.

**Phase 8: Ravines & Cracks**
- Carve the Central Ridge Ravine through the ridge crest.
- Carve the Southern Edge Ravine near the perimeter.
- Carve the 5–8 Verdant Creep drainage ravines.
- Add structural crack patterns at the island perimeter (stress fractures).
- Verify: ravine depths match Section 7, no ravine creates an unintended shortcut or blocks a necessary path.

**Phase 9: Caves & Undercuts**
- Excavate the Sunken Lab chamber and entry depression.
- Carve the 8–12 perimeter undercuts.
- Excavate the Atrium sub-floor void and create the displaced slab opening.
- Verify: chamber dimensions match Section 12, entry points are positioned per Section 12.

**Phase 10: Floating Fragments**
- Place the Western Fragment at its fixed position relative to the Ark.
- Place the Eastern Fragment.
- Place the Southern Debris Field fragments.
- Place the underside fragments (partially detached blocks).
- Verify: fragment positions match Section 14, gaps are correct for future traversal abilities.

**Phase 11: Rock Formations & Details**
- Place the 16 Standing Stones on the Celestial Ring.
- Sculpt the Central Ridge Outcrop.
- Sculpt the Gatehouse Pillars.
- Place talus fields at retaining wall bases.
- Add exposed crystal veins at specified locations.
- Add the Perimeter Arch (carve the gap that creates it from the Southern Edge Ravine).
- Verify: all formations match Section 13 and Section 11.

**Phase 12: Edge Treatment & Surface Refinement**
- Apply edge treatments per Section 17 (soil lips, exposed edges, retaining edges, scree edges, platform edges).
- Refine walkable surface slopes (ensure all paths meet Section 16 specifications).
- Add surface detail to plateaus (subtle undulations, expansion joints, drainage patterns).
- Final verification: walk the entire island. Confirm all districts are accessible. Confirm all elevations match specifications. Confirm all views are unobstructed.

---

## 22. ASCII TOP-DOWN MAP

### 22.1 — Full Island Top-Down (1 char ≈ 5m)

```
                    N
                    │
                    ▲
                    │
        ┌───────────┴───────────┐
        │                       │
        │    ╔═══════════╗      │
        │    ║ STANDING  ║      │
        │    ║  STONES   ║   ┌──┤
        │    ║    ○16    ║   │SS│  ← Stasis Sanctum
        │    ║  ┌────┐   ║   │  │     Plateau (+35m)
        │    ║  │ RP │   ║   │  │
        │    ║  │+40m│   ║   └──┤
        │    ║  └────┘   ║      │
        │    ║ CELESTIAL ║      │
        │    ║   RING    ║      │
        │    ╚═════╤═════╝      │
        │         │RAMP         │
        │    ┌────┴────┐        │
        │    │ SWITCH  │        │
        │    │  BACK   │        │
        ├────┴─────────┴────────┤  ← Tier 2→3 retaining wall
        │                       │
        │  ┌─────────┐ ┌──────┐ │
        │  │ LIVING  │ │AVIARY│ │
        │  │QUARTERS │ │      │ │
        │  │  ┌──┐   │ │ ┌──┐ │ │
        │  │  │CY│   │ │ │AR│ │ │  CY = Courtyard
        │  │  └──┘   │ │ └──┘ │ │  AR = Aviary Arches
        │  │         │ │      │ │
        │  └─────────┘ └──┬───┘ │
        │                 │ECF  │  ECF = East Cliff Face
        ├─────────────────┴─────┤  ← Tier 1→2 retaining wall
        │                       │
        │   ┌─────────────┐     │
        │   │   ATRIUM    ├──┐  │
        │   │    ┌──┐     │CG│  │  CG = Cascade Gardens
        │   │    │GT│     │  │  │  GT = Great Table (center)
        │   │    └──┘     │  │  │  RS = Reservoir
        │   │             │RS│  │
        │   └─────┬───────┘  │  │
        │         │          │  │
        ├─────────┴──────────┴──┤
        │                       │
        │  ┌───────┐ ┌────────┐ │
        │  │ GATE  │ │VERDANT │ │
        │  │ HOUSE │ │ CREEP  │ │
        │  │  ┌──┐ │ │  ┌──┐  │ │
        │  │  │DP│ │ │  │SL│  │ │  DP = Departure Platform
        │  │  └──┘ │ │  └──┘  │ │  SL = Sunken Lab entrance
        │  └───────┘ └────────┘ │
        │                       │
        └───────────────────────┘
                    │
                    ▼
                    S

    ─── = Island perimeter edge
    ═══ = Tier 3 summit boundary
    ─── = Tier transition (retaining wall or cliff line)
    ┌┐└┘ = Building/plateau outlines
```

### 22.2 — Elevation Reference Map (same scale)

```
Symbol key:
  # = +40 to +42m (Celestial Ring)
  $ = +35 to +38m (Stasis Sanctum)
  @ = +28 to +35m (Summit approach)
  % = +20 to +28m (Aviary, Living Quarters, upper Cascade)
  & = +12 to +20m (Atrium rim, lower Living Quarters, mid Cascade)
  * = +5 to +12m (Atrium floor, lower Cascade, upper Creep)
  = = 0 to +5m (Gatehouse, Departure Platform, lower Creep)
  . = Void / sky (off-island)

            N
    ......................
    .....####$$$$.........
    ....######$$$.........
    ...########$$$........
    ..@@@######$$$........
    ..@@@@@@@..............
    ..%%@%%@@@...%%%%%%%...
    .%%%%%%%&&&%%%%%%%%%...
    .%&%%%%%&&%%%%%%%%%%...
    .&&&*****&&%%%%%%%%%...
    ..&&******&&%%&&%%%%...
    ...&&&&********&&&.....
    ....*****&&&&****&.....
    ......******&*****.....
    .......**********......
    ....====****====......
    ...=======..======....
    ..=====......=====....
    ..====........====....
    ......................
            S
```

---

## 23. ELEVATION DIAGRAM

### 23.1 — North-South Cross Section (looking west, at X=0)

```
+42m ┤                    ┌─────────┐
     │                    │ STANDING│
+40m ┤              ┌─────┤ STONE   ├─────┐
     │              │     │ (Ring)  │     │
+38m ┤              │     └─────────┘     │
     │              │                     │
+36m ┤              │   CELESTIAL RING    │
     │              │                     │
+34m ┤              │    PLATFORM         │
     │              │                     │
+32m ┤              │                     │
     │              │                     │
+30m ┤    ┌─────────┘                     │
     │    │  SWITCHBACK RAMP              │
+28m ┤    │                               │
     │    │                               │
+26m ┤    │                               │
     │    │                               │
+24m ┤    │           CENTRAL RIDGE       │
     │    │         ═══════════════       │
+22m ┤    │    ┌─────────────┐            │
     │    │    │  RESERVOIR  │            │
+20m ┤    │    └─────┬───────┘            │
     │    │          │                    │
+18m ┤    │    ┌─────┴──── CASCADE ───┐   │
     │    │    │       TERRACES       │   │
+16m ┤    │    │                      │   │
     │    │    │                      │   │
+14m ┤    │    │                      │   │
     │    │    └──────────────────────┘   │
+12m ┤    │                               │
     │    │           ATRIUM RIM          │
+10m ┤    │    ┌──────────────────┐       │
     │    │    │                  │       │
 +8m ┤    │    │  ATRIUM FLOOR    │       │
     │    │    │  (Player Awakens) │       │
 +6m ┤    │    └────────┬─────────┘       │
     │    │             │                  │
 +4m ┤    │      GATEHOUSE APPROACH       │
     │    │                                │
 +2m ┤    │                                │
     │    │                                │
  0m ┤    └──── DEPARTURE PLATFORM ────────┘
     │
     │  ═══════════ CLOUD LAYER ═══════════
     │
     │        (surface thousands of feet below)
     │
     └──────────────────────────────────────────
       Y=-120  -100   -80   -60   -40   -20    0    +20   +40   +60   +80
       (S)                                                              (N)
```

### 23.2 — East-West Cross Section (looking north, at Y=-30, through the Central Ridge)

```
     W                                                       E
     │                                                       │
+28m ┤                             ┌─────────┐
     │                             │ CENTRAL │
+26m ┤                             │ RIDGE   │
     │                             │ OUTCRP  │
+24m ┤                       ┌─────┤         ├─────┐
     │                       │     └─────────┘     │
+22m ┤     LIVING            │                     ├──────┐
     │     QUARTERS          │    RIDGE CREST      │AVIARY│
+20m ┤  ┌── courtyard ──┐    │                     │PLATF.│
     │  │                │    │                     │      │
+18m ┤  │                │    │                     │      │
     │  │                │    │                     │      │
+16m ┤  │                │    │    RIDGE RAVINE     │      │
     │  │                │    │    (cut through)    │      │
+14m ┤  │                │    │                     │      │
     │  │                │    │                     │      │
+12m ┤  └────────────────┘    └─────────────────────┘      │
     │                                                     │
+10m ┤                                                     │
     │            ATRIUM LEVEL                             │
 +8m ┤        (south of this section)                      │
     │
     └──────────────────────────────────────────────────────────
      X=-70  -50    -30    -10    0    +10   +30   +50   +70
```

---

## 24. MODULAR TERRAIN PIECES

### 24.1 — Modular System Overview

The Ark's terrain is built from a set of reusable modular pieces. This approach ensures:
- Consistency across the island
- Efficient iteration (modify one piece, rebuild affected areas)
- The engineered-platform aesthetic (repeating structural elements)
- Future island construction using the same kit

### 24.2 — Terrain Kit Catalogue

#### Structural Platform Pieces (Layer 1 — the slab)

| Piece ID | Name | Dimensions | Description | Quantity |
|----------|------|------------|-------------|----------|
| SP-01 | Platform Slab — Standard | 20m × 20m × 8m | Flat structural slab section, top and bottom faces parallel | 12 |
| SP-02 | Platform Slab — Perimeter Straight | 20m × 10m × 8m | Slab section with one perimeter edge (vertical face) | 18 |
| SP-03 | Platform Slab — Perimeter Curved | 20m × 15m × 8m | Slab section with curved perimeter edge (convex) | 8 |
| SP-04 | Platform Slab — Perimeter Curved Inner | 20m × 15m × 8m | Slab section with curved perimeter edge (concave, for lobe indentations) | 4 |
| SP-05 | Platform Slab — Corner Hex | 15m × 15m × 8m | Hexagonal corner piece, two perimeter edges at 120° | 6 |
| SP-06 | Central Hub — Reinforced | 40m diameter × 12m | Thickened circular hub section for the underside center | 1 |
| SP-07 | Radial Rib — Straight | 30m × 3m × 2m (below slab) | Underside reinforcement rib, mounts to slab underside | 8 |
| SP-08 | Radial Rib — Tapered End | 10m × 3m->1m × 2m->0.5m | Tapering end of a reinforcement rib at the perimeter | 8 |

#### Retaining Wall & Cliff Pieces (Tier Transitions)

| Piece ID | Name | Dimensions | Description | Quantity |
|----------|------|------------|-------------|----------|
| RW-01 | Retaining Wall — Intact | 10m × 2m × 8m | Vertical stone retaining wall section, clean face | 12 |
| RW-02 | Retaining Wall — Intact w/ Drain | 10m × 2m × 8m | Retaining wall with drainage channel cut into face | 4 |
| RW-03 | Retaining Wall — Partially Collapsed | 10m × 3m × 6m | Wall section with upper portion broken, creating a lower ramp | 10 |
| RW-04 | Retaining Wall — Fully Collapsed | 10m × 5m × 8m | Scree slope at 35–45°, stone blocks and gravel | 12 |
| RW-05 | Retaining Wall — Staircase Remnant | 10m × 4m × 8m | Collapsed wall with intact stair remnants forming a navigable ramp | 4 |
| RW-06 | Cliff Face — Vertical | 10m × 2m × 12m | Clean vertical cliff for tier transitions and perimeter | 10 |
| RW-07 | Cliff Face — With Crystal Vein | 10m × 3m × 12m | Cliff face with exposed crystal vein (for key locations) | 5 |

#### Plateau & Level Surface Pieces

| Piece ID | Name | Dimensions | Description | Quantity |
|----------|------|------------|-------------|----------|
| PL-01 | Level Platform — Large | 20m × 20m × 0.5m | Flat engineered surface, stone texture, expansion joints | 8 |
| PL-02 | Level Platform — Medium | 10m × 10m × 0.5m | Medium flat surface | 12 |
| PL-03 | Level Platform — Circular | 45m diameter × 0.5m | The Celestial Ring platform, with subtle dome and calibration grooves | 1 |
| PL-04 | Level Platform — With Depression | 15m × 15m × 0.5m | Platform with circular depression (for basins, courtyards) | 6 |
| PL-05 | Platform Edge — Clean | 10m × 2m × 0.5m | Clean edge piece where platform meets drop | 10 |
| PL-06 | Platform Ramp — Broad | 15m × 8m × 4m rise | Engineered ramp, 10–15° slope, 4–5m wide | 4 |
| PL-07 | Platform Ramp — Switchback | 10m × 10m × 6m rise | 180° switchback ramp section | 1 |

#### Water System Pieces

| Piece ID | Name | Dimensions | Description | Quantity |
|----------|------|------------|-------------|----------|
| WS-01 | Channel — Primary | 10m × 1.2m × 0.6m | Stone-lined rectangular channel | 12 |
| WS-02 | Channel — Distribution | 10m × 0.5m × 0.3m | Smaller distribution channel | 8 |
| WS-03 | Reservoir Basin — Large | 15m × 10m × 2m | Rectangular excavated basin, stone-lined | 1 |
| WS-04 | Settling Pool — Circular | 5m diameter × 1m | Circular stone basin | 3 |
| WS-05 | Settling Pool — Rectangular | 5m × 3m × 1m | Rectangular stone basin | 2 |
| WS-06 | Fountain Basin | 4m diameter × 0.5m | Circular decorative basin | 1 |
| WS-07 | Waterfall Lip — Engineered | 3m × 1m × 0.5m | Stone overflow lip for reservoir and terrace transitions | 6 |
| WS-08 | Underground Pipe Section | 5m × 0.5m diameter | Buried stone drainage pipe | 6 |

#### Erosion & Detail Pieces

| Piece ID | Name | Dimensions | Description | Quantity |
|----------|------|------------|-------------|----------|
| ER-01 | Ravine — V-Shaped | 10m × 4m × 4m | V-shaped erosion ravine for structural cracks | 6 |
| ER-02 | Ravine — Narrow | 10m × 2m × 2m | Narrower ravine section | 8 |
| ER-03 | Talus Field — Base | 10m × 5m × 2m | Accumulated rock debris at wall base | 8 |
| ER-04 | Talus Field — Sparse | 10m × 3m × 1m | Scattered smaller debris | 6 |
| ER-05 | Perimeter Undercut — Shallow | 5m × 3m × 2m | Eroded undercut at island edge | 8 |
| ER-06 | Perimeter Undercut — Deep | 5m × 3m × 3m | Deeper undercut (key locations) | 4 |
| ER-07 | Soil Accumulation — Thick | 10m × 10m × 2m | Deep soil cap for basin areas | 8 |
| ER-08 | Soil Accumulation — Thin | 10m × 10m × 0.5m | Shallow soil cap for plateau edges | 6 |
| ER-09 | Exposed Rock Outcrop | 8m × 4m × 1.5m | Wind-scoured rock exposure | 4 |
| ER-10 | Crack Pattern — Surface | 5m × 3m × 0.3m | Surface stress fracture pattern | 10 |

#### Rock Formation Pieces

| Piece ID | Name | Dimensions | Description | Quantity |
|----------|------|------------|-------------|----------|
| RF-01 | Standing Stone — Monolith | 1m × 0.5m × 2m | Single standing stone for Celestial Ring | 16 |
| RF-02 | Pillar — Eroded | 2m diameter × 4m | Eroded structural pillar (Gatehouse) | 2 |
| RF-03 | Natural Arch — Stone | 6m × 4m × 3m | Eroded arch through structural stone | 2 |
| RF-04 | Crystal Vein — Exposed | 3m × 0.5m × 0.3m | Exposed crystal vein insert for cliff faces | 6 |

#### Floating Fragment Pieces

| Piece ID | Name | Dimensions | Description | Quantity |
|----------|------|------------|-------------|----------|
| FF-01 | Fragment — Large | 20m × 12m × 6m | Major detached fragment (Western Fragment) | 1 |
| FF-02 | Fragment — Medium | 15m × 10m × 5m | Medium detached fragment (Eastern Fragment) | 1 |
| FF-03 | Fragment — Small Irregular | 5m × 3m × 2m | Small debris fragment | 10 |
| FF-04 | Fragment — Tiny | 2m × 1m × 1m | Very small debris | 15 |
| FF-05 | Underside Detached Block | 5m × 4m × 3m | Partially detached underside block | 15 |
| FF-06 | Underside Hanging Block | 5m × 3m × 2m | Block hanging by thin remaining connection | 10 |
| FF-07 | Bridge Stub — Broken | 8m × 4m × 3m | Remnant of collapsed bridge extending from edge | 1 |

### 24.3 — Total Piece Count Summary

| Category | Unique Pieces | Total Instances |
|----------|---------------|-----------------|
| Structural Platform | 8 | 59 |
| Retaining Walls & Cliffs | 7 | 53 |
| Plateaus & Level Surfaces | 7 | 42 |
| Water System | 8 | 39 |
| Erosion & Detail | 10 | 68 |
| Rock Formations | 4 | 22 |
| Floating Fragments | 7 | 53 |
| **TOTAL** | **51** | **336** |

### 24.4 — Assembly Notes

- All pieces snap to a 5m grid aligned to the island origin (Atrium center).
- Elevation references use the structural slab underside as Z=0.
- Tier retaining walls and cliff pieces are placed along the tier transition lines defined in Section 4.
- Water system pieces are placed along the channel paths defined in Section 7 and Section 9.
- Erosion pieces are applied last — they blend seams between structural pieces and add the 5,000-year weathering character.
- Floating fragments are positioned in world space relative to the island origin, not snapped to the grid.

---

*End of Topographical Blueprint. Build the terrain in Phases 1–12. Use the modular kit. Verify at every phase. The Ark of Genesis should be recognizable from this document alone.*

*Signed,*

*ArchBishop*
*Lead Terrain Architect, Aperture*
*2026-07-08*
