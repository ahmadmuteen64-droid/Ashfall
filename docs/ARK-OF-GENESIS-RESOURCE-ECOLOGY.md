# The Ark of Genesis — Resource Ecology Design Document

*Complete ecological and resource network specification. Every material, its origin, its ecosystem, its relationships, and its role in player progression. Environment artists, gameplay programmers, and economy designers execute from this document independently.*

**Classification:** AAA Studio Internal — Systems Design Directorate
**Version:** 1.0
**Date:** 2026-07-08
**Authors:** ArchBishop (Lead Gameplay Systems Designer, Ecologist, Resource Economy Designer, Survival Systems Director, Environmental Simulation Architect), by order of Lord Commander Ahmad

**Parent Documents:**
- [[VISION]]
- [[WORLD-BIBLE]]
- [[GAMEPLAY-ARCHITECTURE]]
- [[ARK-OF-GENESIS-ISLAND-BLUEPRINT]]
- [[ARK-OF-GENESIS-TOPOGRAPHY]]
- [[ARK-OF-GENESIS-TRAVERSAL-BLUEPRINT]]
- [[ARK-OF-GENESIS-DISTRICT-DESIGN]]
- [[WORLD-SIMULATION-DESIGN]]

**What this document IS:** The definitive specification of every resource on the Ark of Genesis — what it is, why it is here, how it formed, where it is found, how it relates to other resources, and what the player learns from discovering it.

**What this document IS NOT:** Code. Asset lists. A redesign of existing documents. This builds upon the Island Blueprint and District Design. It does not alter them.

---

## TABLE OF CONTENTS

1. [Resource Philosophy](#1-resource-philosophy)
2. [The Ark as an Ecosystem](#2-the-ark-as-an-ecosystem)
3. [Resource Categories Overview](#3-resource-categories-overview)
4. [Geological Resources](#4-geological-resources)
5. [Botanical Resources](#5-botanical-resources)
6. [Animal & Insect Resources](#6-animal--insect-resources)
7. [Decomposition Resources](#7-decomposition-resources)
8. [Water Resources](#8-water-resources)
9. [Resonance Resources](#9-resonance-resources)
10. [Ancient Components & Artifacts](#10-ancient-components--artifacts)
11. [Resource Ecology — The Living Web](#11-resource-ecology--the-living-web)
12. [Resource Chains — Natural Progression](#12-resource-chains--natural-progression)
13. [Player Discovery Systems](#13-player-discovery-systems)
14. [Scientific Discovery Per Resource](#14-scientific-discovery-per-resource)
15. [Rarity Design](#15-rarity-design)
16. [World Evolution — Resources Over Time](#16-world-evolution--resources-over-time)
17. [Design Verification Matrix](#17-design-verification-matrix)

---

## 1. RESOURCE PHILOSOPHY

### 1.1 — The Prime Directive

**Resources are not collectibles. Resources are physical manifestations of natural systems.**

Every material the player can gather, harvest, extract, or discover on the Ark exists because of a chain of causality: geological processes formed the stone, ecological processes distributed the plants, historical processes placed the artifacts. Nothing sparkles. Nothing exists "because the player needs it." Every resource answers five questions:

| Question | What It Validates |
|----------|-------------------|
| **Why is it here?** | Causal authenticity — the resource's presence follows from natural or historical processes |
| **How was it formed?** | Geological/biological/physical origin — the resource has a creation story |
| **What ecosystem supports it?** | Ecological context — the resource exists within a web of relationships |
| **Who used it historically?** | Historical context — the Golden Age researchers had reasons to value or cultivate this resource |
| **Why hasn't it disappeared?** | Persistence logic — the resource is sustained by ongoing processes or protected by conditions |

### 1.2 — Knowledge Over Quantity

The game's core thesis applies to resources as much as to any other system. The player who understands *why* clay deposits form at settling pool edges can find clay anywhere on the Ark where similar conditions exist. The player who has merely memorized "clay is at the Cascade Gardens settling pools" can only gather clay from that one location.

**Understanding a resource means:**
- Knowing what geological or ecological conditions produce it.
- Being able to predict where else it might be found.
- Understanding how it relates to other resources in its ecosystem.
- Knowing how to harvest it sustainably (if renewable) or efficiently (if finite).
- Understanding its properties well enough to use it in novel ways.

**Memorizing a resource location means:**
- Knowing one place to get it.
- Being unable to adapt if that location is depleted, changed, or inaccessible.
- Missing the deeper knowledge that enables creative applications.

### 1.3 — The Anti-Design Principles

Resources in the Ark of Genesis must NEVER:

| Anti-Principle | Why It Is Rejected |
|----------------|-------------------|
| **Sparkle/glow to mark collectibles** | Undermines observation-based discovery. The player should notice resources because they look like what they are, not because a UI effect announces them. |
| **Random scatter placement** | Destroys ecological logic. If a medicinal herb can grow anywhere, the player learns nothing about why it grows where it grows. |
| **Arbitrary rarity tiers (Common/Rare/Epic/Legendary)** | Replaces geological logic with game-logic. Rarity must follow from natural scarcity — limited formation conditions, slow growth rates, specific environmental requirements. |
| **Identical resources in every district** | Ignores ecological diversity. Different elevations, moisture levels, and light conditions support different species. |
| **Static resource placement** | Denies the world's aliveness. Forests grow. Trees die. Animals move. Resources should change over time — slowly, subtly, but perceptibly. |
| **Resources as "rewards" for reaching a location** | Inverts the relationship. The resource is there because of ecological reasons. The player finds it because they understood those reasons and looked in the right place. The discovery is its own reward. |

### 1.4 — The Player's Relationship to Resources

The player is not a harvester clearing a map of icons. The player is an **observer becoming an ecologist**. Their relationship to resources evolves through stages:

| Stage | Player Behavior | What the Player Understands |
|-------|----------------|---------------------------|
| **Stage 1: Encounter** | Notices an interesting plant/stone/substance. Examines it. Journal records it. | "This exists. It has properties I can observe." |
| **Stage 2: Collection** | Gathers the resource. Notes where it was found. May use it immediately for basic needs. | "I can take this. I can use it for simple things." |
| **Stage 3: Pattern Recognition** | Notices that the resource consistently appears in specific conditions (near water, on certain stone, at certain elevations). | "This grows where conditions suit it. I can predict where to find it." |
| **Stage 4: Cultivation/Management** | For renewable resources: plants seeds, manages growth conditions. For finite resources: extracts efficiently, conserves strategically. | "I can encourage this to grow. I can ensure it persists." |
| **Stage 5: Application** | Uses the resource in sophisticated ways — not just crafting known items, but creating novel applications based on understood properties. | "I understand this material deeply enough to use it in ways no recipe book describes." |

### 1.5 — Resource Documentation Format

Every resource in this document follows a standardized specification. Fields marked with `[O]` are directly observable by the player without tools. Fields marked with `[K]` require knowledge progression (the player understands more as their Codex grows).

| Field | Audience | Purpose |
|-------|----------|---------|
| Name | All | Contemporary identifier — what the player calls it after identification |
| Category | Systems Design | The resource group it belongs to |
| Description [O] | Environment Art, Narrative | What the player sees when they first encounter it |
| Natural Origin [K] | Systems Design, Narrative | The geological or biological processes that created it |
| Historical Origin [K] | Narrative, Level Design | How Golden Age researchers used or valued this resource |
| Primary Districts | Level Design | Where the resource is most abundant |
| Secondary Districts | Level Design | Where the resource can be found in smaller quantities |
| Spawn Logic | Systems Design, Level Design | The ecological or geological rules governing placement |
| Visual Characteristics [O] | Environment Art | Color, texture, shape, distinguishing features |
| Scarcity | Economy Design | How abundant or limited the resource is, with ecological justification |
| Renewability | Systems Design | Whether and how the resource regenerates |
| Environmental Requirements | Systems Design | Conditions necessary for the resource to exist or thrive |
| Companion Resources | Systems Design | Other resources typically found nearby (ecological associations) |
| Common Player Mistakes | Tutorial Design | What players typically misunderstand about this resource |
| Codex Discoveries Enabled [K] | Narrative, Systems Design | Knowledge entries unlocked through studying this resource |
| Future Technologies Enabled [K] | Systems Design | What mid-to-late-game capabilities this resource contributes to |

---

## 2. THE ARK AS AN ECOSYSTEM

### 2.1 — The Island Is Not a Map

The Ark of Genesis is a **closed-system floating platform** approximately 220m × 190m, elevated 2,000–3,000 feet above the planetary surface. It has been biologically isolated for 5,000 years. Every resource on the island exists within a self-contained ecosystem that has no external inputs except:

- **Sunlight** — the primary energy source.
- **Rain** — captured by the island's surface and distributed by the original water management system.
- **Wind** — carrying dust, spores, seeds, and occasional insects from the surface or from other floating islands.
- **Resonance decay** — the slow release of stored kinetic energy from the island's crystal arrays, producing subtle thermal and electromagnetic effects.

Everything else — soil, plants, animals, fungi, water — cycles within the closed system. The Ark is a terrarium at monumental scale.

### 2.2 — The Three Ecological Zones

The Ark's 42-meter elevation gradient creates three distinct ecological zones. These are not hard boundaries but gradual transitions, with species ranges overlapping at the interfaces.

| Zone | Elevation | Districts | Character |
|------|-----------|-----------|-----------|
| **The Basin** | 0m to +12m | Gatehouse, Atrium, lower Cascade, lower Verdant Creep | Sheltered, warm, highest moisture accumulation, deepest soils, lowest wind exposure |
| **The Slope** | +12m to +28m | Living Quarters, Aviary, upper Cascade, upper Verdant Creep | Moderate exposure, well-drained soils, diverse microclimates, transitional vegetation |
| **The Summit** | +28m to +42m | Celestial Ring, Stasis Sanctum | Maximum exposure, thin or absent soil, intense wind, extreme temperature variation, specialized species only |

### 2.3 — The Five Ecosystem Drivers

Five physical and biological processes shape resource distribution across all three zones:

| Driver | Effect on Resources |
|--------|-------------------|
| **Hydrology** | The water management system (reservoir → channels → terraces → settling pools → cistern → fountain) determines where moisture-loving species can survive and where clay and mineral deposits accumulate. |
| **Succession** | 5,000 years of ecological succession has transformed managed gardens into wild ecosystems. Pioneer species have given way to climax communities. The current vegetation is not the original planting — it is what those plantings became. |
| **Decomposition** | The continuous cycle of growth, death, and decay has created the island's soil. Every fallen leaf, every dead tree, every animal carcass has contributed to the organic matter that now supports the island's fertility. |
| **Resonance Influence** | The island's crystal arrays produce subtle but persistent effects: faint thermal gradients near array housings, electromagnetic fields that some organisms have evolved sensitivity to, and the slow release of stored energy that creates micro-warmth in otherwise cold stone. |
| **Isolation** | 5,000 years of biological isolation has produced unique adaptations. Some Ark species are found nowhere else. Their properties — medicinal, nutritional, material — may differ from their surface-world relatives in ways the player can discover. |

### 2.4 — The Soil Story

The Ark's soil is not native. The island was built from stone — there was no soil when construction completed. Every gram of soil on the Ark today was created on the island through:

1. **Wind deposition** — dust carried from the surface and from other floating islands, accumulating in sheltered areas over millennia.
2. **Organic accumulation** — 5,000 years of plant growth and decay, building soil from the top down as leaf litter decomposed.
3. **Mineral weathering** — the slow breakdown of the island's structural stone through freeze-thaw cycles, root penetration, and chemical weathering by slightly acidic rainwater.
4. **Deliberate soil creation** — the original researchers imported soil and compost to establish the Cascade Gardens and Aviary. That original soil has been supplemented by 5,000 years of natural processes.

Soil depth varies dramatically:
- **Basin zone:** 0.5m to 3m (accumulated in sheltered depressions, original garden beds, and structural basins).
- **Slope zone:** 0.1m to 1m (thinner on exposed slopes, deeper in terraces and behind retaining walls).
- **Summit zone:** 0m to 0.1m (essentially absent except in cracks and sheltered corners).

The player who digs in different locations will find different soil profiles — layers of organic matter, mineral sediment, and (at depth) the original structural stone. The soil itself tells the island's history.

---

## 3. RESOURCE CATEGORIES OVERVIEW

### 3.1 — Category Index

Resources are organized into 17 categories, grouped by origin type.

**GEOLOGICAL — formed by physical processes acting on stone and mineral:**
1. Stone
2. Minerals
3. Metals
4. Clay
5. Sand

**BOTANICAL — produced by plants:**
6. Wood
7. Plants (General)
8. Medicinal Plants
9. Fibers

**ZOOLOGICAL — produced by or derived from animals:**
10. Animal Products

**DECOMPOSITION — produced by the breakdown of organic matter:**
11. Organic Matter

**AQUATIC — water in various forms:**
12. Water

**RESONANCE — materials with resonance-active properties:**
13. Crystals

**ARCHAEOLOGICAL — artifacts and remnants of the Golden Age:**
14. Ancient Components
15. Scientific Artifacts
16. Forgotten Technology

**FRONTIER — materials not yet fully understood:**
17. Unknown Materials

### 3.2 — Resource Distribution Map (Ecological Logic)

```
SUMMIT ZONE (+28m to +42m)
  PRIMARY: Crystals (large, high-quality), Ancient Components (instruments), Metals (instrument fittings)
  SECONDARY: Sand (wind-deposited), Resonance Moss, Forgotten Technology (communication array)
  ABSENT: Soil, Clay, Wood, most Plants, Animal Products (except wind-deposited insects)
  LOGIC: Maximum exposure. Thin soil. Intense wind. Only specialized materials survive here.
         Historical: observation equipment left in place.

SLOPE ZONE (+12m to +28m)
  PRIMARY: Wood (Courtyard Tree, specimen trees), Plants/Flowers (highest diversity), Medicinal Plants (cultivated beds),
           Fibers (vine-covered arches), Animal Products (birds, pollinators), Organic Matter (leaf litter, humus)
  SECONDARY: Stone (retaining walls, exposed structural stone), Crystals (small, near Living Quarters resonance chest),
             Water (rooftop cisterns), Ancient Components (Propagation Station, Aviary instruments)
  LOGIC: Moderate conditions. Deepest cultivated soils. Highest biodiversity. The Ark's fertile heart.
         Historical: living quarters, botanical collection, working gardens.

BASIN ZONE (0m to +12m)
  PRIMARY: Water (reservoir, channels, pools, fountain), Clay (settling pool edges), Organic Matter (compost, humus),
           Fungi (decomposition zones), Stone (crumbled retaining walls, structural stone)
  SECONDARY: Plants (moisture-loving species), Medicinal Plants (lower Cascade terraces), Insects (highest diversity in Creep),
             Crystals (small fragments, dome shards in Atrium), Ancient Components (Gatehouse cargo equipment)
  LOGIC: Sheltered, wet, deepest soil accumulation. Water and gravity concentrate materials here.
         Historical: arrival terminal, central gathering, water management, ecological simulation.
```

---

## 4. GEOLOGICAL RESOURCES

### 4.1 — STONE

#### Building Stone (Structural)

| Field | Value |
|-------|-------|
| **Name** | Building Stone (Resonance-Stabilized Composite) |
| **Category** | Stone |
| **Description [O]** | Warm grey stone with barely visible crystalline inclusions. Smooth where finished, rough where weathered. Forms the walls, floors, pillars, and retaining structures throughout the Ark. |
| **Natural Origin [K]** | NOT natural. This is an engineered material — a composite of natural stone aggregate bonded with resonance-stabilized matrices. The First Delvers developed this material specifically for floating platform construction. It is lighter than natural stone (approximately 70% of expected density), stronger in compression, and resistant to weathering. The crystalline inclusions are microscopic resonance crystals that provide structural reinforcement at the molecular level. |
| **Historical Origin [K]** | Manufactured in the Resonance Foundries (the industrial islands of the Golden Age). Transported to the Ark during construction and shaped on-site. Every stone block in the Ark was precision-cut to fit its specific location — there are no generic blocks. |
| **Primary Districts** | Every district. The entire island is built from this material. |
| **Secondary Districts** | Exposed and accessible where: retaining walls have crumbled (Cascade Gardens, Verdant Creep), structural cracks have opened (Living Quarters root zones, Atrium floor), cliff faces are exposed (island edges). |
| **Spawn Logic** | Building stone is the substrate of the entire island. It is accessible wherever: (a) erosion has exposed the structural layer beneath accumulated soil, (b) walls have crumbled producing loose blocks, (c) root growth has cracked and displaced floor sections. |
| **Visual Characteristics [O]** | Warm grey-beige base color (#B8B0A8 to #C4BCB0 depending on finish). Smooth-finished interior surfaces have a subtle sheen. Weathered exterior surfaces are rougher, pitted, with visible crystalline flecks that catch light. Fractured edges reveal the composite structure — aggregate particles in a finer matrix. |
| **Scarcity** | **Structurally abundant; access-limited.** The stone is everywhere but extracting it in usable pieces requires finding locations where natural processes have already broken it into manageable blocks. The player cannot mine the structural walls (they are load-bearing). They collect what erosion and time have already loosened. |
| **Renewability** | **Non-renewable in practice.** The stone was manufactured 5,000+ years ago. No new building stone can be created on the Ark. However, the quantity available as loose/weathered blocks far exceeds what any single player could use. |
| **Environmental Requirements** | Exposure to weathering (freeze-thaw cycles, root penetration, wind erosion) to break the structural stone into collectible pieces. |
| **Companion Resources** | Crystal fragments (small) — where structural stone has crumbled, resonance crystals from the underlying infrastructure are sometimes exposed. Moss and lichens on weathered surfaces. |
| **Common Player Mistakes** | Attempting to mine intact walls (the game prevents this — the stone is too hard, the walls are structural). Not recognizing that different finishes indicate different original functions (smooth = interior, rough = exterior, dressed = Gatehouse working surfaces). |
| **Codex Discoveries Enabled** | "First Delver Architecture," "Resonance-Stabilized Materials," "Structural Engineering of Floating Platforms" |
| **Future Technologies Enabled** | Advanced construction (player buildings using salvaged stone), Stone tool crafting (chisels, grinding surfaces, structural blocks for player-built infrastructure) |

#### Weathered Stone (Eroded)

| Field | Value |
|-------|-------|
| **Name** | Weathered Stone |
| **Category** | Stone |
| **Description [O]** | Crumbled, fractured, and worn stone fragments ranging from gravel-sized chips to head-sized blocks. Found at the base of retaining walls, in scree slopes, and where structural cracks have exposed the island's interior layers. |
| **Natural Origin [K]** | Produced by 5,000 years of physical weathering: freeze-thaw cycles fracturing exposed stone, root penetration widening structural cracks, wind abrasion wearing surfaces, and the gradual chemical weathering of the composite matrix by slightly acidic rainwater. |
| **Historical Origin [K]** | These fragments were once part of the Ark's structural elements — walls, floors, retaining structures. Their current state is the result of 5,000 years of entropy operating on engineered materials. |
| **Primary Districts** | Cascade Gardens (crumbled retaining walls), Verdant Creep (exposed structural stone), Gatehouse (wind-eroded surfaces near open doors) |
| **Secondary Districts** | Living Quarters (root-damaged floor sections), Atrium (exposed cracks in the floor) |
| **Spawn Logic** | Concentrated wherever structural stone is exposed to weathering: at the base of vertical surfaces (talus accumulation), along the island's edges (edge spalling), and where roots have cracked floor sections. |
| **Visual Characteristics [O]** | Variable — from angular freshly-fractured pieces (grey, sharp edges) to rounded weathered pieces (lighter grey-beige, smooth surfaces, visible crystalline inclusions). Fractured surfaces reveal the composite structure. |
| **Scarcity** | **Common.** Weathering is an ongoing process — new fragments are continuously produced (slowly) as the island ages. |
| **Renewability** | **Very slowly renewable.** Ongoing weathering produces new fragments, but on a timescale of years to decades. For practical gameplay purposes: abundant initial supply, very slow regeneration. |
| **Environmental Requirements** | Exposure to weathering processes. Concentrated where water, wind, and temperature variation act on exposed stone. |
| **Companion Resources** | Crystal fragments (small) — where structural stone fractures, embedded resonance crystals sometimes become accessible. Sand/grit — the finest weathering product. Moss and lichens — colonizing weathered surfaces. |
| **Common Player Mistakes** | Overlooking weathered stone as "just rubble." Not recognizing that different stone pieces have different properties (size, shape, surface finish) suitable for different uses. |
| **Codex Discoveries Enabled** | "Geological Weathering," "Freeze-Thaw Cycles," "The Island's Structural Anatomy" |
| **Future Technologies Enabled** | Basic tool crafting (hammer stones, grinding stones, anvils), Construction (foundations, walls, paths), Sculpting/carving (decorative or functional stonework) |

---

### 4.2 — MINERALS

#### Clay

| Field | Value |
|-------|-------|
| **Name** | Clay |
| **Category** | Minerals |
| **Description [O]** | Smooth, fine-grained, grey-brown to reddish-brown material. When wet: plastic, moldable, slightly sticky. When dry: hard, cracks in geometric patterns. Found at the edges of still water and in areas where water once pooled. |
| **Natural Origin [K]** | Clay is the finest product of stone weathering. Over 5,000 years, slightly acidic rainwater has chemically weathered the Ark's structural stone, breaking down its composite matrix. The finest particles (clay-size, <0.002mm) are carried by water and deposited where water velocity drops to zero — the edges of settling pools, the bottoms of dried pools, and the slow-water zones of the irrigation channels. |
| **Historical Origin [K]** | The Golden Age researchers used clay for: ceramic containers (seed storage jars in the Germination Station and Aviary), waterproof sealants (irrigation channel linings), and experimental growing media (clay-soil mixtures for specific crop varieties). The clay deposits the player finds have been accumulating since the Ark's construction — some may contain layers corresponding to different historical periods. |
| **Primary Districts** | Cascade Gardens (settling pool edges — highest quality, thickest deposits), lower Verdant Creep (dried pool beds, slow-drainage areas) |
| **Secondary Districts** | Atrium (fountain basin edges — thin deposits), Gatehouse (depressions where rainwater pools — low quality, contaminated with wind-deposited grit) |
| **Spawn Logic** | Clay deposits form where: (a) water carrying suspended fine particles slows to near-zero velocity, (b) the particles settle out, (c) the water subsequently evaporates or drains leaving the clay behind. The thickest deposits are at settling pool edges in the Cascade Gardens. Secondary deposits exist wherever water has pooled repeatedly over centuries — structural depressions, blocked drainage channels, the fountain basin. |
| **Visual Characteristics [O]** | Wet clay: dark grey-brown (#6B5A4A), smooth, shiny when wet, cracks as it dries forming geometric polygons. Dry clay: lighter grey-brown (#8A7A6A), hard, fractured. The settling pool deposits show visible layering — darker bands (higher organic content, wetter periods) alternating with lighter bands (higher mineral content, drier periods). |
| **Scarcity** | **Uncommon but renewable.** Clay is continuously produced by ongoing weathering. However, the production rate is very slow (millimeters per century). The existing deposits represent 5,000 years of accumulation. A player who exhausts a deposit will not see it replenish within their gameplay timeframe. |
| **Renewability** | **Technically renewable; practically finite.** New clay is continuously produced by weathering, but at a rate far slower than player extraction. The existing deposits are a 5,000-year inheritance. |
| **Environmental Requirements** | Requires: (a) ongoing stone weathering to produce clay particles, (b) water flow to transport particles, (c) still water zones for deposition. All three conditions exist in the Cascade Gardens water management system. |
| **Companion Resources** | Fresh water (clay deposits indicate current or former water presence), Aquatic plants (growing at pool edges), Medicinal herbs (moisture-loving species in the same damp zones), Rich soil (organic-clay mixtures at the transition between pool edge and dry land) |
| **Common Player Mistakes** | Harvesting clay from the top layer only (the best clay is often deeper in the deposit, where older layers have had more time to mature). Not recognizing that different clay colors indicate different mineral compositions (redder = higher iron content, greyer = higher organic content). Using wet clay for construction without proper drying/firing. |
| **Codex Discoveries Enabled** | "Clay Formation," "Sedimentation Processes," "Ceramic Materials," "Soil Composition" |
| **Future Technologies Enabled** | Pottery (containers, storage jars, seed banks), Kiln construction (requires clay for kiln lining), Waterproofing (clay seals for channels and structures), Writing tablets (clay as recording medium), Ceramic tools, Brick-making |

#### Sand / Grit

| Field | Value |
|-------|-------|
| **Name** | Sand / Grit |
| **Category** | Minerals |
| **Description [O]** | Fine granular material ranging from barely-visible particles (fine sand) to small visible grains (coarse sand/grit). Pale grey-beige, uniform color. Found in wind-sheltered corners, depressions, and at the base of weathered stone surfaces. |
| **Natural Origin [K]** | Sand is the intermediate product of stone weathering — particles smaller than gravel but larger than clay (0.05mm to 2mm). On the Ark, sand is produced primarily by wind abrasion (wind carrying harder particles scours the structural stone) and freeze-thaw fracturing (thermal expansion and contraction breaking off small grains). |
| **Historical Origin [K]** | The Golden Age researchers used sand/grit for: abrasive cleaning (equipment maintenance), construction aggregate (mixed with binding agents for repair mortar), and filtration media (in the water treatment system's settling pools — sand layers that filtered particulates from irrigation water). |
| **Primary Districts** | Gatehouse (wind-deposited near the open doors — constant wind through the portal deposits sand in sheltered corners), Celestial Ring (wind erosion of the exposed platform surface produces sand continuously) |
| **Secondary Districts** | Cascade Gardens (in the settling pools as part of the filtration layers), Verdant Creep (where structural stone is exposed to wind and root action) |
| **Spawn Logic** | Sand accumulates where: (a) wind velocity drops (sheltered corners, behind walls, in structural depressions), (b) stone surfaces are exposed to ongoing wind abrasion (producing new sand), (c) water has deposited and sorted particles by size (settling pool filtration layers). |
| **Visual Characteristics [O]** | Pale grey-beige (#C8C4BC to #D0CCC4), uniform color (all derived from the same structural stone), grains are angular (wind-abraded) rather than rounded (water-abraded). The Gatehouse deposits are mixed with wind-deposited dust and occasional insect remains. |
| **Scarcity** | **Common.** Continuously produced by ongoing wind erosion. The Gatehouse and Celestial Ring deposits regenerate (very slowly) as wind continues to erode the stone. |
| **Renewability** | **Renewable on a very slow timescale.** Wind erosion continuously produces new sand. The player cannot exhaust sand — but the accessible deposited sand (as opposed to sand still bonded in structural stone) is limited. |
| **Environmental Requirements** | Wind exposure (for production) + sheltered areas (for deposition and accumulation). |
| **Companion Resources** | Building stone (sand is produced from its erosion), Wind-deposited dust, Wind-deposited insects (in Gatehouse sand deposits), Crystal micro-fragments (in Celestial Ring sand — the standing stones contain crystal inclusions that weather out as fine particles) |
| **Common Player Mistakes** | Not distinguishing sand from clay (sand is granular and non-plastic; clay is smooth and plastic when wet). Overlooking sand as "just dust" — sand has specific applications that clay and stone cannot substitute. |
| **Codex Discoveries Enabled** | "Wind Erosion," "Sediment Sorting," "Abrasive Materials," "Filtration Media" |
| **Future Technologies Enabled** | Glassmaking (sand + high heat + understanding of glass chemistry), Abrasive tools (sandpaper/grinding), Mortar/construction aggregate, Water filtration systems |

---

### 4.3 — METALS

#### Metallic Debris (Iron, Brass, Copper)

| Field | Value |
|-------|-------|
| **Name** | Metallic Debris |
| **Category** | Metals |
| **Description [O]** | Rusted iron fittings, weathered brass fixtures, green-patina copper components. Found attached to or near original Golden Age equipment — door hinges, cargo cradle mechanisms, instrument mountings, structural fasteners. |
| **Natural Origin [K]** | NOT natural. All metal on the Ark was manufactured on the surface or on industrial floating islands (Resonance Foundries) and transported to the Ark during construction or operation. The metals are standard Golden Age metallurgy: iron (structural and mechanical), brass (copper-zinc alloy, decorative and corrosion-resistant), copper (electrical and plumbing). The visible corrosion (rust on iron, patina on brass and copper) is the result of 5,000 years of exposure to moisture and air. |
| **Historical Origin [K]** | The Golden Age researchers used metal for: structural fittings (door hinges, cargo cradle mechanisms, instrument mountings), scientific instruments (telescope tubes, measurement devices, calibration equipment), plumbing (copper water pipes — mostly corroded or buried), and electrical systems (copper wiring — mostly degraded). |
| **Primary Districts** | Gatehouse (cargo cradles, door hinges, reception desk fittings — highest concentration of accessible metal), Celestial Ring (telescope mountings, instrument housings, weather station components) |
| **Secondary Districts** | Aviary (iron framework arches — rusted but structurally sound, too large to harvest), Cascade Gardens (sluice gate mechanisms, weather station instruments), Stasis Sanctum (regulator panel components, chamber mechanisms — best preserved due to environmental control) |
| **Spawn Logic** | Metal is found wherever Golden Age equipment remains in place. Accessible metal comes from: (a) detached or broken components (fallen hinges, loose fittings), (b) corroded sections that have separated from larger structures, (c) small functional items (fasteners, brackets, instrument parts). Large structural metal (the Aviary arches) is too massive to harvest with early-game tools. |
| **Visual Characteristics [O]** | Iron: dark brown to orange-brown rust (#8B5E3C to #C07040), flaking surface texture, pitted. Brass: warm brown-gold (#B89860), green corrosion product at edges, smooth where preserved. Copper: distinctive blue-green patina (#609080), thicker patina in exposed areas, bright copper visible on fresh scratches. |
| **Scarcity** | **Limited and non-renewable.** The total quantity of metal on the Ark was fixed at the time of abandonment. No new metal can be created. However, the accessible metal (loose components, small items) is sufficient for the player's needs — large-scale metal construction would require accessing the Resonance Foundry islands. |
| **Renewability** | **Non-renewable.** Metal is a finite resource on the Ark. The player cannot manufacture new iron, brass, or copper. What exists was brought here 5,000+ years ago. |
| **Environmental Requirements** | Proximity to original Golden Age equipment. Best-preserved metal is in the Stasis Sanctum (environmental control). Most-corroded metal is in the Gatehouse (wind and moisture exposure). |
| **Companion Resources** | Building stone (metal components are embedded in or attached to stone structures), Crystal fragments (in instrument components — brass telescope mountings with crystal lenses) |
| **Common Player Mistakes** | Attempting to harvest metal from structurally essential components (door hinges that still function, regulator panel controls). The game distinguishes: decorative/loose metal can be collected; functional/structural metal cannot. Not recognizing different metal types (iron vs brass vs copper) and their different properties. |
| **Codex Discoveries Enabled** | "Golden Age Metallurgy," "Metal Corrosion," "Iron and Steel," "Copper Alloys," "Material Properties" |
| **Future Technologies Enabled** | Metal tools (chisels, knives, fasteners), Instrument repair (replacing damaged metal components in telescopes, weather stations, etc.), Metalworking (basic forging if the player constructs a furnace — limited by available metal quantity), Electrical systems (copper wire for basic circuits if power is restored) |

---

### 4.4 — CLAY (Category Reference)

Clay is detailed in Section 4.2 — Minerals. This section header exists for category completeness. See the Clay resource specification above.

---

### 4.5 — SAND (Category Reference)

Sand/Grit is detailed in Section 4.2 — Minerals. This section header exists for category completeness. See the Sand/Grit resource specification above.

---

## 5. BOTANICAL RESOURCES

### 5.1 — WOOD

#### Wood (Structural)

| Field | Value |
|-------|-------|
| **Name** | Wood (Branches and Fallen Timber) |
| **Category** | Wood |
| **Description [O]** | Fallen branches from mature trees, ranging from finger-thick twigs to arm-thick limbs. Weathered grey-brown on the outside, lighter brown-gold where recently broken. Found beneath large trees and in areas of structural decay. |
| **Natural Origin [K]** | Wood is produced by the Ark's mature trees — primarily the Courtyard Tree, the canopy trees in the Atrium and Verdant Creep, and the specimen trees in the Aviary. Branches fall naturally (storm damage, age, wind). Whole trees occasionally die and fall (lightning, disease, old age), creating larger wood deposits. The wood is from species that evolved on this planet — it shares basic properties with Earth wood (cellulose-lignin structure, burnable, workable) but has species-specific characteristics. |
| **Historical Origin [K]** | The Golden Age researchers used wood for: furniture (desks, chairs, shelving — most has decayed unless in protected interiors), tool handles, construction scaffolding, and fuel. The Courtyard Tree was deliberately pruned — the pruned branches were used for crafting and fuel. |
| **Primary Districts** | Living Quarters (fallen branches from the Courtyard Tree — regular, abundant), Verdant Creep (fallen logs and branches from canopy trees — irregular, scattered), Atrium (fallen branches from canopy trees growing through the dome) |
| **Secondary Districts** | Aviary (fallen branches from specimen trees), Cascade Gardens (occasional fallen branches from fruit trees) |
| **Spawn Logic** | Wood spawns beneath mature trees. Spawn rate is driven by: (a) wind events (storms cause branch fall — more wood after storms), (b) season (more branch fall in autumn/winter for deciduous species), (c) tree health (dying trees drop more branches). Large wood deposits (fallen trunks) are rare events — a tree death creates a significant wood resource that persists for years as it decays. |
| **Visual Characteristics [O]** | Weathered exterior: grey-brown (#8A7A6A), textured with lichen growth in older pieces. Fresh break: lighter brown-gold (#B89860 for the Courtyard Tree species, #A08850 for canopy species). Bark texture varies by species — the Courtyard Tree has distinctive silver-grey smooth bark; canopy trees have rougher, darker bark. |
| **Scarcity** | **Abundant and renewable.** The Ark's mature trees continuously produce fallen wood. The player cannot exhaust this resource — trees are always growing branches, and storms always cause breakage. However, specific types of wood (Courtyard Tree vs canopy species vs Aviary specimens) have different properties and different abundances. |
| **Renewability** | **Renewable.** Trees grow. Branches fall. New branches grow. The regeneration rate (branches) is on the scale of seasons to years. Large wood (fallen trunks) regenerates on the scale of decades to centuries (new trees must grow to maturity, then die). |
| **Environmental Requirements** | Mature trees. The Courtyard Tree, canopy trees in the Atrium and Verdant Creep, and specimen trees in the Aviary are the primary wood sources. |
| **Companion Resources** | Fungi (growing on fallen wood — decomposition), Insects (under bark, in decaying wood), Rich humus (from decomposed wood on the forest floor), Moss and lichens (on weathered wood surfaces) |
| **Common Player Mistakes** | Harvesting green wood (live branches) — the game permits this but the wood is inferior (higher moisture content, harder to work, burns poorly). Not recognizing that different tree species produce wood with different properties (Courtyard Tree wood is denser and stronger; canopy tree wood is lighter and more flexible). |
| **Codex Discoveries Enabled** | "Wood as a Material," "Tree Species of the Ark," "Sustainable Harvesting," "Wood Properties by Species" |
| **Future Technologies Enabled** | Tool handles (axes, hammers, picks), Construction (shelter frames, bridges, ladders), Fuel (firewood, charcoal production), Crafting (carved items, furniture, storage containers), Paper (from wood fiber — enables writing and knowledge sharing) |

---

### 5.2 — PLANTS (GENERAL)

#### Wild Grains

| Field | Value |
|-------|-------|
| **Name** | Wild Grains |
| **Category** | Plants (General) |
| **Description [O]** | Tall golden grass-like plants with seed heads at the top. Growing in dense stands on the upper Cascade terraces. The seed heads are distinctive — clusters of small hard grains, golden-brown when ripe, that shatter easily when touched. |
| **Natural Origin [K]** | These are feral descendants of the Ark's staple grain crops — domesticated varieties that were cultivated on the Cascade terraces for food. After abandonment, the grains continued to grow. Without human selection, they reverted toward wild-type characteristics: smaller seeds, shattering seed heads (seeds disperse at maturity), greater genetic diversity. They have undergone approximately 5,000 generations of natural selection on the Ark — adapting to the island's specific climate, soil, and competition. |
| **Historical Origin [K]** | The original grain varieties were bred by Golden Age agronomists for: high yield, disease resistance, and climate adaptability. The Ark's grain breeding program developed cultivars for distribution to surface communities. Some of the varieties growing feral on the Ark may be extinct on the surface — making the Ark the only remaining source. |
| **Primary Districts** | Cascade Gardens (upper terraces — the original grain-growing terraces, still dominated by feral descendants) |
| **Secondary Districts** | Cascade Gardens (middle terraces — scattered individuals that have spread from the upper terraces), Living Quarters (Rooftop Garden — a few feral grain plants from seeds that escaped the garden) |
| **Spawn Logic** | Wild grains grow in dense stands on the upper Cascade terraces — the driest, most sun-exposed areas. They are annual plants: they germinate with the spring rains, grow through the summer, set seed in autumn, and die. Seeds overwinter and germinate the following spring. The stand density varies seasonally — thickest in late summer before seed shatter, thinnest in early spring after germination. |
| **Visual Characteristics [O]** | Tall (0.8–1.2m), golden stems. Seed heads are 10–15cm long, composed of 30–50 small grains arranged in alternating pairs along a central stem. Ripe grains: golden-brown (#D4B060), hard, oval, approximately 4–5mm long. Unripe grains: green-gold, softer, higher moisture content. The stand as a whole creates a distinctive golden shimmer when wind moves through it — the sound of rustling grain is characteristic of the upper terraces. |
| **Scarcity** | **Abundant and annually renewable.** The upper Cascade terraces produce a significant grain crop every year. The player cannot exhaust this resource — the grains reseed themselves. However, annual abundance varies with weather conditions (drought years produce less; wet years produce more). |
| **Renewability** | **Annual.** Grains complete their life cycle in one growing season. Seeds germinate in spring, plants mature over summer, seeds are produced in autumn. The player can harvest grain annually and can also cultivate it deliberately (planting seeds in prepared soil) for higher yields. |
| **Environmental Requirements** | Full sun (upper terraces are the most sun-exposed area), well-drained soil (the terraces were designed for this), seasonal rainfall (germination trigger), dry period for ripening. The grains have adapted to the Ark's specific conditions and may perform differently if cultivated elsewhere. |
| **Companion Resources** | Wildflowers (meadow species growing among the grain — some are beneficial companion plants, some are competitors), Insects (seed-eating insects are common in the grain stands — they are both a pest and a resource), Birds (seed-eating birds forage in the grain stands, especially after seed shatter) |
| **Common Player Mistakes** | Harvesting too early (green grains are less nutritious and cannot be stored). Harvesting too late (after seed shatter, most grains have already fallen — the player gets a much smaller yield). Not recognizing that some grain plants have different characteristics (natural variation within the feral population — some are larger-seeded, some are more disease-resistant). |
| **Codex Discoveries Enabled** | "Plant Domestication and Feralization," "Annual Plant Life Cycles," "Grain Agriculture," "Seed Dispersal Mechanisms" |
| **Future Technologies Enabled** | Food (grain can be ground into flour, cooked as porridge, fermented), Cultivation (deliberate planting and management of grain crops), Breeding (selecting desirable traits over multiple generations), Trade (grain as a staple trade good with surface settlements) |

#### Edible Berries

| Field | Value |
|-------|-------|
| **Name** | Edible Berries (3 Types) |
| **Category** | Plants (General) |
| **Description [O]** | Three distinct berry types growing on shrubs in sunny, well-drained areas: (1) small deep-purple berries in clusters, (2) larger red-orange berries individually on thorny stems, (3) golden-yellow berries in pairs on smooth-stemmed bushes. All are visibly fleshy and colorful — clearly fruit. |
| **Natural Origin [K]** | Descendants of the Ark's cultivated berry varieties. Type 1 (purple) is descended from a high-antioxidant variety bred for nutritional content. Type 2 (red-orange) is descended from a medicinal variety — the original was used to treat inflammation. Type 3 (golden) is descended from a sweet dessert variety. All three have evolved over 5,000 years: the purple berries are smaller but more concentrated in flavor; the red-orange berries have larger thorns (herbivore defense without human protection); the golden berries are less sweet (sugar production is metabolically expensive without fertilization). |
| **Historical Origin [K]** | The original berry varieties were maintained in the Cascade Gardens (middle terraces) and the Aviary (living collection). Researchers used them for: nutrition (fresh consumption, preservation, cooking), medicine (the anti-inflammatory properties of Type 2), and breeding (developing varieties for surface distribution). |
| **Primary Districts** | Cascade Gardens (middle terraces — sunny edges near retaining walls), Aviary (specimen beds — scattered bushes descended from the living collection) |
| **Secondary Districts** | Verdant Creep (clearings where sufficient light penetrates — scattered individuals), Living Quarters (Rooftop Garden — a few berry bushes descended from personal plantings) |
| **Spawn Logic** | Berry bushes grow where: (a) sufficient sunlight reaches (open areas, south-facing slopes, clearing edges), (b) soil is well-drained (they are vulnerable to root rot in saturated soil), (c) they have space to establish (they are outcompeted by faster-growing species in the richest soils). Individual bushes are perennial — they fruit annually and can live for decades. |
| **Visual Characteristics [O]** | Type 1 (Purple): Small (8–10mm), deep purple-black (#4A2040), slight whitish bloom on the surface, in clusters of 5–12 berries. Type 2 (Red-Orange): Large (15–20mm), bright red-orange (#D06030), individual berries on thorny reddish stems. Type 3 (Golden): Medium (10–15mm), golden-yellow (#E0B040), in pairs, on smooth green-gold stems. |
| **Scarcity** | **Common and annually renewable.** Berry bushes fruit every year. Individual bushes are not abundant (perhaps 15–25 mature bushes of each type across the island), but each bush produces a significant crop. The player can propagate berries by collecting and planting seeds. |
| **Renewability** | **Annual fruiting; perennial plants.** Bushes fruit once per year (specific timing varies by species — Type 1 in early summer, Type 2 in late summer, Type 3 in autumn). The bushes themselves live for decades. New bushes can be grown from seed (takes 2–3 years to first fruiting) or from cuttings (takes 1–2 years). |
| **Environmental Requirements** | Full to partial sun, well-drained soil, some protection from extreme wind (bushes in exposed summit locations do not thrive). Type 1 prefers slightly acidic soil (found near the compost beds); Type 2 tolerates poorer soil (found on retaining wall edges); Type 3 prefers richer soil (found in the Aviary specimen beds). |
| **Companion Resources** | Pollinators (bees and butterflies are essential for berry production — bushes near the Aviary have higher yields), Birds (seed dispersers — birds eat berries and deposit seeds elsewhere, spreading the bushes), Medicinal herbs (Type 2 originally had medicinal use) |
| **Common Player Mistakes** | Harvesting Type 2 berries without recognizing they have medicinal as well as nutritional properties (the player may eat them for food when they would be more valuable as medicine). Harvesting all berries from a bush (leaving none for birds reduces seed dispersal and limits bush spread). Not recognizing that berry types prefer different conditions (planting Type 1 in dry soil leads to poor growth). |
| **Codex Discoveries Enabled** | "Fruit Development and Ripening," "Plant-Animal Mutualism (Seed Dispersal)," "Berry Species of the Ark," "Nutritional Properties of Fruit" |
| **Future Technologies Enabled** | Food (fresh consumption, drying, preserving), Medicine (Type 2 berries processed into anti-inflammatory preparations), Dye (berry juices as natural pigments — purple, red-orange, golden), Cultivation (deliberate berry farming), Fermentation (berry wines and preserves) |

#### Wildflowers

| Field | Value |
|-------|-------|
| **Name** | Wildflowers (12 Types) |
| **Category** | Plants (General) |
| **Description [O]** | Flowers in a spectrum of colors — white, yellow, pink, red, blue, purple — growing throughout the Aviary, Cascade Gardens, and in sunlit clearings in the Verdant Creep. Some are clearly the descendants of cultivated garden flowers; others are wild species that colonized the Ark as wind-borne seeds from the surface. |
| **Natural Origin [K]** | The Ark's wildflower population has two origins: (a) **Cultivated descendants** — flower species that were part of the Aviary's living collection and the Cascade Gardens' companion plantings. These have evolved over 5,000 years, hybridizing with each other and adapting to the Ark's conditions. Some exist in forms not found anywhere else. (b) **Wind-borne colonists** — seeds carried up from the surface or from other floating islands by wind. These species established themselves naturally and have integrated into the island's ecosystems. |
| **Historical Origin [K]** | Golden Age researchers valued flowers for: pollinator support (maintaining the managed bee and butterfly populations), medicinal properties (many flowering plants have pharmaceutical applications), aesthetic value (the Aviary was a showpiece as well as a working facility), and scientific study (flower color genetics, pollinator preference research). |
| **Primary Districts** | Aviary (Pollinator Garden and specimen beds — highest density and diversity), Cascade Gardens (upper and middle terraces — meadow wildflowers mixed with feral grains) |
| **Secondary Districts** | Verdant Creep (clearings and edges — scattered, shade-tolerant species), Living Quarters (courtyard — a few domesticated descendants around the base of the Courtyard Tree), Atrium (occasional in sunlit patches near the fountain) |
| **Spawn Logic** | Wildflowers grow where: (a) sufficient sunlight reaches, (b) pollinators are present (the Aviary and Cascade Gardens have the highest pollinator density), (c) soil conditions match the species' preferences. Different species bloom at different times — something is always in flower from early spring to late autumn. |
| **Visual Characteristics [O]** | Full color spectrum. Flowers range from tiny ground-hugging species (1–2cm blooms) to tall showy species (5–8cm blooms on 1m stems). Petal textures vary: some are translucent (holding light), some are velvety (deep color absorption), some are iridescent (angle-dependent color). Several species are bioluminescent (descendants of specimens from the Underworld — faint glow visible at dusk and night). |
| **Scarcity** | **Common to Uncommon depending on species.** Some wildflowers are abundant (the meadow species on the upper Cascade terraces). Others are rare (specific Aviary specimen descendants that exist as only a few individuals). |
| **Renewability** | **Annual to perennial depending on species.** Annual wildflowers complete their life cycle in one season and depend on seed production for persistence. Perennials return from roots or bulbs each year. |
| **Environmental Requirements** | Varies by species — from full-sun meadow specialists to shade-tolerant forest-floor species. General requirement: pollinator access (most species require insect pollination to set seed). |
| **Companion Resources** | Pollinators (bees, butterflies, moths — the wildflowers and pollinators are mutually dependent), Seeds (collectible from spent flower heads), Nectar/honey (bee-collected from the flowers), Medicinal properties (several wildflower species have pharmaceutical uses) |
| **Common Player Mistakes** | Harvesting flowers without leaving any for pollinators (reduces seed set for next year). Not recognizing that flower color is information — different colors attract different pollinators, indicate different soil conditions, and may signal different medicinal properties. |
| **Codex Discoveries Enabled** | "Flower Color and Pollinator Attraction," "Plant Reproduction," "Coevolution of Flowers and Pollinators," "Island Endemic Species" |
| **Future Technologies Enabled** | Pigments/dyes (flower petals as natural colorants), Medicine (pharmaceutical compounds from specific species), Fragrance (essential oils from aromatic flowers), Cultivation (deliberate flower farming for specific resources), Pollinator support (maintaining healthy bee and butterfly populations) |

#### Seeds

| Field | Value |
|-------|-------|
| **Name** | Seeds (15+ Types) |
| **Category** | Plants (General) |
| **Description [O]** | Small hard structures produced by flowering plants and grasses after blooming. Found in spent flower heads, on mature grain stalks, in fruit, and scattered on the ground beneath parent plants. Variable in size (dust-like to bean-sized), shape, and color depending on species. |
| **Natural Origin [K]** | Seeds are plant embryos packaged with nutrient reserves in protective coatings — the mechanism by which flowering plants reproduce and disperse. Every seed on the Ark was produced by a parent plant growing on the island. Some are from species that have been on the Ark for 5,000+ years (original cultivated varieties and their feral descendants). Others are from species that colonized more recently (wind-borne from the surface or other islands). |
| **Historical Origin [K]** | The Golden Age researchers maintained extensive seed collections: the Core Seed Bank in the Stasis Sanctum (resonance-stabilized for long-term preservation), the working seed storage in the Germination Station (Cascade Gardens) and Propagation Station (Aviary), and the surplus seed storage in the Verdant Creep (the Seed Bank that L breached). Seeds were the Ark's primary medium of genetic preservation — more durable than living plants, more compact than tissue samples, capable of surviving centuries or millennia in proper storage. |
| **Primary Districts** | Aviary (specimen beds and Propagation Station — highest diversity of mature seed-producing plants), Cascade Gardens (Germination Station — ancient seeds in dried mud, some still viable; mature grain stands and wildflowers producing new seed annually) |
| **Secondary Districts** | Verdant Creep (seeds from mature plants throughout — lower density due to lower flower density in shaded understory), Living Quarters (Rooftop Garden — seeds from the surviving cultivated plants), Stasis Sanctum (sealed chambers — the Core Seed Bank, inaccessible until resonance locks are opened) |
| **Spawn Logic** | Seeds are produced seasonally by mature plants after flowering. Seed availability peaks in autumn (after summer flowering and fruiting). Seeds are found: (a) on the plant (in dried flower heads, attached to seed stalks, within fruit), (b) on the ground beneath parent plants (natural seed drop), (c) in storage (Germination Station, Propagation Station, breached Seed Bank, sealed stasis chambers). |
| **Visual Characteristics [O]** | Enormously variable. Grain seeds: small (4–5mm), golden-brown, oval. Berry seeds: tiny (1–2mm), within fruit pulp. Wildflower seeds: dust-like to pea-sized, often with specialized dispersal structures (fluffy parachutes for wind dispersal, hooks for animal dispersal). Ancient seeds (Germination Station): embedded in dried mud, darker color, visibly aged. Stasis-preserved seeds (inaccessible): would appear fresh despite being 5,000 years old if the chambers were opened. |
| **Scarcity** | **Abundant for common species; rare for uncommon species.** The player can collect hundreds of grain seeds or common wildflower seeds easily. Rare Aviary specimen seeds may exist from only a single plant. Ancient seeds in the Germination Station are limited in quantity. Stasis Sanctum seeds are inaccessible until late-game. |
| **Renewability** | **Annual (for living plants); finite (for ancient stored seeds).** Living plants produce new seeds each year. The ancient seeds in the Germination Station are a finite archaeologic resource — once used, gone. The Stasis Sanctum seeds are finite but the quantity in sealed chambers is large. |
| **Environmental Requirements** | Depends on species. General requirement: parent plants must successfully flower and be pollinated to produce viable seed. |
| **Companion Resources** | Parent plants (the source of the seeds), Pollinators (essential for seed production in most species), Soil (where seeds germinate), Water (germination trigger for many species) |
| **Common Player Mistakes** | Collecting seeds indiscriminately without recording which plant they came from (the Journal helps, but the player should annotate). Storing seeds in poor conditions (moisture, temperature fluctuations) causing them to lose viability. Not recognizing that some ancient seeds require specific treatments to germinate (scarification, cold stratification, smoke exposure — the player discovers these through experimentation). |
| **Codex Discoveries Enabled** | "Seed Structure and Function," "Germination Requirements," "Seed Dormancy," "Genetic Preservation," "Seed Banking" |
| **Future Technologies Enabled** | Cultivation (deliberate planting and crop management), Breeding (selective breeding over generations), Trade (seeds as high-value, low-weight trade goods), Ecosystem restoration (reintroducing extinct or rare species), Food production (grain, vegetables, fruit) |

---

### 5.3 — MEDICINAL PLANTS

#### Medicinal Herbs (4 Types)

| Field | Value |
|-------|-------|
| **Name** | Medicinal Herbs |
| **Category** | Medicinal Plants |
| **Description [O]** | Four distinct herb species with visibly different characteristics: (1) broad-leaved, dark green, growing in damp shade — leaves feel cool to the touch, (2) fine-leaved, silvery-grey, growing in dry sunny areas — strong aromatic scent when crushed, (3) succulent-leaved, pale green, growing at water's edge — leaves contain clear gel, (4) tall, purple-tinged stems, growing in partial shade — distinctively bitter smell. |
| **Natural Origin [K]** | All four species are descendants of the Ark's original medicinal herb collection — plants cultivated for pharmaceutical use. They have evolved over 5,000 years but retained their core medicinal properties because those properties are genetically encoded secondary metabolites. Type 1 produces anti-inflammatory compounds. Type 2 produces antimicrobial essential oils. Type 3 produces wound-healing mucilage. Type 4 produces analgesic alkaloids. |
| **Historical Origin [K]** | The medicinal herb collection was maintained in the Cascade Gardens (lower terraces — the damp, sheltered conditions many medicinal species prefer) and in the Aviary (dedicated medicinal specimen beds, labeled with the information coding system). The Ark's physicians used these herbs to treat: injuries (wounds, burns, fractures), infections (bacterial, fungal), chronic conditions (inflammation, pain), and to supplement the more advanced resonance-based medical technology. The herbs were also dried and sent to surface communities as part of the Ark's medical supply program. |
| **Primary Districts** | Cascade Gardens (lower terraces and settling pool edges — Type 1, Type 3, Type 4), Aviary (medicinal specimen beds — all four types, with original labels) |
| **Secondary Districts** | Verdant Creep (scattered individuals of Type 1 and Type 4 in damp, shaded areas — escapees from the Cascade Gardens), Living Quarters (Rooftop Garden — Type 2 grown by a resident for personal use) |
| **Spawn Logic** | Each species has specific habitat requirements: Type 1 requires damp shade (found near water in sheltered areas). Type 2 requires dry sun (found on upper terraces and retaining wall edges). Type 3 requires saturated soil (found at the water's edge of settling pools and channels). Type 4 requires partial shade and rich soil (found in the transition zone between the Cascade Gardens and the Living Quarters). |
| **Visual Characteristics [O]** | Type 1: Broad dark green leaves (#2A4A2A), soft texture, 20–30cm tall, leaves in opposite pairs, small white flowers in summer. Type 2: Fine silvery-grey leaves (#A0A890), woody stems, 30–40cm tall, aromatic, small yellow flowers. Type 3: Succulent pale green leaves (#8AAA70), 10–15cm tall, low-growing, gel-filled, tiny pink flowers. Type 4: Tall purple-tinged stems (#604060 on green), 40–60cm tall, deeply veined leaves, clusters of small purple flowers. |
| **Scarcity** | **Uncommon but renewable.** Each species exists as scattered populations in its preferred habitat — not rare, but not abundant enough to harvest indiscriminately. The player can propagate them through seeds or cuttings to increase availability. |
| **Renewability** | **Perennial; renewable through propagation.** The plants are long-lived perennials. New plants can be grown from seed or cuttings. Sustainable harvesting (taking some leaves/flowers but leaving the plant alive) allows repeated harvest from the same individual. |
| **Environmental Requirements** | Species-specific (see Spawn Logic). All require: appropriate moisture, appropriate light, and freedom from competition by faster-growing non-medicinal species (in some areas, medicinal herbs are being outcompeted by aggressive colonists). |
| **Companion Resources** | Fresh water (Types 1, 3, and 4 grow near water), Rich soil (Type 4 requires nutrient-rich soil — found near compost areas), Pollinators (the herbs' flowers attract specific bee and butterfly species) |
| **Common Player Mistakes** | Harvesting the wrong part (leaves vs roots vs flowers — different parts have different concentrations of active compounds). Using a herb without understanding preparation requirements (Type 2's essential oils require steam distillation; Type 3's gel is used fresh; Type 4's alkaloids require careful dosage). Confusing medicinal herbs with similar-looking non-medicinal plants (there are look-alike species — the player learns to distinguish them by smell, taste, and detailed observation). |
| **Codex Discoveries Enabled** | "Plant Secondary Metabolites," "Medicinal Plant Preparation," "Dosage and Toxicity," "Ethnopharmacology of the Ark" |
| **Future Technologies Enabled** | Medicine (wound treatment, infection control, pain management, anti-inflammatory preparations), Herbalism (systematic knowledge of plant medicine), Pharmacology (isolation and concentration of active compounds), Trade (medicines as high-value trade goods with surface settlements) |

---

### 5.4 — FIBERS

#### Plant Fibers

| Field | Value |
|-------|-------|
| **Name** | Plant Fibers |
| **Category** | Fibers |
| **Description [O]** | Long, flexible strands obtained from plant stems, leaves, and bark. Found in three main forms: (1) vine fibers — long, tough, slightly woody, from the thick vines covering the Aviary arches and Verdant Creep structures, (2) bast fibers — fine, soft, strong, from the inner bark of specific shrubs and the stems of herbaceous plants on the Cascade terraces, (3) leaf fibers — coarse, stiff, durable, from the long leaves of a drought-resistant plant growing on retaining wall edges. |
| **Natural Origin [K]** | Fibers are structural plant tissues — elongated cells that provide tensile strength to stems, leaves, and bark. The three fiber types come from three different plant adaptation strategies: vine fibers (climbing plants — fibers resist the constant tension of hanging growth), bast fibers (fast-growing herbs and shrubs — fibers provide flexibility against wind), leaf fibers (drought-resistant plants — fibers resist wilting and provide structural support in thin soils). |
| **Historical Origin [K]** | Golden Age researchers used plant fibers for: cordage (ropes, twine, netting — essential for cargo handling at the Gatehouse and plant support in the Cascade Gardens), textiles (clothing, bedding, sacks — the Living Quarters' preserved fabric remnants show sophisticated weaving), paper (the Ark's research records were written on fiber-based paper), and composite materials (fiber-reinforced plasters and construction materials). |
| **Primary Districts** | Aviary (vine fibers from the arch-covering vines — abundant, constantly regrowing), Cascade Gardens (bast fibers from terrace-edge plants), Verdant Creep (vine fibers from structural colonizers, leaf fibers from clearing-edge plants) |
| **Secondary Districts** | Living Quarters (preserved textiles — fragile but usable as samples or for very fine applications), Gatehouse (remnants of cargo netting and rope — degraded but identifiable) |
| **Spawn Logic** | Fibers are obtained by processing plant materials: vines (harvest vine sections, strip outer bark, extract fibers — done at a crafting station), bast plants (harvest stems, ret in water to separate fibers, dry — done at a crafting station), leaf plants (harvest leaves, scrape away pulp to expose fibers). The source plants are renewable — vines regrow from established root systems, bast plants are annual or perennial herbs, leaf plants are perennial. |
| **Visual Characteristics [O]** | Vine fibers: pale brown (#B8A080), rough texture, long strands (30–100cm possible from mature vines), visible strength. Bast fibers: cream to pale gold (#D8C8A0 to #E0D0A0), soft, fine, shorter strands (10–30cm). Leaf fibers: pale green-grey (#A0A880), stiff, coarse, long strands (20–60cm from mature leaves). |
| **Scarcity** | **Common and renewable.** Vines, bast plants, and leaf plants are abundant in their respective habitats. The player can harvest sustainably (taking some stems/vines/leaves while leaving the plant alive to regrow). |
| **Renewability** | **Renewable on a seasonal to annual scale.** Vines regrow from established roots. Bast plants regrow annually or can be harvested from perennial plants. Leaf plants produce new leaves continuously. |
| **Environmental Requirements** | Species-specific: vines require structures to climb (arches, walls, trees), bast plants require full to partial sun and adequate moisture, leaf plants thrive in dry, exposed conditions (retaining wall edges, the Gatehouse). |
| **Companion Resources** | The source plants themselves (vines also produce flowers and seeds; bast plants are also medicinal in some cases; leaf plants are also drought-resistant colonizers), Wood (fiber plants often grow on or near trees and wooden structures) |
| **Common Player Mistakes** | Attempting to use fibers without processing (raw plant material is not usable as cordage — it must be extracted, dried, and twisted). Harvesting too much from a single plant (taking all vines from an arch kills the parent plant — the player learns to harvest sustainably). Not distinguishing between fiber types for different applications (vine fibers for rope, bast fibers for cloth, leaf fibers for coarse matting). |
| **Codex Discoveries Enabled** | "Plant Fiber Structure," "Cordage Making," "Textile Production," "Sustainable Harvesting" |
| **Future Technologies Enabled** | Cordage (rope, twine, thread — essential for construction, tool making, climbing equipment), Textiles (cloth for clothing, bedding, sacks, bandages), Paper (writing material — enables knowledge recording and sharing), Composite materials (fiber-reinforced clay/plaster for stronger construction), Fishing line/nets (if aquatic food sources are discovered) |

---

## 6. ANIMAL & INSECT RESOURCES

### 6.1 — ANIMAL PRODUCTS

#### Bird Feathers

| Field | Value |
|-------|-------|
| **Name** | Bird Feathers |
| **Category** | Animal Products |
| **Description [O]** | Individual feathers and small clusters found on the ground below bird nesting and roosting areas. Variable in size (2cm to 15cm), color (brown, grey, gold, blue-black depending on species), and type (downy body feathers, stiff wing feathers, delicate tail feathers). |
| **Natural Origin [K]** | Birds molt feathers naturally — replacing worn plumage with new growth. Molting occurs on a seasonal schedule (typically after breeding season). Feathers accumulate beneath nesting colonies in the Aviary arches, beneath roosting sites in the Atrium canopy trees, and along the flight paths where birds preen. The feathers come from multiple species: the golden-breasted Ark-endemic songbird, the nectar-feeding hummingbird analog, several seed-eating finch species, and the insectivorous flycatcher. |
| **Historical Origin [K]** | Golden Age researchers studied the Ark's bird population as part of the managed ecosystem. Feathers were collected for: species identification and population monitoring, writing implements (quill pens — the Living Quarters' library contains quills), insulation (down feathers in bedding and cold-weather clothing), and decoration. |
| **Primary Districts** | Aviary (below the nesting colonies in the upper arches — highest concentration, most species diversity), Atrium (below the canopy trees where birds roost) |
| **Secondary Districts** | Verdant Creep (scattered beneath roosting sites in the canopy), Living Quarters (below the Courtyard Tree — the nesting colony there), Gatehouse (below the swift nests in the doorframe) |
| **Spawn Logic** | Feathers accumulate beneath: (a) active nesting colonies (Aviary arches — continuous deposition during breeding season), (b) regular roosting sites (canopy trees — deposition during non-breeding season), (c) preening perches (exposed branches where birds groom — scattered individual feathers). Feather availability peaks during and after the molting season (late summer to early autumn). |
| **Visual Characteristics [O]** | Golden-breasted songbird: body feathers (golden-yellow #E0C040, soft, downy), wing feathers (grey-brown #A09880, stiff, aerodynamic). Hummingbird analog: tiny iridescent feathers (shifting green-purple #609080 ↔ #8060A0, 1–2cm). Finch species: brown and grey barred feathers, sturdy. Flycatcher: blue-black feathers (#404860), sleek. Down feathers from all species: pale grey, extremely soft, excellent insulation. |
| **Scarcity** | **Common and renewable.** Birds continuously molt and replace feathers. The player cannot exhaust this resource — the bird population is stable and self-sustaining. |
| **Renewability** | **Continuous.** Birds molt feathers throughout the year, with a peak during the post-breeding molt. Feathers decompose slowly (keratin is resistant to decay) so they accumulate over time. |
| **Environmental Requirements** | Healthy bird populations. Bird populations depend on: available food (insects, seeds, nectar depending on species), nesting sites (arches, canopy trees, structural crevices), and the absence of catastrophic disruption (the bird populations have been stable for thousands of years). |
| **Companion Resources** | Birds themselves (observable wildlife — their behavior teaches ecology, their presence indicates environmental health), Seeds (birds disperse seeds through their droppings — seed-rich areas often have bird activity), Insects (bird food source — feathers accumulate where birds have been feeding) |
| **Common Player Mistakes** | Not recognizing that different feather types have different uses (down for insulation, stiff wing feathers for fletching/quills, colorful feathers for decoration). Harvesting feathers from active nests (disturbing breeding birds — the player learns to collect fallen feathers from the ground rather than taking from nests). |
| **Codex Discoveries Enabled** | "Bird Molting Cycles," "Feather Structure," "Avian Species of the Ark," "Insulation and Thermoregulation" |
| **Future Technologies Enabled** | Insulation (down feathers in clothing and bedding for cold-weather exploration), Writing implements (quill pens), Fletching (if the player develops projectile tools), Decoration/cultural items |

#### Honey / Nectar

| Field | Value |
|-------|-------|
| **Name** | Honey / Nectar |
| **Category** | Animal Products |
| **Description [O]** | Golden, viscous liquid with a distinctive floral aroma. Found in honeycomb structures in the upper Aviary arches (active hives) and in abandoned hive sections. The honey's flavor varies subtly with the season — different flowers in bloom produce different nectar compositions. |
| **Natural Origin [K]** | Honey is produced by the Ark's bee colonies — descendants of the managed pollinator population maintained by Golden Age apiarists. Bees collect nectar from flowering plants (primarily in the Aviary and Cascade Gardens), enzymatically process it in their honey stomachs, and deposit it in wax honeycomb cells where it dehydrates to the stable, high-sugar product the player harvests. The bees have been self-sustaining for 5,000 years without human management. |
| **Historical Origin [K]** | The Golden Age apiarists maintained hives for: pollination (the bees were essential to the Ark's agricultural productivity), honey production (a valued food and preservative), wax production (for sealing containers, waterproofing, and lost-wax casting of small metal parts), and research (bee behavior, colony collapse studies, pollinator ecology). The last apiarist made the deliberate decision to leave the hives open during evacuation — trusting the bees to survive independently. The bees justified that trust. |
| **Primary Districts** | Aviary (the active hives in the upper arches — the player can see bees coming and going, and honeycomb is visible in the highest arches) |
| **Secondary Districts** | Cascade Gardens (foraging bees — evidence of bee activity but hives are in the Aviary) |
| **Spawn Logic** | Honey is stored in bee hives in the Aviary arches. The hives are active and defended by bees. The player can harvest honey by: (a) accessing the lower portions of the hives (less defended, smaller honey yield), (b) using smoke to calm the bees (a technique discovered through experimentation — the Journal records the discovery), (c) waiting until winter when bees are dormant (lowest honey availability but safest harvesting). Honey quantity fluctuates seasonally — highest in late summer after the main flowering period, lowest in early spring after winter consumption. |
| **Visual Characteristics [O]** | Honey: golden to amber (#E8B040 to #C88020), translucent, viscous, flows slowly. Crystallized honey (older, in abandoned comb sections): pale gold (#E0C880), granular texture. Honeycomb: pale yellow-white wax (#F0E8C0), hexagonal cells, some capped (ripe honey), some open (unripe honey or empty). |
| **Scarcity** | **Uncommon but renewable.** The Ark supports a stable bee population with finite hive capacity. The player can harvest a modest amount of honey annually without harming the colony. Over-harvesting (taking too much, especially in autumn when bees need winter stores) can cause colony collapse — a permanent loss of the resource until a new colony establishes (years to decades). |
| **Renewability** | **Annual cycle.** Bees produce honey continuously during the flowering season. The sustainable harvest is the surplus beyond what the colony needs for winter survival. The player learns this through observation and (potentially painful) experimentation. |
| **Environmental Requirements** | Thriving bee population + flowering plants for nectar + suitable nesting sites (the Aviary arches provide ideal conditions: sheltered, warm, near flowers). The bee population depends on plant diversity — a catastrophic loss of flowering plants would starve the bees. |
| **Companion Resources** | Beeswax (a separate resource from honey — the wax comb), Pollen (bee-collected pollen — a separate nutritional resource), Flower petals (the source of nectar — honey characteristics reflect which flowers are in bloom), Bees themselves (observable pollinators — their behavior teaches plant-pollinator relationships) |
| **Common Player Mistakes** | Attempting to harvest honey without preparation and getting stung (the Journal records: "The bees defended their hive. I was stung repeatedly. The honey inside was not worth the cost. Note to self: bees are protective. Approach hives with smoke or not at all."). Harvesting too much honey in autumn and causing colony starvation (the bees die over winter — the player discovers empty hives in spring and learns a hard lesson about sustainable harvesting). |
| **Codex Discoveries Enabled** | "Honeybee Social Structure," "Nectar Processing," "Pollination Ecology," "Sustainable Harvesting" |
| **Future Technologies Enabled** | Food (honey as sweetener, preservative, energy source), Medicine (honey's antimicrobial properties — wound dressings, infection treatment), Fermentation (mead — honey wine), Wax (candles, waterproofing, sealing, lost-wax casting for small metal parts) |

#### Insect Specimens

| Field | Value |
|-------|-------|
| **Name** | Insect Specimens |
| **Category** | Animal Products |
| **Description [O]** | Insects found throughout the island — living (observed, not necessarily collected) and dead (wind-deposited, naturally deceased). Range from tiny soil-dwelling springtails to large showy butterflies to thumb-sized beetles. The dead specimens are intact but fragile — preserved by the Ark's dry conditions in sheltered areas. |
| **Natural Origin [K]** | The Ark's insect population derives from multiple sources: (a) descendants of the managed pollinator population (bees, butterflies, moths — deliberately maintained during the Golden Age), (b) descendants of research subjects (various species studied in the Verdant Creep's simulation chambers), (c) wind-borne colonists (species carried to the Ark by wind from the surface or other islands over 5,000 years). The insect community is now a stable, self-sustaining component of the Ark's ecosystem — essential to pollination, decomposition, and the food web. |
| **Historical Origin [K]** | Golden Age entomologists studied the Ark's insect populations for: pollination management (ensuring crop fertility), pest control (managing species that damaged crops or stored food), decomposition studies (understanding nutrient cycling in closed systems), and biodiversity documentation. The insect collection — both living specimens and preserved samples — was part of the Ark's broader biological preservation mission. |
| **Primary Districts** | Verdant Creep (highest insect diversity — the dense vegetation, humidity, and varied microclimates support the most species), Aviary (highest density of pollinators — bees, butterflies, moths), Cascade Gardens (agricultural insects — pollinators, decomposers, some herbivorous species) |
| **Secondary Districts** | Atrium (insects attracted to the fountain and bioluminescent moss), Living Quarters (booklice in the library, moths in textile storage), Gatehouse (wind-deposited dead insects in sheltered corners), Celestial Ring (wind-deposited insects — mostly dead on arrival) |
| **Spawn Logic** | Living insects are found throughout the island according to species-specific habitat requirements. Dead specimens accumulate: (a) in wind-sheltered corners (Gatehouse, Celestial Ring), (b) on the forest floor (natural death — Verdant Creep, Atrium), (c) trapped in spider webs, (d) in water (insects that fell into channels and pools). Insect availability is seasonal — peak abundance in spring and summer, minimal in winter. |
| **Visual Characteristics [O]** | Enormously variable. Butterflies: wings in every color, 3–8cm wingspan, distinctive flight patterns. Beetles: hard glossy exoskeletons, metallic greens and bronzes, 1–4cm. Bees: golden-brown fuzzy bodies, 1–2cm. Dragonflies: iridescent wings, 6–10cm wingspan, hovering flight over water. Dead specimens: faded but structurally intact if in dry, sheltered locations. |
| **Scarcity** | **Common (living observation) to Uncommon (specific dead specimens).** Insects are everywhere — the player cannot walk through the Verdant Creep or Aviary without seeing dozens. But specific species (particularly rare Ark-endemic insects) exist in limited populations. Dead specimens of rare species are themselves rare. |
| **Renewability** | **Renewable.** Insect populations reproduce continuously during the warm season. Populations are stable — the island's carrying capacity has been reached for most species. |
| **Environmental Requirements** | Species-specific: pollinators require flowering plants, decomposers require organic matter, predators require prey species. All insects require appropriate temperature and moisture — activity is seasonal. |
| **Companion Resources** | The plants they pollinate or feed on, Fungi (food source for many insect species), Animal products from insectivores (bird feathers, spider silk — the animals that eat insects), Spider webs (where insects are trapped) |
| **Common Player Mistakes** | Not recognizing insects as a resource at all — seeing them as ambiance rather than as collectible specimens, ecological indicators, and (in some cases) usable materials. Collecting specimens without recording where and when they were found (context is essential for ecological understanding). |
| **Codex Discoveries Enabled** | "Insect Diversity," "Pollination Networks," "Decomposition Food Webs," "Insect Life Cycles," "Ark Endemic Insect Species" |
| **Future Technologies Enabled** | Bait (for fishing if aquatic food sources exist), Medicine (some insects have pharmaceutical uses — antimicrobial peptides, wound treatment), Dye (insect-derived pigments — historically the most vibrant reds and purples), Food (insects as protein source — culturally variable but nutritionally valid), Ecosystem monitoring (insect populations as indicators of environmental health) |

---

This document continues with Sections 7 through 17. Due to its size, the remaining sections will be written in a continuation file.


---

## 7. DECOMPOSITION RESOURCES

### 7.1 — ORGANIC MATTER

#### Rich Humus / Compost

| Field | Value |
|-------|-------|
| **Name** | Rich Humus / Compost |
| **Category** | Organic Matter |
| **Description [O]** | Dark, crumbly, earthy-smelling soil material found on the forest floor, in the composting beds, and in areas of deep leaf litter accumulation. It is visibly different from the mineral soil — darker, looser, full of visible organic fragments at various stages of decomposition. |
| **Natural Origin [K]** | Humus is the end product of organic matter decomposition — the dark, stable, nutrient-rich material that remains after fungi, bacteria, insects, and worms have broken down dead plant and animal matter. On the Ark, humus has been accumulating for 5,000 years. Every fallen leaf, every dead plant, every animal carcass, every insect exoskeleton has contributed to the humus layer. The process is continuous: fresh organic matter is added from above (leaf fall, plant death), while soil organisms convert it to humus below. |
| **Historical Origin [K]** | Golden Age agronomists actively managed the Ark's composting system: the Compost Beds in the Cascade Gardens were deliberately maintained to recycle plant waste into growing medium. Kitchen scraps from the Living Quarters were composted. The composting system was part of the Ark's closed-loop ecology — nothing was wasted. After abandonment, the managed composting continued naturally: plants grew, died, and decomposed without human intervention, building the humus layer that now supports the island's fertility. |
| **Primary Districts** | Verdant Creep (forest floor — the deepest humus on the island, 0.5–2m in sheltered areas), Cascade Gardens (compost beds — original managed composting areas, now functioning as natural decomposition zones) |
| **Secondary Districts** | Atrium (leaf litter accumulation beneath canopy trees — thinner humus layer, 5–20cm), Living Quarters (Courtyard Tree leaf litter — small but high-quality humus from a single species), Aviary (humus in the specimen beds — enriched by deliberate cultivation and millennia of plant growth) |
| **Spawn Logic** | Humus is found wherever organic matter has been decomposing for extended periods. The thickest humus is in the Verdant Creep — the combination of dense vegetation, high humidity, and 5,000 years of uninterrupted decomposition has created the island's richest soil. In the Cascade Gardens, the original compost beds are still visibly richer than surrounding soil. Under trees (Atrium, Living Quarters, Aviary), leaf litter creates thinner but still valuable humus layers. |
| **Visual Characteristics [O]** | Dark brown to nearly black (#3A3020 to #2A2010). Crumbly, loose texture — falls apart easily when handled. Visible organic fragments: partially decomposed leaves, small twigs, occasional insect exoskeletons. Healthy humus has a distinctive earthy smell (geosmin — the scent of soil bacteria). The humus in the Verdant Creep is darker and finer than elsewhere (older, more completely decomposed). |
| **Scarcity** | **Abundant and continuously renewable.** Humus is produced wherever organic matter decomposes. The supply is proportional to vegetation density — the Verdant Creep produces humus continuously. However, high-quality humus (from specific locations with ideal decomposition conditions) is more limited — the Cascade Gardens compost beds and the Verdant Creep deep humus are the premium sources. |
| **Renewability** | **Continuous.** Organic matter is continuously added (leaf fall, plant death) and continuously decomposed. The humus layer is slowly increasing over time (more organic matter is produced than fully mineralized each year). The player can harvest humus without depleting the supply — new humus is constantly forming. |
| **Environmental Requirements** | Organic matter input (plant growth and death), moisture (decomposition requires water — the driest areas have minimal humus formation), decomposer organisms (fungi, bacteria, insects, worms — present throughout the island except the sterile Sanctum). |
| **Companion Resources** | Fungi (the primary decomposers — visible on and near humus-rich areas), Insects (decomposer insects in humus — millipedes, springtails, beetle larvae), Plants (humus supports plant growth — areas with deep humus have the most vigorous vegetation), Earthworms (in the Cascade Gardens and Verdant Creep humus — indicators of healthy soil) |
| **Common Player Mistakes** | Harvesting humus without recognizing that it is a living medium (sterilizing it by drying or heating destroys its beneficial organisms). Taking humus from areas where it is supporting important plant communities (the player learns sustainable harvesting — take some, leave enough for the ecosystem). |
| **Codex Discoveries Enabled** | "Decomposition and Nutrient Cycling," "Soil Food Web," "Humus Formation," "Closed-Loop Ecology" |
| **Future Technologies Enabled** | Cultivation (humus as the ideal growing medium — plants grown in humus are healthier and more productive), Soil improvement (adding humus to mineral soil creates fertile growing beds anywhere), Composting (the player can create new humus deliberately by managing organic waste), Ecosystem restoration (restoring fertility to degraded areas) |

#### Fungi

| Field | Value |
|-------|-------|
| **Name** | Fungi (6+ Types) |
| **Category** | Organic Matter (Decomposition) |
| **Description [O]** | Mushrooms and bracket fungi in various sizes, shapes, and colors. Found on fallen logs, at the base of living trees, on the forest floor, and (for bioluminescent species) in the dark, damp Fungal Grotto. Range from tiny 1cm cups to large 30cm shelf fungi to clusters of glowing blue-green mushrooms. |
| **Natural Origin [K]** | Fungi are the Ark's primary decomposers — organisms that break down dead plant matter (wood, leaves, roots) into nutrients that living plants can use. The fungal network (mycelium) threads through the soil and decaying wood throughout the island, connecting the decomposition system into a single distributed organism. The visible mushrooms are the fruiting bodies — temporary reproductive structures that emerge when conditions are right. The actual fungus is the invisible mycelial network. |
| **Historical Origin [K]** | Golden Age mycologists maintained a fungal collection for: decomposition studies (understanding how closed-system nutrient cycling works), food production (edible mushroom cultivation — the Ark grew mushrooms as a protein source), medicine (fungal antibiotics and immune-modulating compounds), and materials science (fungal mycelium as a biodegradable construction material). Some of the fungal species on the Ark were deliberately introduced; others colonized naturally. |
| **Primary Districts** | Verdant Creep (Fungal Grotto — highest diversity, bioluminescent species, the island's fungal heart; fallen logs throughout — bracket fungi, decomposer mushrooms), Cascade Gardens (compost beds — decomposer fungi, some edible species descended from cultivation) |
| **Secondary Districts** | Atrium (shaded areas near the fountain — moisture-loving fungi on fallen wood and moss), Living Quarters (on fallen Courtyard Tree branches — specific fungi associated with that tree species), Aviary (in the richest specimen bed soils — mycorrhizal fungi associated with specific plant species) |
| **Spawn Logic** | Fungi fruit when: (a) moisture is sufficient (after rain, in humid areas), (b) temperature is appropriate (spring and autumn are peak mushroom seasons, though the bioluminescent species fruit year-round in the stable Grotto conditions), (c) the mycelial network has accumulated enough energy to produce fruiting bodies. Individual mushrooms last days to weeks; the mycelial network persists indefinitely. |
| **Visual Characteristics [O]** | Enormously variable. Edible species (Type 1): pale tan caps (#C8B898), 5–10cm, gilled, growing in clusters on compost and rich soil. Medicinal species (Type 2): dark brown caps (#604030), 3–6cm, on fallen logs — distinctive reddish gills. Bioluminescent species (Type 3): pale blue-green caps (#80B8A0), 2–5cm, glow visible in darkness — concentrated in the Fungal Grotto. Bracket fungi (Type 4): shelf-like, woody, brown and white banded (#A08060 & #D8C8B0), on standing dead wood. Tiny decomposers (Types 5–6): various small species on leaf litter and buried wood — easily overlooked. |
| **Scarcity** | **Common to Rare depending on species.** Edible and common decomposer species are abundant in their preferred habitats. Bioluminescent species are restricted to the Fungal Grotto and a few other dark, damp locations. Medicinal species are uncommon — specific to certain log types and decay stages. |
| **Renewability** | **Renewable (fruiting bodies) — the mycelial network is permanent.** The fungal network persists in the soil and wood. Fruiting bodies appear seasonally. Harvesting mushrooms does not harm the underlying fungus (the mycelium remains) provided the harvesting is not so destructive that it damages the substrate. |
| **Environmental Requirements** | Moisture (all fungi require water to fruit), appropriate substrate (specific wood types, soil compositions, or plant associations for different species), temperature (seasonal for most species; stable year-round in the Fungal Grotto). |
| **Companion Resources** | Wood (the substrate for wood-decomposing fungi), Rich humus (the product of fungal decomposition), Living plants (many fungi form mycorrhizal associations with plant roots — the plants and fungi exchange nutrients), Moss (shares the damp, shaded habitat) |
| **Common Player Mistakes** | Eating unidentified mushrooms (potentially toxic — the player learns through the Journal: "I don't know if this is safe to eat. Some fungi are deadly. I should study them before consuming."). Harvesting all mushrooms from an area (removing all fruiting bodies doesn't kill the fungus but eliminates spore production for future generations). Not recognizing that the mushroom is just the visible part — the real organism is underground. |
| **Codex Discoveries Enabled** | "Fungal Decomposition," "Mycorrhizal Networks," "Edible and Toxic Fungi," "Bioluminescence in Fungi," "Fungal Life Cycles" |
| **Future Technologies Enabled** | Food (edible mushroom cultivation — the player can establish mushroom beds using spores and appropriate substrate), Medicine (antibiotic compounds, immune modulators from medicinal fungi), Fermentation (yeasts for bread, alcohol, and other fermented products), Dye (fungal pigments), Bioluminescent light sources (cultivated glowing fungi for illumination) |

#### Rotting Wood

| Field | Value |
|-------|-------|
| **Name** | Rotting Wood |
| **Category** | Organic Matter |
| **Description [O]** | Fallen logs, branches, and structural wood in various stages of decay. Ranges from recently fallen (still hard, bark intact) to partially decomposed (soft, spongy, fungal growth visible) to nearly soil (crumbly, dark, barely recognizable as wood). |
| **Natural Origin [K]** | When trees die or branches fall, the wood begins decomposing through the action of fungi, bacteria, and insects. The decomposition process releases nutrients back into the soil and creates habitat for a succession of organisms. Rotting wood is a **keystone resource** — it supports more species than living wood, functioning as both food source and habitat. |
| **Historical Origin [K]** | Golden Age researchers studied wood decomposition as part of the closed-loop ecology system. The Ark's wooden structures (furniture, tool handles, construction scaffolding) have largely decayed over 5,000 years, contributing to the soil organic matter. The current rotting wood comes from natural tree death and branch fall — an ongoing ecological process. |
| **Primary Districts** | Verdant Creep (fallen logs and branches from canopy trees — the highest density of rotting wood on the island), Living Quarters (fallen Courtyard Tree branches — large, consistent supply) |
| **Secondary Districts** | Atrium (fallen branches from canopy trees growing through the dome), Aviary (fallen branches from specimen trees — less common but present) |
| **Spawn Logic** | Rotting wood is produced by: (a) ongoing branch fall (wind, storms, natural pruning), (b) tree death (rare but significant — a single mature tree death creates a large, long-lasting rotting wood resource), (c) structural wood decay (the last remnants of Golden Age wooden structures — rare, mostly fully decomposed). The decomposition timeline: year 1–5 (hard wood, bark peeling), year 5–20 (softening, fungal colonization, insect boring), year 20–50 (spongy texture, extensive fungal growth, breaking apart), year 50+ (crumbly, dark, transitioning to humus). |
| **Visual Characteristics [O]** | Stage 1 (Recent): original wood color (#A08060 to #B89860 depending on species), hard, bark present but loose. Stage 2 (Early Decay): darkening (#806040), softening, fungal hyphae visible as white threads, bracket fungi may be present. Stage 3 (Advanced Decay): dark brown to nearly black (#4A3020 to #2A2010), spongy, crumbles when handled, extensive fungal and insect activity. Stage 4 (Late): black crumbly material, recognizable as wood only by shape and location, transitioning to humus. |
| **Scarcity** | **Common and continuously renewable.** Trees continuously shed branches. The supply of rotting wood at various decay stages is maintained by the ongoing input of fresh wood and the continuous progression of decomposition. |
| **Renewability** | **Continuous.** New wood enters the system (branch fall, tree death). Wood progresses through decay stages over decades. The player harvesting rotting wood is using a resource that is continuously replenished — but the specific decay stage they need may require finding wood at the right age. |
| **Environmental Requirements** | Tree death or branch fall + moisture + decomposer organisms. The Verdant Creep's humidity accelerates decomposition; the Atrium's drier conditions slow it. |
| **Companion Resources** | Fungi (the primary decomposers of wood — the fungal species on a log indicate its decay stage), Insects (wood-boring beetles, termites — both decomposers and resources), Rich humus (the end product of wood decomposition), Moss (colonizing the surface of rotting logs) |
| **Common Player Mistakes** | Overlooking rotting wood as "just dead tree" — not recognizing its value as: cultivation substrate (mushrooms), moisture-retaining soil amendment, habitat for collectible insects, and indicator of forest health. |
| **Codex Discoveries Enabled** | "Wood Decomposition," "Saprophytic Fungi," "Nutrient Cycling in Forests," "Dead Wood Ecology" |
| **Future Technologies Enabled** | Mushroom cultivation (rotting wood as substrate for edible and medicinal fungi), Water retention (rotting wood incorporated into soil holds moisture), Fuel (partially decayed wood burns differently than fresh wood — cooler, longer-burning), Habitat creation (deliberately placing rotting wood to attract specific insects or fungi) |

---

## 8. WATER RESOURCES

### 8.1 — WATER

#### Fresh Water

| Field | Value |
|-------|-------|
| **Name** | Fresh Water |
| **Category** | Water |
| **Description [O]** | Clear, cool, odorless water flowing through the island's channels, standing in the reservoir and settling pools, and emerging from the Atrium fountain. The water has a slight mineral taste (from contact with the structural stone) and is visibly clean — the settling pools and aquatic plants filter it. |
| **Natural Origin [K]** | All water on the Ark comes from rain. The island's surface acts as a catchment — rainwater is directed by the original drainage system toward the Central Reservoir in the Cascade Gardens. From the reservoir, water flows by gravity through the irrigation channels, across the terraces, into the settling pools, and eventually to the cistern beneath the Atrium that feeds the fountain. The system is a closed loop: water that evaporates from plants and surfaces condenses as clouds and eventually falls again as rain. |
| **Historical Origin [K]** | The water management system was one of the Ark's foundational engineering achievements — a closed-loop hydrological system designed to support a permanent human population and intensive agriculture on a floating platform with no natural water sources. The system was designed for: rainwater capture (the entire island surface is graded to direct water to the reservoir), gravity-fed distribution (no pumps — the reservoir's elevation provides sufficient pressure), filtration (settling pools with aquatic plants and sand layers), and conservation (minimal evaporation through covered channels and strategic planting). The system has functioned without maintenance for 5,000 years — only the sluice gates show signs of needing adjustment. |
| **Primary Districts** | Cascade Gardens (Central Reservoir — the primary collection and storage point; irrigation channels; settling pools — cleanest, most accessible water), Atrium (the fountain — aesthetically beautiful, functionally the overflow point of the entire system) |
| **Secondary Districts** | Verdant Creep (drainage channels running beneath the district — accessible in the Sunken Lab area; dripping water in the Fungal Grotto from overhead seepage), Gatehouse (rainwater pools in structural depressions — stagnant, not potable without treatment), Living Quarters (rooftop cistern — collects rain for the Rooftop Garden, small capacity) |
| **Spawn Logic** | Water is present wherever the hydrological system directs it. The flow varies seasonally: highest in the rainy season (reservoir full, channels running strong), lowest in the dry season (reservoir lower, channels reduced to trickles). The system never completely dries — the reservoir was sized to maintain flow through the longest expected dry period (~60 days at the Ark's altitude). |
| **Visual Characteristics [O]** | Clear with a very faint blue-green tint in deep water (the reservoir). Moving water (channels, fountain) is crystal clear. Still water (settling pools) has a slight golden tint from dissolved organic compounds. The water's clarity varies: the reservoir and upper channels are clearest (minimal sediment); the lower settling pools have some suspended organic matter (but are still drinkable). Bioluminescent moss in the fountain basin creates a soft glow in the water at night. |
| **Scarcity** | **Abundant and continuously renewable.** Rain falls regularly at the Ark's altitude. The reservoir stores sufficient water for extended dry periods. The player cannot exhaust the water supply — it is a renewable resource driven by the planetary water cycle. |
| **Renewability** | **Continuous.** The water cycle (evaporation → condensation → precipitation → collection) operates continuously. The island's catchment and storage system ensures reliable access. |
| **Environmental Requirements** | Rain. The Ark's altitude places it in a cloud-penetrating zone — it receives regular precipitation year-round. Extended drought is possible but rare; the reservoir provides buffer capacity. |
| **Companion Resources** | Aquatic plants (in settling pools — water-filtering species that keep the water clean), Clay (deposited at pool edges — water is the transport mechanism for clay particles), Medicinal herbs (moisture-loving species grow near water), Moss (on wet stone near channels and pools), Amphibians (in the settling pools — indicators of water quality) |
| **Common Player Mistakes** | Drinking from stagnant water sources (Gatehouse puddles, Verdant Creep standing water) without treatment — risk of waterborne illness. Not recognizing that water quality varies by location (reservoir = cleanest, lower channels = adequate, stagnant pools = requires treatment). Not understanding the hydrological system — the player who traces the water flow understands where to find clean water anywhere on the island. |
| **Codex Discoveries Enabled** | "The Water Cycle," "Closed-Loop Hydrology," "Water Filtration," "Rainwater Harvesting," "The Ark's Water Management System" |
| **Future Technologies Enabled** | Irrigation (deliberate water management for cultivation), Water treatment (filtration, boiling, chemical treatment for stagnant sources), Water-powered machinery (if the player constructs water wheels in the channels), Aquatic cultivation (growing water-dependent crops in the settling pools), Hydration for exploration (carrying water for expeditions beyond the Ark) |

---

## 9. RESONANCE RESOURCES

### 9.1 — CRYSTALS

#### Crystal Fragments (Small)

| Field | Value |
|-------|-------|
| **Name** | Crystal Fragments (Small) |
| **Category** | Crystals |
| **Description [O]** | Translucent to transparent crystal pieces ranging from thumbnail-sized chips to palm-sized shards. When held, they feel slightly warm. A very faint hum is perceptible when the crystal is held close to the ear. In darkness, a barely visible blue-white luminescence is detectable. |
| **Natural Origin [K]** | NOT natural in the geological sense. These crystals are fragments of the Ark's resonance infrastructure — the crystal arrays embedded in the structural stone that provide the island's lift. Over 5,000 years, weathering, erosion, and structural settling have caused small crystals to spall off from the larger arrays, working their way to the surface through cracks in the structural stone. The crystals are silicate-based with rare-earth element doping (primarily neodymium and dysprosium) in specific lattice configurations that enable resonance energy storage and release. |
| **Historical Origin [K]** | The crystals were grown in the Resonance Foundries — the industrial islands of the Golden Age. The growth process required: precise temperature and pressure control, silica-rich fluid precursors, rare-earth element dopants at parts-per-million concentrations, and resonance field templating to guide the crystal lattice into the correct configuration. Small crystals like these fragments were used for: tools (resonance-enhanced cutting and drilling implements), instruments (resonance detectors, frequency measurement devices), and research (experimental crystal growth studies). |
| **Primary Districts** | Cascade Gardens (exposed where retaining walls have crumbled — erosion exposes the infrastructure beneath), Verdant Creep (near the Sunken Lab — the highest concentration of exposed resonance infrastructure), Atrium (fallen dome fragments — the Shattered Dome crystals) |
| **Secondary Districts** | Celestial Ring (near the Resonance Monitors — chips from the monitoring equipment), Gatehouse (near the Quarantine Station — chips from the resonance lock), Living Quarters (near the Director's resonance-locked chest — tiny fragments in the surrounding stone) |
| **Spawn Logic** | Small crystal fragments are found where: (a) the Ark's structural stone has weathered, crumbled, or cracked — exposing the resonance infrastructure beneath, (b) resonance equipment has deteriorated — shedding fragments from instrument components, (c) dome or structural crystal elements have shattered — the Atrium dome fragments are the most visible example. The fragments are not randomly scattered — they concentrate where erosion and structural damage have exposed the island's interior. |
| **Visual Characteristics [O]** | Translucent to transparent. Color ranges from clear (uncharged or low-charge) to pale blue-white (charged). Internal structure visible as planes and facets within the crystal body — the resonance-capable lattice structure is visibly different from random fracture patterns. Charged crystals glow faintly in darkness — the glow intensity correlates with stored energy. The hum is at the threshold of hearing — some players may perceive it as much as hear it. |
| **Scarcity** | **Uncommon but findable.** Small fragments are continuously produced by the island's slow weathering. The player who knows where to look (crumbled retaining walls, structural cracks, near resonance equipment) can find them reliably. But they are not abundant — each fragment represents a piece of the Ark's irreplaceable infrastructure. |
| **Renewability** | **Very slowly renewable.** Weathering continues to produce new fragments, but on a scale of years to decades. For practical gameplay: a limited but sufficient initial supply, with very slow regeneration. The player cannot farm crystals — they are a finite inheritance from the Golden Age. |
| **Environmental Requirements** | Exposure of resonance infrastructure through erosion, structural damage, or deliberate excavation. The resonance moss that grows on exposed crystals indicates their presence — the player learns to use the moss as a prospecting tool. |
| **Companion Resources** | Resonance Moss (growing on exposed crystals — a reliable visual indicator), Building Stone (the matrix from which crystals emerge), Ancient Components (many Golden Age instruments contain crystal elements) |
| **Common Player Mistakes** | Not recognizing that the crystal's glow and hum indicate stored energy — treating it as a passive material rather than an active energy storage medium. Attempting to use uncharged crystals (clear, no glow, no hum) — they are inert and require charging before they exhibit resonance properties. |
| **Codex Discoveries Enabled** | "Resonance Crystal Structure," "Crystal Growth and Doping," "Resonance Energy Storage," "Crystal Detection and Prospecting" |
| **Future Technologies Enabled** | Resonance tools (cutting, drilling, shaping implements using stored kinetic energy), Resonance detection (using crystals to locate other resonance sources — other islands, buried infrastructure, active stasis chambers), Energy storage (charging crystals from various energy sources for later use), Frequency tuning (modifying crystal resonance frequency for specific applications) |

#### Crystal Fragments (Large, High-Quality)

| Field | Value |
|-------|-------|
| **Name** | Crystal Fragments (Large) |
| **Category** | Crystals |
| **Description [O]** | Substantial crystal pieces — fist-sized or larger — with clearly visible internal structure. The hum is distinctly audible. The glow is visible even in moderate light. These are not fragments that have weathered off — they are purpose-grown crystals that were components of specific instruments or systems. |
| **Natural Origin [K]** | These are manufactured crystals — grown to specification in the Resonance Foundries for specific applications. Unlike the small fragments (which are infrastructure byproducts), these crystals were deliberately created as functional components. Each was designed for a specific resonance frequency, energy capacity, and application. |
| **Historical Origin [K]** | Large crystals were used in: the Great Telescope (optical and resonance-enhanced imaging elements), the Resonance Monitors (sensing elements for measuring array status), the Communication Array (signal generation and reception — now dark), the Stasis Sanctum chambers (the preservation field generators), and the Resonance Regulator (the control interface crystals). These were the precision instruments of Golden Age resonance technology — purpose-built, irreplaceable. |
| **Primary Districts** | Celestial Ring (telescope optics — the largest accessible high-quality crystals; Resonance Monitor components), Stasis Sanctum (stasis chamber arrays — visible but not removable without understanding the resonance locks; Regulator panel crystals) |
| **Secondary Districts** | Aviary (Glasshouse Ruins — some of the original environmental control crystals may still be present in the climate monitoring panels), Verdant Creep (Sunken Lab — monitoring equipment crystals, partially functional) |
| **Spawn Logic** | Large crystals are found in their original instrument or system contexts. They are not "spawned" — they are placed. Each has a specific location within a specific piece of Golden Age equipment. Some are removable (the player can extract a crystal from a non-functional instrument). Others are integral to still-functioning systems and cannot be removed without disabling the system (the player must choose: take the crystal and lose the system function, or leave it). |
| **Visual Characteristics [O]** | Larger than small fragments — fist-sized to head-sized. The internal structure is more visible: distinct growth layers, dopant concentration gradients visible as subtle color variations, the resonance-capable lattice planes visible as geometric patterns within the crystal. The glow is brighter — clearly visible in moderate light. The hum is a definite sound, not just a threshold perception. Some crystals have mounting brackets or contacts where they interfaced with instruments. |
| **Scarcity** | **Rare and non-renewable.** Each large crystal was purpose-manufactured. The total quantity on the Ark is fixed. Some are in still-functioning systems — removing them is a consequential decision. Others are in non-functional equipment — available but irreplaceable. |
| **Renewability** | **Non-renewable.** These crystals cannot be manufactured on the Ark. The knowledge and industrial infrastructure required (Resonance Foundry, crystal growth chambers, rare-earth doping) exist only on the larger industrial islands — specifically, the northern Foundry visible from the Celestial Ring. |
| **Environmental Requirements** | Proximity to Golden Age instruments and systems. Best-preserved crystals are in the Stasis Sanctum (environmental control). Most-weathered are in the Celestial Ring (exposure). |
| **Companion Resources** | The instruments they are part of (Ancient Components, Scientific Artifacts), Resonance Regulator and Monitors (systems designed to interface with these crystals), Ancient data (the instruments' output — data that may be readable with the right understanding) |
| **Common Player Mistakes** | Removing crystals from still-functioning systems without understanding the consequences (disabling the Resonance Monitors loses array status information; removing stasis chamber crystals could destabilize preserved specimens). Treating all large crystals as interchangeable — each was grown for a specific frequency and application; a telescope crystal and a stasis crystal are not equivalent. |
| **Codex Discoveries Enabled** | "Crystal Applications," "Resonance Frequency Specificity," "Precision Crystal Growth," "Instrument-Grade Crystals" |
| **Future Technologies Enabled** | Advanced resonance devices (tools and instruments requiring specific frequencies and high energy capacity), Resonance communication (if the Communication Array crystals are used to build or repair signaling devices), Stasis technology (understanding stasis chamber crystals is the prerequisite to opening sealed chambers and potentially to understanding the Empty Chamber), Navigation (crystals as resonance compasses — detecting other floating islands by their array signatures) |

#### Resonance Moss

| Field | Value |
|-------|-------|
| **Name** | Resonance Moss |
| **Category** | Crystals (Associated Organism) |
| **Description [O]** | A distinctive blue-green moss with a faint luminescence. Grows exclusively on or very near exposed resonance crystals. The moss appears to pulse — a very slow, subtle rhythm that matches the crystal's resonance frequency. When touched, the moss feels slightly warm. |
| **Natural Origin [K]** | Resonance Moss is a symbiotic organism that has evolved a unique metabolic relationship with resonance-active crystals. The moss absorbs the low-grade thermal and electromagnetic energy released by decaying resonance fields and uses it to supplement photosynthesis. This allows the moss to grow in conditions where other plants cannot — on bare stone, in darkness, in the high-exposure summit zone. The moss is not parasitic — it does not harm the crystals. The relationship is mutualistic: the moss stabilizes the crystal surface (reducing weathering) and in return receives energy. |
| **Historical Origin [K]** | The moss was first observed by Golden Age researchers as a curiosity — a species that grew preferentially on exposed resonance infrastructure. It was studied for: understanding of resonance-biology interactions, potential use as a resonance detector (the moss grows where resonance fields are active), and the philosophical implications (life adapting to use a novel physical force). The moss was not deliberately cultivated — it colonized the Ark naturally, likely arriving as wind-borne spores from the surface or from other floating islands. |
| **Primary Districts** | Verdant Creep (on exposed crystals near the Sunken Lab — the largest colonies), Celestial Ring (on the north face of the Standing Stones — the moss grows where the stones' crystal inclusions are exposed), Cascade Gardens (on small crystal fragments in retaining wall rubble) |
| **Secondary Districts** | Atrium (on fallen dome fragments — small colonies), Living Quarters (near the Director's resonance-locked chest — a small but healthy colony), Gatehouse (near the Quarantine Station door — on the resonance lock crystals) |
| **Spawn Logic** | Resonance Moss grows exclusively on or within a few centimeters of exposed resonance-active crystals. The moss does not grow on uncharged crystals (clear, no glow) — it requires the energy released by active resonance fields. The moss colonies are reliable indicators of hidden or buried crystals — the player learns to use the moss as a prospecting tool: "If there's moss, there's crystal underneath or nearby." |
| **Visual Characteristics [O]** | Blue-green color (#5A9890 to #3A7870), soft velvety texture, grows in circular patches 5–30cm in diameter. The luminescence is subtle — visible primarily in darkness. The pulsing rhythm is very slow (~10–15 second cycle) and matches the local resonance frequency. Healthy colonies are thick and vibrant; stressed colonies (low resonance, poor conditions) are thin and pale. |
| **Scarcity** | **Uncommon.** The moss exists wherever exposed resonance crystals exist — which is to say, wherever erosion has revealed the Ark's infrastructure. The total moss coverage on the island is small (perhaps 5–10 square meters across all colonies) but each colony is a reliable indicator of crystal presence. |
| **Renewability** | **Renewable (slowly).** The moss grows and spreads over time. Colonies expand as the moss covers more of the crystal surface. New colonies establish when spores land on newly exposed crystals. Growth rate is slow — colonies expand by millimeters per year. |
| **Environmental Requirements** | Resonance-active crystal surface (the primary requirement — no crystal, no moss). Moderate moisture (the moss needs some water but can survive drier conditions than other mosses due to its resonance energy supplement). The moss tolerates extreme exposure (the Celestial Ring colonies survive intense sun and wind that would kill other moss species). |
| **Companion Resources** | Crystal fragments (the substrate the moss grows on), Building stone (the matrix surrounding the crystals), The resonance hum (perceptible near moss colonies — the moss indicates where to listen) |
| **Common Player Mistakes** | Harvesting moss without noting the crystal underneath (the moss is the indicator — the player should mark the location for future crystal prospecting). Assuming the moss itself has resonance properties (it does not — it is a biological organism that uses resonance energy, not a resonance-active material itself). |
| **Codex Discoveries Enabled** | "Resonance-Biology Interactions," "Symbiotic Adaptation," "Bioluminescence," "Biological Indicators in Prospecting" |
| **Future Technologies Enabled** | Resonance detection (the moss as a prospecting tool — where moss grows, crystals are near), Cultivation (the player can transplant moss to test for hidden crystals in other locations), Light source (moss colonies provide faint illumination in darkness), Understanding of energy-biology interactions (the moss is a living demonstration that resonance energy can support biological processes — a principle relevant to understanding Dracula's unique physiology) |

---

## 10. ANCIENT COMPONENTS & ARTIFACTS

### 10.1 — ANCIENT COMPONENTS

#### Ancient Components

| Field | Value |
|-------|-------|
| **Name** | Ancient Components |
| **Category** | Ancient Components |
| **Description [O]** | Mechanical and structural parts from Golden Age equipment — gears, fasteners, brackets, housing fragments, lens elements, wiring remnants. Found in and around original Ark installations: instruments, cargo equipment, door mechanisms, laboratory apparatus. |
| **Natural Origin [K]** | NOT natural. These are manufactured components from the Ark's operational period. They are the physical remains of the technological infrastructure that supported the Ark's research mission — the parts that made the machines work. Their materials (brass, iron, crystal, glass, composite) and their precision (tolerances measured in fractions of a millimeter) reveal the sophistication of Golden Age manufacturing. |
| **Historical Origin [K]** | These components were part of: cargo handling equipment (Gatehouse), astronomical instruments (Celestial Ring), environmental control systems (Verdant Creep Sunken Lab), water management (Cascade Gardens sluice gates), laboratory apparatus (various districts), and the Ark's general infrastructure (doors, lighting, communication). They represent the material culture of the Golden Age — the physical tools through which scientific understanding was applied. |
| **Primary Districts** | Gatehouse (cargo cradle mechanisms, door hinges, reception desk fittings — the highest concentration of accessible mechanical components), Celestial Ring (telescope mountings, instrument housings, weather station mechanisms, communication array framework) |
| **Secondary Districts** | Cascade Gardens (sluice gate mechanisms, weather station instruments), Verdant Creep (Sunken Lab equipment — monitoring panels, climate control interfaces), Aviary (Propagation Station tools, environmental monitoring panels in the Glasshouse Ruins), Stasis Sanctum (Regulator panel components, chamber mechanisms — best preserved, most sophisticated) |
| **Spawn Logic** | Ancient components are found in and around their original equipment. Accessible components are those that: (a) are part of non-functional equipment (the Gatehouse cargo cradles are rusted and immobile — their fittings can be salvaged), (b) have separated from their parent equipment (fallen brackets, loose fasteners), (c) are in equipment the player deliberately disassembles (a conscious choice with consequences — disassembling a weather station means losing its data). |
| **Visual Characteristics [O]** | Highly variable. Brass components: warm gold-brown (#B89860) with green corrosion at edges. Iron components: dark brown rust (#8B5E3C), flaking surface. Crystal elements: clear to pale blue-white, often with mounting brackets. Glass lenses: clear to slightly clouded, in brass or composite frames. Composite materials: grey-beige, similar to structural stone but finer-textured and more precisely shaped. All show 5,000 years of aging — corrosion, wear, patina — but the original precision is still visible. |
| **Scarcity** | **Limited and non-renewable.** The total quantity of ancient components on the Ark is fixed — what was here at the time of abandonment. The player can salvage from non-functional equipment, but each salvage operation consumes a finite resource. Functional equipment (telescope, weather station, Resonance Monitors) should not be salvaged — the player loses the equipment's function. |
| **Renewability** | **Non-renewable.** Ancient components cannot be manufactured on the Ark. New components would require access to the Resonance Foundries — the industrial islands where Golden Age manufacturing occurred. |
| **Environmental Requirements** | Proximity to Golden Age equipment. Best-preserved components are in the Stasis Sanctum (environmental control). Most-corroded are in the Gatehouse (exposure). |
| **Companion Resources** | Metals (the material of many components), Crystals (included in optical and resonance components), Scientific artifacts (the complete instruments that components were part of), Forgotten technology (the larger systems that components belonged to) |
| **Common Player Mistakes** | Salvaging components from still-functional or repairable equipment (the Gatehouse cargo cradles are non-functional and can be salvaged; the Great Telescope is repairable and should not be). Not recognizing that different components have different properties and applications — a telescope gear and a sluice gate gear are both gears but not interchangeable. |
| **Codex Discoveries Enabled** | "Golden Age Manufacturing," "Mechanical Engineering of the First Delvers," "Materials Science of the Golden Age," "Instrument Making" |
| **Future Technologies Enabled** | Equipment repair (using salvaged components to fix damaged instruments — telescope, weather station, sluice gates), Tool crafting (precision components for advanced tools), Technology replication (understanding components well enough to create functional equivalents — even if less sophisticated — using local materials), Trade (ancient components as high-value trade goods with surface scholars and Deep-Born communities) |

### 10.2 — SCIENTIFIC ARTIFACTS

#### Scientific Artifacts

| Field | Value |
|-------|-------|
| **Name** | Scientific Artifacts |
| **Category** | Scientific Artifacts |
| **Description [O]** | Complete or near-complete Golden Age scientific instruments: the Great Telescope, the Resonance Monitors, the Weather Station instruments, the Propagation Station equipment, the Sunken Lab's monitoring panels, the Stasis Sanctum's Regulator. These are not resources to be harvested — they are **interactive systems** that can be studied, repaired, and (in some cases) reactivated. |
| **Natural Origin [K]** | Manufactured by Golden Age instrument makers — the precision engineering discipline that produced the Ark's scientific equipment. Each instrument was designed for a specific observational or analytical purpose, built to last centuries of continuous use, and (in many cases) still partially functional after 5,000 years. |
| **Historical Origin [K]** | These instruments were the tools through which the Ark's researchers understood the world — the telescopes that tracked celestial bodies, the monitors that tracked the island's health, the weather station that recorded climate data. They are the material embodiment of the scientific method as practiced during the Golden Age. |
| **Primary Districts** | Celestial Ring (Great Telescope, Resonance Monitors, Weather Station, Communication Array), Stasis Sanctum (Resonance Regulator, stasis chamber arrays, Data Vault), Verdant Creep (Sunken Lab monitoring panels, environmental control interfaces) |
| **Secondary Districts** | Cascade Gardens (Weather Station — smaller, agricultural-focused), Aviary (Propagation Station tools, Glasshouse climate monitors), Gatehouse (Quarantine Station equipment — sealed, inaccessible until resonance lock opened) |
| **Spawn Logic** | Scientific artifacts are placed — each in its original operational location. They are not "collectible" in the conventional sense (picking them up and putting them in inventory). They are **features** — interactive elements of the environment that the player can observe, study, repair, and use. |
| **Visual Characteristics [O]** | Each instrument has a distinct visual identity: the Great Telescope (large brass tube, crystal optics, precision mounting), the Resonance Monitors (glowing display panels, crystal sensor arrays, softly pulsing indicators), the Weather Station (rotating anemometer, glass barometer tubes, data recording drums), the Regulator (the most sophisticated interface on the Ark — glowing controls, crystal touchpoints, array status visualization). |
| **Scarcity** | **Unique.** Each scientific artifact is one of a kind on the Ark. There is one Great Telescope. One set of Resonance Monitors. One Regulator. They are irreplaceable. |
| **Renewability** | **Non-renewable.** These instruments cannot be replicated with the resources available on the Ark. |
| **Environmental Requirements** | Preservation in their original locations. The Celestial Ring instruments have survived 5,000 years of exposure — testament to Golden Age weatherproofing. The Sanctum instruments are in near-original condition — testament to active environmental control. |
| **Companion Resources** | Ancient components (the parts that make up the instruments), Crystals (included in optical and resonance instruments), Data (the records produced by these instruments — weather data, observation logs, resonance measurements), Forgotten technology (the instruments are part of larger technological systems) |
| **Common Player Mistakes** | Attempting to disassemble functional or repairable instruments for parts (the player can do this — but loses the instrument's function permanently). Not recognizing that instruments can be interacted with beyond simple examination (the telescope can be looked through, the monitors can be read, the Regulator can be accessed — these are interactive, not decorative). |
| **Codex Discoveries Enabled** | "Scientific Instrumentation of the Golden Age," "History of the Ark's Research Programs," "Precision Measurement," "The Ark's Instrument Network" |
| **Future Technologies Enabled** | Scientific research (the instruments, once understood, are the player's tools for systematic observation, measurement, and discovery), Navigation (telescope for identifying distant islands, weather station for planning expeditions), Resonance mastery (the Monitors and Regulator are the player's teachers for understanding resonance — the numbers are displayed; the player must learn to interpret them) |

### 10.3 — FORGOTTEN TECHNOLOGY

#### Forgotten Technology

| Field | Value |
|-------|-------|
| **Name** | Forgotten Technology |
| **Category** | Forgotten Technology |
| **Description [O]** | Systems and devices whose function is not immediately apparent. The Communication Array (dark, silent, pointed at the northern Foundry). The Quarantine Station equipment (visible through amber windows, purpose unclear). The sealed stasis chambers (humming, locked, contents unknown). The Resonance Core (hatch beneath the Celestial Ring, sealed, the source of the island's deepest hum). |
| **Natural Origin [K]** | These are Golden Age technologies operating at the upper boundary of that civilization's capabilities — systems whose operating principles are not obvious from visual inspection. They represent knowledge that has been lost to the surface world and can only be recovered through systematic study. |
| **Historical Origin [K]** | Each represents a specific domain of Golden Age mastery: communication (the Array — inter-island signaling using resonance carrier waves), containment (the Quarantine Station — biological isolation technology), preservation (the stasis chambers — resonance-based metabolic suspension), lift and stability (the Resonance Core — the island's primary crystal arrays). |
| **Primary Districts** | Celestial Ring (Communication Array, Resonance Core hatch), Stasis Sanctum (sealed stasis chambers, the Empty Chamber, the Regulator's locked control functions), Gatehouse (Quarantine Station — sealed, inaccessible) |
| **Secondary Districts** | Verdant Creep (Sunken Lab — partially functional environmental controls, sealed dome fragments), Cascade Gardens (the reservoir lift mechanism — broken, purpose unclear without examination) |
| **Spawn Logic** | Forgotten technology is placed in specific locations. Each represents a progression gate — the player can see it, can interact with it to a limited extent, but cannot fully access or operate it without understanding the underlying principles. |
| **Visual Characteristics [O]** | The defining visual characteristic is **incomprehensibility with hints of function**. The Communication Array is clearly an antenna of some kind — but pointed at another island, not the sky. The stasis chambers are clearly containers — but the preservation field shimmer is unlike any other visual effect on the Ark. The Resonance Core hatch is clearly a door — but the resonance lock's glow is the strongest on the island. Each piece of forgotten technology invites the question: *"What does this do? How does it work? How do I access it?"* |
| **Scarcity** | **Unique.** Each forgotten technology is one of a kind on the Ark. |
| **Renewability** | **Non-renewable / Not applicable.** These are features, not consumable resources. |
| **Environmental Requirements** | Their original locations. Each is integral to the district that houses it. |
| **Companion Resources** | Crystals (the active elements in most forgotten technology), Ancient components (the physical parts), Scientific artifacts (the instruments that interface with or monitor these systems), Data (records of what these systems did — maintenance logs, operational parameters) |
| **Common Player Mistakes** | Attempting to force access (the Quarantine Station door cannot be forced — the scratch marks from a previous attempt are visible; the stasis chambers cannot be pried open — the resonance locks are sophisticated). Not recognizing that understanding is the key — these are not locks to be picked but principles to be learned. |
| **Codex Discoveries Enabled** | "Lost Technologies of the Golden Age," "Resonance Applications," "Inter-Island Communication," "Biological Preservation Technology" |
| **Future Technologies Enabled** | Each forgotten technology, once understood, unlocks a major game capability: Communication Array → inter-island contact; stasis chambers → genetic archive access; Resonance Core → island mobility; Quarantine Station → biological samples and medical technology; Empty Chamber → the central mystery of Dracula's identity and memory |

### 10.4 — UNKNOWN MATERIALS

#### Unknown Materials

| Field | Value |
|-------|-------|
| **Name** | Unknown Materials |
| **Category** | Unknown Materials |
| **Description [O]** | Substances and objects that resist immediate classification — materials whose properties do not match any known category. The shimmering substance lining the stasis chambers. The dark crystalline material of the Communication Array's dish. The residue in the Empty Chamber. The amber glass of the Quarantine Station windows. The resonance-stabilized composite of the structural stone itself (before the player understands its nature). |
| **Natural Origin [K]** | These materials represent the frontier of Golden Age materials science — substances engineered at the molecular level for specific properties. They are not "magic" — they operate by consistent physical principles. But those principles are not immediately obvious. The player's understanding of these materials evolves as their Codex grows. |
| **Historical Origin [K]** | Manufactured in Golden Age facilities using techniques that are not replicable on the Ark. The knowledge required to create them is among the most valuable lost knowledge in the game world — recovering it is a major long-term goal. |
| **Primary Districts** | Stasis Sanctum (stasis field substrate, chamber materials, Regulator interface), Celestial Ring (Communication Array dish material, Standing Stone crystal inclusions), Gatehouse (Quarantine Station amber glass) |
| **Spawn Logic** | Unknown materials are found in their original technological contexts. They are not harvestable in early game — the player lacks the tools and understanding to extract or work with them. |
| **Visual Characteristics [O]** | The defining visual characteristic is **difference** — these materials look unlike anything else on the Ark. The stasis field substrate: a metallic-crystalline hybrid that seems to shift between states. The Communication Array dish: a material that absorbs light rather than reflecting it — appearing as a dark shape even in direct sun. The amber glass: transparent but with a depth that suggests layers of different materials laminated together. The Empty Chamber residue: a faint crystalline deposit that glows with the same frequency as the chamber's stasis field. |
| **Scarcity** | **Very rare.** Each unknown material exists in specific technological contexts. The total quantity on the Ark is small. |
| **Renewability** | **Non-renewable.** These materials require industrial infrastructure to manufacture. |
| **Environmental Requirements** | Their original technological contexts. |
| **Companion Resources** | Crystals (often the active or structural element in unknown materials), Forgotten technology (the systems that incorporate these materials), Data (records describing their properties — if the player can find and decode them) |
| **Common Player Mistakes** | Assuming these materials are "magic" or unexplainable (they are not — everything in this world has a physical explanation). Attempting to use them without understanding (the materials have specific properties and requirements — using them incorrectly can be ineffective or dangerous). |
| **Codex Discoveries Enabled** | "Advanced Materials of the Golden Age," "Resonance-Enhanced Materials," "Molecular Engineering," "The Limits of Golden Age Science" |
| **Future Technologies Enabled** | Understanding these materials is a late-game pursuit. They are the key to: advanced resonance devices, stasis technology, inter-island communication, and potentially to understanding Dracula's own altered physiology. |

---

## 11. RESOURCE ECOLOGY — THE LIVING WEB

### 11.1 — The Principle of Ecological Interconnection

No resource on the Ark exists in isolation. Every material is connected to others through ecological relationships: one resource creates the conditions for another, consumes another, transforms into another, or depends on another. The player who understands these relationships understands the island.

### 11.2 — The Water Web

```
RAIN
 │
 ▼
CENTRAL RESERVOIR ──→ Fresh Water
 │
 ├──→ Irrigation Channels ──→ Clay (deposited at edges)
 │         │
 │         ▼
 │    Terrace Vegetation ──→ Wild Grains, Medicinal Herbs, Fibers
 │         │
 │         ▼
 │    Settling Pools ──→ Clay, Aquatic Plants, Amphibians
 │         │
 │         ▼
 │    Cistern ──→ Atrium Fountain ──→ Bioluminescent Moss
 │
 └──→ Evaporation ──→ Rain (cycle continues)
```

**Key relationships:**
- Water transports clay particles — without water flow, clay deposits would not form.
- Water creates the moisture gradient that determines plant species distribution.
- The fountain's constant moisture enables the bioluminescent moss colony.
- Stagnant water (Gatehouse puddles) lacks the filtration of flowing water — quality difference teaches water management.

### 11.3 — The Soil Web

```
STRUCTURAL STONE (Weathering)
 │
 ├──→ Sand/Grit (physical weathering — wind, freeze-thaw)
 │     │
 │     └──→ Clay (chemical weathering — acid rain)
 │
 └──→ Minerals (released by stone breakdown)

ORGANIC INPUT (Plant growth and death)
 │
 ├──→ Leaf Litter
 │     │
 │     └──→ Humus (fungal and bacterial decomposition)
 │           │
 │           └──→ Soil fertility ──→ Plant growth (cycle continues)
 │
 └──→ Wood (branch fall, tree death)
       │
       └──→ Rotting Wood ──→ Fungi ──→ Humus
```

**Key relationships:**
- Soil is created by the interaction of geological processes (stone weathering) and biological processes (organic matter decomposition).
- The deepest, richest soil (Verdant Creep) results from maximum vegetation input + maximum decomposition.
- The thinnest soil (Celestial Ring) results from minimum vegetation input + maximum wind erosion.
- Stone weathering alone would produce only mineral soil — it's the organic input that makes it fertile.

### 11.4 — The Forest Web

```
MATURE TREES
 │
 ├──→ Living Wood (standing trees — not harvestable)
 ├──→ Fallen Branches ──→ Wood ──→ Rotting Wood ──→ Fungi ──→ Humus
 ├──→ Leaf Litter ──→ Humus
 ├──→ Canopy Shade ──→ Shade-Tolerant Plants (ferns, mosses, some medicinals)
 ├──→ Root Systems ──→ Stone Cracking (exposes minerals, crystals)
 └──→ Habitat ──→ Birds, Insects, Escapees
       │
       └──→ Feathers, Insect Specimens, Animal Products
```

**Key relationships:**
- Trees are ecosystem engineers — they create the conditions for other species.
- Tree roots accelerate stone weathering — more trees = faster crystal and mineral exposure.
- The Courtyard Tree, canopy trees, and specimen trees each support different understory communities.
- Tree death (rare but significant) creates a pulse of resources — wood, fungi, insects, eventually humus.

### 11.5 — The Pollination Web

```
FLOWERING PLANTS ←────────────────┐
 │                                 │
 ├──→ Nectar ──→ Bees ──→ Honey ──┤ (pollination)
 ├──→ Pollen ──→ Bees, Butterflies, Moths ──┘
 ├──→ Seeds ──→ Birds ──→ Seed Dispersal ──→ New Plants
 └──→ Habitat ──→ Pollinator Insects ──→ Bird Food ──→ Feathers
```

**Key relationships:**
- Flowering plants and pollinators are mutually dependent — neither can persist without the other.
- The Aviary's high flower diversity supports the highest pollinator density — which in turn supports the Cascade Gardens' crop fertility.
- Seed dispersal by birds spreads plant species beyond their original planting areas.
- The bee population's health is directly tied to flower diversity and abundance — a catastrophic flower loss would starve the bees.

### 11.6 — The Decomposition Web

```
DEAD ORGANIC MATTER (Wood, Leaves, Insects, Animals)
 │
 ├──→ Fungi ──→ Decomposition ──→ Humus
 │     │                            │
 │     └──→ Mushrooms ──→ Food, Medicine
 │
 ├──→ Bacteria ──→ Decomposition ──→ Humus
 │
 ├──→ Insects (Beetles, Millipedes, Springtails) ──→ Decomposition ──→ Humus
 │     │
 │     └──→ Insect Specimens, Bird Food
 │
 └──→ Humus ──→ Plant Growth ──→ More Dead Organic Matter (cycle continues)
```

**Key relationships:**
- Decomposition is not decay — it is transformation. Dead matter becomes living soil.
- Fungi are the primary decomposers of wood; bacteria dominate leaf litter decomposition; insects fragment and mix.
- The decomposition web is most active in the Verdant Creep (warmth, moisture, abundant input) and least active on the Celestial Ring (cold, dry, minimal input).
- Harvesting fungi or humus removes nutrients from the decomposition cycle — sustainable harvesting maintains the cycle; over-harvesting depletes it.

### 11.7 — The Resonance Web

```
RESONANCE ARRAYS (Island Infrastructure)
 │
 ├──→ Crystal Weathering ──→ Crystal Fragments (Small)
 │     │
 │     └──→ Resonance Moss Growth
 │
 ├──→ Resonance Hum/Vibration ──→ Moss Growth Stimulus
 ├──→ Thermal Micro-Warmth ──→ Microclimate for Crystal-Associated Species
 └──→ Electromagnetic Fields ──→ Navigation Cue for Migratory Species(?)
```

**Key relationships:**
- The resonance arrays are the island's energy foundation — their slow decay produces effects that organisms have adapted to.
- Resonance Moss is the most visible example of biological adaptation to resonance.
- The thermal micro-warmth near array housings may explain why certain plant species (the Aviary's most cold-sensitive specimens) survived in locations that should be too cold for them.
- The resonance hum is a constant environmental factor — organisms on the Ark have lived with it for 5,000 years and may depend on it in ways the player can discover.

### 11.8 — The Archaeological Web

```
GOLDEN AGE INFRASTRUCTURE
 │
 ├──→ Structural Stone ──→ Building Stone, Weathered Stone
 ├──→ Mechanical Systems ──→ Ancient Components, Metals
 ├──→ Scientific Instruments ──→ Scientific Artifacts, Crystals (Large)
 ├──→ Resonance Systems ──→ Crystals, Resonance Moss, Unknown Materials
 ├──→ Information Systems ──→ Data Records, Observation Logs, Codex Entries
 └──→ Biological Archives ──→ Seeds (Ancient), The Core Seed Bank (inaccessible)
```

**Key relationships:**
- Archaeological resources are concentrated where Golden Age activity was concentrated — the Gatehouse (transport), the Cascade Gardens (agriculture), the Celestial Ring (observation), the Sanctum (preservation).
- The condition of archaeological resources reflects environmental exposure — Sanctum resources are pristine; Gatehouse resources are weathered.
- Archaeological resources are finite — the Ark was abandoned with a fixed quantity of equipment. The player's use of these resources is a form of non-renewable extraction in most cases.
- Understanding the archaeological web means understanding the Ark's original function — the player who knows why a district was built can predict what resources it contains.

---

## 12. RESOURCE CHAINS — NATURAL PROGRESSION

### 12.1 — The Principle of Resource Chains

Resource chains are natural sequences where understanding one material enables the discovery, extraction, or creation of another. These are not "tech trees" — they are logical progressions based on material properties and real-world physics. The player who understands the chain can innovate within it. The player who merely follows it has learned recipes, not principles.

### 12.2 — The Fire Chain

```
Wood (Fallen Branches)
  ↓ Understanding: dry wood burns; moisture content affects combustion
Fire (Observation: friction, spark, or focused sunlight)
  ↓ Understanding: fire transforms materials — removes water, drives chemical reactions
Charcoal (Wood heated without oxygen)
  ↓ Understanding: charcoal burns hotter and cleaner than wood; essential for high-temperature work
High Heat
  ↓ Understanding: different materials melt, soften, or transform at different temperatures
Glass (Sand + High Heat + Understanding of cooling rates)
  ↓ Understanding: glass is transparent, can be shaped, can focus light
Lens
  ↓ Understanding: curved transparent materials bend light; focal length determines magnification
Microscope / Telescope
  ↓ Understanding: the very small and the very distant become observable
New Observations → New Questions → New Understanding
```

**What this chain teaches:**
- Fire → Charcoal: The relationship between heat, oxygen, and material transformation.
- Charcoal → High Heat: The relationship between fuel quality and achievable temperature.
- High Heat → Glass: The relationship between heat and material state change (solid → liquid → solid).
- Glass → Lens: The relationship between shape and optical properties.
- Lens → Microscope/Telescope: How tools extend human perception beyond biological limits.
- The entire chain: Science is cumulative — each discovery enables the next.

### 12.3 — The Ceramic Chain

```
Clay (Settling pool deposits)
  ↓ Understanding: wet clay is plastic; dry clay is hard but brittle; firing transforms it permanently
Kiln (Clay + Stone + High Heat understanding)
  ↓ Understanding: a kiln concentrates and retains heat; temperature control determines outcomes
Ceramic Vessels
  ↓ Understanding: fired clay is waterproof, heat-resistant, chemically inert
Storage (Seeds, Water, Food, Materials)
  ↓ Understanding: reliable storage enables planning beyond immediate needs
Agriculture (Stored seeds + Cultivation understanding)
  ↓ Understanding: annual cycles; soil management; selective breeding
Food Security → Population Support → Specialization → Knowledge Growth
```

**What this chain teaches:**
- Clay → Kiln: The relationship between material properties and tool design (you need to understand clay to build a kiln from it).
- Kiln → Ceramic Vessels: How heat transforms materials permanently — the difference between drying (reversible) and firing (irreversible).
- Storage → Agriculture: How technology enables new social organizations — stored surplus allows planning for next season.
- The entire chain: Technology and civilization are intertwined — advances in one enable advances in the other.

### 12.4 — The Medicine Chain

```
Observation: This plant grows near water. This animal avoids that plant. This berry makes me feel different.
  ↓ Understanding: plants have properties that affect animal physiology
Collection: Medicinal Herbs, specific plant parts
  ↓ Understanding: active compounds concentrate in specific tissues (leaves, roots, flowers)
Preparation: Drying, crushing, steeping, boiling
  ↓ Understanding: preparation method affects compound extraction and potency
Herbal Medicine
  ↓ Understanding: dosage, combination, contraindication
Pharmacology: Isolation and concentration of active compounds
  ↓ Understanding: the molecule, not the plant, produces the effect
Advanced Medicine: Targeted treatments, resonance-enhanced drug delivery
```

**What this chain teaches:**
- Observation → Collection: The scientific method begins with noticing patterns in nature.
- Collection → Preparation: Properties are not the same as applications — the plant must be processed correctly.
- Preparation → Herbal Medicine: Trial and error, systematically recorded, produces reliable treatments.
- Herbal Medicine → Pharmacology: The transition from whole-plant medicine to isolated compounds — more powerful, more precise, more dangerous if misused.
- The entire chain: Medicine is applied botany and chemistry — understanding the plant and the body produces healing.

### 12.5 — The Resonance Chain

```
Observation: This crystal hums. It glows. It feels warm.
  ↓ Understanding: the crystal is storing and releasing energy
Collection: Crystal Fragments (Small)
  ↓ Understanding: different crystals have different frequencies, capacities, and applications
Basic Resonance Tools: Crystal-enhanced cutting edges, resonance detectors
  ↓ Understanding: resonance fields interact with matter in predictable ways
Resonance Lock Manipulation: Opening the Quarantine Station, sealed chambers
  ↓ Understanding: each lock is tuned to a specific frequency — matching it requires measurement and adjustment
Array Theory: How multiple crystals interact; energy distribution; stability
  ↓ Understanding: the island's lift comes from a coordinated array, not individual crystals
Resonance Core Access → Island Mobility → Inter-Island Navigation
```

**What this chain teaches:**
- Observation → Collection: The same scientific method, applied to a novel physical phenomenon.
- Basic Tools → Lock Manipulation: Theory enables application — you can't open a resonance lock by guessing frequencies.
- Lock Manipulation → Array Theory: Individual crystals are components; the system emerges from their interaction.
- Array Theory → Island Mobility: Understanding the system enables control of the system.
- The entire chain: Resonance is not magic — it is physics that can be understood, measured, and applied.

### 12.6 — The Knowledge Chain (Meta-Progression)

```
Observation → Journal Entry
  ↓
Pattern Recognition → Hypothesis Formation
  ↓
Experimentation → Hypothesis Testing
  ↓
Confirmation → Codex Knowledge Entry
  ↓
Knowledge Connection → Cross-Reference with Related Knowledge
  ↓
Deep Understanding → Predictive Capability, Creative Application
  ↓
Teaching → NPC Adoption → Civilization Change
```

**What this meta-chain teaches:**
- Science is a method, not a body of facts.
- Knowledge compounds — each piece makes the next piece easier to acquire.
- Understanding is personal — two players with different observation histories will have different knowledge, different capabilities, different Codex entries.
- Teaching transforms individual knowledge into collective capability.

---

## 13. PLAYER DISCOVERY SYSTEMS

### 13.1 — How Players Discover Resources

Resources on the Ark are never marked by UI elements. The player discovers them through:

#### Direct Observation
**What it is:** The player sees something interesting and examines it.
**Example:** Walking through the Cascade Gardens, the player notices a cluster of purple berries on a bush. They approach, examine, and the Journal records the observation. They can now collect the berries.
**What it teaches:** Attention is rewarded. The world contains visible information.

#### Pattern Recognition
**What it is:** The player notices that a resource consistently appears in specific conditions.
**Example:** Over several expeditions, the player notices that medicinal Type 1 herbs always grow near water in shaded areas. They form a hypothesis: "Type 1 herbs require damp shade." They test it by looking for similar conditions elsewhere — and find new herb patches they had previously overlooked.
**What it teaches:** Understanding ecology makes the world predictable.

#### Environmental Indicators
**What it is:** One resource signals the presence of another.
**Example:** The player learns that Resonance Moss only grows on resonance-active crystals. Seeing moss on a stone surface tells them: there is crystal underneath or nearby. The moss becomes a prospecting tool.
**What it teaches:** Species have relationships. Reading those relationships reveals hidden resources.

#### Animal Behavior
**What it is:** Animals reveal resources through their behavior.
**Example:** Watching birds in the Aviary, the player notices they consistently visit a specific area of the upper arches. Investigating reveals the bee hives and honey. The birds are feeding on bees — their behavior led to a resource.
**What it teaches:** Animals know things the player doesn't. Observation of animal behavior is a form of ecological research.

#### Weather and Season
**What it is:** Resource availability changes with weather and season.
**Example:** Mushrooms appear after rain. Berries ripen in specific seasons. Grain is harvestable in autumn. The player who understands seasonal cycles plans their resource gathering accordingly.
**What it teaches:** The world has rhythms. Working with them is more effective than fighting them.

#### Historical Knowledge
**What it is:** Reading or decoding Golden Age records reveals resource locations and uses.
**Example:** Finding a cargo manifest in the Gatehouse that lists "Medicinal Herbs — Type 2 — Shipped from Cascade Terrace 4." The player goes to Terrace 4 and finds the descendants of those herbs.
**What it teaches:** The past has information the present can use. Archaeology is practical.

#### Geological Understanding
**What it is:** Understanding how geological processes concentrate materials.
**Example:** Learning that clay deposits form where slow-moving water allows fine particles to settle. The player then knows to look for clay at settling pool edges, not in fast-flowing channels.
**What it teaches:** Geology determines resource distribution. Understanding geology makes you a better prospector.

#### Experimentation
**What it is:** Trying things and observing the results.
**Example:** The player wonders if the Courtyard Tree's bark has medicinal properties. They harvest some, prepare it different ways, and test each preparation. One method produces a useful medicine. The discovery was not taught — it was made.
**What it teaches:** The scientific method. Ask a question. Design a test. Observe the result. Learn.

### 13.2 — What the Player Never Sees

- **Sparkle effects** on resources.
- **Glowing outlines** indicating collectible objects.
- **Minimap icons** for resource nodes.
- **"Press E to collect" prompts** before the player has examined the object.
- **Color-coded rarity indicators.**
- **Resource radar or scanning abilities** that reveal hidden materials.
- **Quantity counters** for how many of a resource exist on the island.

The player finds resources because they paid attention, understood the ecology, and looked in the right place. The game provides the information; the player provides the attention.

---

## 14. SCIENTIFIC DISCOVERY PER RESOURCE

### 14.1 — What Every Resource Teaches

| Resource | Scientific Principle | How the Player Discovers It |
|----------|---------------------|---------------------------|
| **Building Stone** | Composite materials can be stronger and lighter than their components | Examining fractured edges reveals the composite structure; comparing weight to expected stone weight |
| **Weathered Stone** | Physical and chemical weathering break down even engineered materials over time | Observing stone at different stages of weathering across the island |
| **Clay** | Sedimentation sorts particles by size; the finest particles settle last | Observing clay deposits at pool edges vs sand in channels |
| **Sand / Grit** | Wind erosion produces uniform particle sizes through selective transport | Comparing Gatehouse wind-deposited sand to Cascade water-deposited sand |
| **Metallic Debris** | Oxidation (rust, patina) is a chemical reaction between metal and environment | Observing different corrosion on iron (rust) vs copper (patina) vs brass (mixed) |
| **Wood** | Different tree species produce wood with different structural properties | Comparing Courtyard Tree wood (dense, strong) to canopy tree wood (lighter, flexible) |
| **Wild Grains** | Domestication is reversible — feralization returns crops toward wild characteristics | Comparing feral grain characteristics to the cultivated grains described in Golden Age texts |
| **Edible Berries** | Fruit color, size, and timing are adaptations for specific seed dispersers | Observing which birds eat which berries; correlating color with disperser type |
| **Wildflowers** | Flower color and shape are signals evolved to attract specific pollinators | Observing which insects visit which flowers; correlating flower characteristics with pollinator type |
| **Seeds** | Dormancy is an adaptation that allows seeds to survive unfavorable conditions | Discovering that ancient seeds require specific treatments to germinate |
| **Medicinal Herbs** | Plant secondary metabolites are chemical defenses that happen to affect human physiology | Correlating herb characteristics (smell, taste, location) with medicinal effects |
| **Plant Fibers** | Plant cell structure determines fiber properties — long cells for strength, fine cells for softness | Comparing fiber characteristics from different source plants |
| **Bird Feathers** | Feather structure is an adaptation for flight, insulation, and display | Examining different feather types (wing vs down) and correlating with function |
| **Honey / Nectar** | Enzyme processing and dehydration transform perishable nectar into stable honey | Observing the honey-making process at the Aviary hives over time |
| **Insect Specimens** | Insect diversity reflects habitat diversity — more habitats = more species | Comparing insect populations across districts |
| **Rich Humus** | Decomposition is a biological process that transforms dead matter into living soil | Observing the decomposition gradient from fresh leaf litter to finished humus |
| **Fungi** | The visible mushroom is the fruiting body — the actual organism is the underground mycelium | Digging beneath mushrooms to discover the mycelial network |
| **Rotting Wood** | Wood decomposition is a succession process — different organisms dominate at different stages | Examining rotting logs of different ages and identifying the species present |
| **Fresh Water** | The water cycle involves collection, distribution, use, and return | Tracing the complete water path from reservoir to fountain |
| **Crystal Fragments** | Crystal lattice structure determines resonance properties — same chemistry, different structure, different behavior | Comparing charged crystals (active lattice) to uncharged crystals (inactive or different lattice) |
| **Resonance Moss** | Organisms can evolve to use novel energy sources | Observing moss growth patterns and correlating with crystal proximity and charge state |
| **Ancient Components** | Precision manufacturing requires standardized measurement and quality control | Comparing identical components (two brackets from the same cargo cradle) — they are interchangeable, revealing standardization |
| **Scientific Artifacts** | Instruments extend human perception — they don't create data, they reveal it | Using the telescope to see what the naked eye cannot |
| **Forgotten Technology** | Complex systems can be understood by analyzing their components and interactions | Studying the Resonance Monitors — the relationship between crystal sensors, display panels, and the array infrastructure |
| **Unknown Materials** | Apparent magic is just physics you haven't understood yet | Every unknown material has consistent, observable properties — the player learns them through systematic observation |

---

## 15. RARITY DESIGN

### 15.1 — The Principle of Ecological Scarcity

Rarity on the Ark is never arbitrary. A resource is rare because:

| Scarcity Driver | Example | Ecological/Historical Logic |
|-----------------|---------|---------------------------|
| **Limited formation conditions** | Clay requires: stone weathering + water transport + still water deposition. Only the settling pools provide all three. | The resource can only form where specific conditions coincide. |
| **Slow production rate** | Crystal fragments are produced by weathering of resonance infrastructure — millimeters per century. | The resource is produced continuously but very slowly. |
| **Specialized habitat requirements** | Medicinal Type 3 herb requires saturated soil — found only at the water's edge of pools. | The resource can only grow in a narrow ecological niche. |
| **Finite historical supply** | Ancient components exist in fixed quantity from the Golden Age — no new ones are being made. | The resource is a non-renewable inheritance from the past. |
| **Ecological dependency** | Honey depends on: healthy bee population + diverse flowering plants + suitable nesting sites. If any factor fails, honey production stops. | The resource exists only while a complex ecological web remains intact. |
| **Seasonal availability** | Seeds are abundant in autumn, scarce in spring. The resource is common but only at specific times. | The resource follows a natural cycle — availability windows create strategic decisions. |

### 15.2 — The Scarcity Spectrum

Rather than arbitrary tiers (Common/Rare/Epic/Legendary), resources exist on a spectrum defined by ecological constraints:

| Scarcity Level | Defining Characteristics | Examples |
|----------------|------------------------|----------|
| **Ubiquitous** | Forms the physical substrate of the island. Available everywhere but requires effort to extract in usable form. | Building Stone, Weathered Stone |
| **Abundant** | Continuously produced by ongoing ecological processes. Reliable supply with seasonal variation. | Water, Wood (fallen branches), Wild Grains (seasonal), Leaves/Humus |
| **Common** | Widely distributed but concentrated in specific habitats. Requires knowledge of habitat preferences to find reliably. | Sand/Grit, Edible Berries, Wildflowers (common species), Insect Specimens |
| **Uncommon** | Restricted to specific ecological niches. Limited total quantity. Requires understanding of ecology to locate. | Clay, Medicinal Herbs, Plant Fibers (specific types), Bird Feathers (specific species), Resonance Moss |
| **Rare** | Very limited formation conditions OR finite historical supply. Each occurrence is significant. | Crystal Fragments (Large), Metals (specific types), Honey (sustainable yield limited), Fungi (rare species), Ancient Components (specific parts) |
| **Unique** | One of a kind on the Ark. Irreplaceable. | Scientific Artifacts (each is unique), Forgotten Technology (each system is one of a kind), Unknown Materials (each type exists in limited context) |

### 15.3 — Strategic Value vs Scarcity

Some common resources become strategically valuable because of their role in resource chains:

| Resource | Scarcity | Strategic Value | Why |
|----------|----------|-----------------|-----|
| **Sand** | Common | HIGH (late game) | Essential for glassmaking → lenses → microscope/telescope. Common resource, irreplaceable application. |
| **Wood** | Abundant | MODERATE (consistent) | Needed throughout the game for tools, construction, fuel. Abundance doesn't reduce importance. |
| **Clay** | Uncommon | HIGH (mid game) | Essential for ceramics → storage → agriculture. The bottleneck for the entire ceramic chain. |
| **Crystal Fragments (Small)** | Uncommon | VERY HIGH (all stages) | Required for any resonance application. The gateway to the resonance chain. |
| **Honey** | Uncommon | MODERATE | Valuable for food, medicine, fermentation — but substitutes exist for most uses. |
| **Ancient Components** | Rare | HIGH (late game) | Required for repairing scientific instruments. Irreplaceable without access to industrial islands. |

---

## 16. WORLD EVOLUTION — RESOURCES OVER TIME

### 16.1 — The Principle of Dynamic Resources

The Ark is not a static resource map. It is a living ecosystem where resources change over time. The player's actions affect this evolution. The passage of time (through the game's sleep mechanics) reveals changes.

### 16.2 — Short-Term Changes (Days to Seasons)

| Change | Timescale | Effect on Resources |
|--------|-----------|-------------------|
| **Weather events** | Hours to days | Storms cause branch fall (more wood). Rain triggers fungal fruiting (more mushrooms). Drought reduces water flow (less clay deposition). |
| **Seasonal cycles** | Seasons (~100 in-game days each) | Spring: seed germination, flowers blooming (peak flower/pollen). Summer: fruit ripening (peak berries), insect activity (peak specimens). Autumn: grain harvest, seed production (peak seeds), leaf fall (peak humus input). Winter: dormancy (minimal plant resources), reduced water flow, bees dormant (no honey access). |
| **Day/night cycle** | ~26 minutes | Night: bioluminescent resources visible (moss, fungi, Memory Garden flower). Day: color-based plant identification possible. Dusk/dawn: specific animal behaviors observable. |
| **Player harvesting** | Immediate | Over-harvesting depletes local supply (regenerates over seasons to years). Sustainable harvesting maintains supply. Cultivation increases supply. |

### 16.3 — Medium-Term Changes (Years to Decades)

| Change | Timescale | Effect on Resources |
|--------|-----------|-------------------|
| **Plant succession** | Years to decades | Pioneer species give way to climax species. Medicinal herbs may be outcompeted by aggressive colonists. The player can intervene (weeding, cultivating) to maintain desired species. |
| **Tree growth** | Decades | Saplings mature. Wood supply from specific species increases over time. The Courtyard Tree continues to grow — more branch fall, more root penetration, more stone cracking (exposing crystals). |
| **Soil development** | Decades | Humus accumulation in areas of high organic input. Erosion in exposed areas. The player's cultivation activities accelerate soil development in managed areas. |
| **Crystal weathering** | Decades | New small fragments exposed as structural stone continues to weather. Existing fragments may be buried by soil accumulation. |
| **Colony growth/decline** | Years to decades | Bee colonies may expand or collapse based on flower availability and player harvesting. Bird populations shift nesting sites. Moss colonies expand slowly. |

### 16.4 — Long-Term Changes (Centuries)

| Change | Timescale | Effect on Resources |
|--------|-----------|-------------------|
| **Tree life cycles** | Centuries | Mature trees eventually die. A canopy tree death in the Verdant Creep creates a major resource pulse — massive wood, decades of fungal succession, a canopy gap that changes the understory for a century. |
| **Structural decay** | Centuries | The island's edges continue to spall. New areas of exposed structural stone appear. Retaining walls continue to crumble — new crystal fragments become accessible. |
| **Resonance decay** | Centuries | The crystal arrays continue their 0.03%/millennium decay. The resonance hum slowly changes frequency. Moss colonies shift in response. |
| **Climate variation** | Centuries | Natural climate cycles (recorded in the 5,000-year weather data) shift temperature and precipitation patterns. Plant communities shift in response — some species expand, others contract. |
| **Soil depth** | Centuries | Humus continues to accumulate in the Basin zone. The Summit zone remains essentially soil-free. The contrast between zones intensifies. |

### 16.5 — Player-Driven Changes

| Action | Effect | Reversibility |
|--------|--------|---------------|
| **Sustainable harvesting** | Resource supply maintained. Ecosystem health preserved. | Default state — the player learns this approach. |
| **Over-harvesting** | Local depletion. Regeneration takes seasons to decades. Bee colony collapse may be permanent (requires new colony establishment). | Reversible over time for most resources. Irreversible for unique resources. |
| **Cultivation** | Increases supply of cultivated species. Changes local ecology — cultivated plants may outcompete wild neighbors. | Deliberate — the player chooses what to encourage. |
| **Extinction (local)** | Harvesting every individual of a species from the Ark eliminates it. Cannot be restored without reintroduction from the surface or other islands. | Irreversible without external source. The game does not prevent this but communicates the significance. |
| **Infrastructure repair** | Repairing sluice gates changes water distribution — some areas get more water, others less. Plant communities shift in response. Repairing the telescope enables new observations but consumes Ancient Components. | Deliberate — the player weighs costs and benefits. |
| **Stasis chamber opening** | Opening a sealed chamber releases preserved genetic material into the Ark's ecosystem. Species extinct on the surface (or on the Ark) may be reintroduced. | Irreversible — once released, species cannot be re-sealed. |

---

## 17. DESIGN VERIFICATION MATRIX

### 17.1 — The Five Questions

Every resource must answer five questions. This matrix verifies that each category satisfies all five.

| Category | Why Here? | How Formed? | What Ecosystem? | Who Used It? | Why Still Here? |
|----------|-----------|-------------|-----------------|-------------|-----------------|
| **Stone** | The island's structural material — it IS the island | Manufactured in Golden Age Foundries; emplaced during construction | Forms the physical substrate all other resources depend on | Golden Age engineers — every structure on the Ark | 5,000 years of slow weathering; structurally stable for tens of millennia more |
| **Minerals (Clay, Sand)** | Products of stone weathering concentrated by water and wind | Physical and chemical weathering of structural stone; transport and deposition by water/wind | The water cycle and wind patterns determine distribution | Golden Age agronomists and potters | Continuous (slow) production by ongoing weathering |
| **Metals** | Manufactured components brought to the Ark during construction and operation | Smelted and forged in Golden Age industrial facilities | Not part of a living ecosystem — archaeological resources | Golden Age engineers, instrument makers, cargo handlers | Corrosion-resistant alloys; environmental protection in the Sanctum; limited quantity |
| **Wood** | Produced by the Ark's mature trees | Tree growth (photosynthesis → cellulose/lignin); branch fall and tree death | The forest ecosystem — trees as primary producers | Golden Age carpenters, toolmakers, and fuel users | Continuous production by living trees; slow decomposition recycles dead wood |
| **Plants (Grains, Berries, Flowers)** | Descendants of Golden Age cultivated species; some wind-borne colonists | Plant reproduction (flowering → pollination → seed set); natural selection over 5,000 years | The managed-to-wild gradient: Cascade Gardens → Aviary → Verdant Creep | Golden Age agronomists, botanists, physicians, and cooks | Annual/perennial life cycles; seed banks in soil; continuous reproduction |
| **Medicinal Plants** | Deliberately cultivated during Golden Age; persisted through natural reproduction | Plant secondary metabolism — genetic encoding of pharmaceutical compounds | Damp, shaded areas (Types 1, 3, 4); dry, sunny areas (Type 2) | Golden Age physicians — the Ark's medical staff | Perennial plants; continuous reproduction; protected microhabitats |
| **Fibers** | Produced by specific plant species — vines, herbs, leaf-plants | Plant structural tissue — elongated cells for tensile strength | Vine-covered structures (Aviary, Verdant Creep); terrace edges (Cascade Gardens) | Golden Age rope-makers, weavers, paper-makers | Continuous plant growth; vines and perennial fiber plants regrow after harvesting |
| **Animal Products (Feathers, Honey, Insects)** | Produced by the Ark's animal populations — descendants of managed species | Animal metabolism and behavior — feather molt, nectar processing, insect reproduction | The Aviary pollinator ecosystem; forest bird colonies | Golden Age apiarists, ornithologists, entomologists | Continuous animal reproduction; stable populations; seasonal cycles |
| **Organic Matter (Humus, Fungi, Rotting Wood)** | Produced by the decomposition of dead organic matter | Biological decomposition by fungi, bacteria, insects; accumulation over 5,000 years | The decomposition web — fungi, bacteria, insects, and the soil food web | Golden Age agronomists (managed composting); ecologists (studied decomposition) | Continuous input of dead organic matter; continuous decomposition; humus accumulation |
| **Water** | Rain captured by the island's surface; distributed by the original water management system | The planetary water cycle — evaporation, condensation, precipitation, collection | The hydrological system — reservoir, channels, terraces, pools, cistern | Golden Age hydraulic engineers; every resident of the Ark | Continuous precipitation; functional catchment and storage; closed-loop system |
| **Crystals (Small and Large)** | Embedded in the Ark's infrastructure — the resonance arrays that keep the island aloft | Grown in Golden Age Resonance Foundries; precise crystal engineering | The resonance web — moss, thermal microclimates, the island's lift | Golden Age resonance engineers, instrument makers, the Director | Slow weathering exposes fragments; large crystals preserved in instruments |
| **Resonance Moss** | Colonized exposed resonance crystals — likely wind-borne spores from surface or other islands | Biological adaptation to utilize resonance energy as metabolic supplement | The resonance web — symbiotic relationship with exposed crystals | Studied by Golden Age biologists as a curiosity | Continuous growth on exposed crystals; reproduction by spores |
| **Ancient Components** | Part of the Ark's original equipment — left in place during evacuation | Manufactured in Golden Age workshops; assembled on-site | Archaeological resources — not part of living ecosystems | Golden Age engineers, technicians, instrument makers | Corrosion-resistant materials; sheltered locations; the evacuation left equipment in place |
| **Scientific Artifacts** | The Ark's observational and analytical instruments — operational until abandonment | Manufactured by Golden Age instrument makers — the pinnacle of that civilization's precision engineering | Archaeological resources — interactive features, not collectibles | Golden Age astronomers, meteorologists, resonance engineers, the Director | Deliberate preservation (Sanctum); weather-resistant design (Celestial Ring); minimal disturbance since evacuation |
| **Forgotten Technology** | The most advanced Golden Age systems — communication, preservation, lift | Manufactured in specialized Golden Age facilities; operating principles not replicable on the Ark | Archaeological/functional resources — still partially operational | Golden Age specialists; the Director (maintained them) | Autonomous operation (resonance arrays); environmental protection (Sanctum); failsafe designs |
| **Unknown Materials** | Components of advanced Golden Age technology — the materials science frontier | Molecular engineering in Golden Age laboratories — not replicable with Ark resources | Archaeological resources — embedded in technological systems | Golden Age materials scientists; the Director (studied them) | Environmental protection; inherent material stability; limited quantity |

### 17.2 — Ecological Interconnection Verification

Every resource category participates in at least two ecological webs:

| Category | Primary Web | Secondary Web |
|----------|-------------|---------------|
| Stone | Soil Web (source of mineral particles) | Resonance Web (contains crystal arrays) |
| Minerals | Water Web (water transports and deposits) | Soil Web (minerals contribute to soil composition) |
| Metals | Archaeological Web | None — metals are ecologically inert (except as mineral sources during corrosion) |
| Wood | Forest Web | Decomposition Web (dead wood → fungi → humus) |
| Plants | Pollination Web | Water Web (moisture gradient determines distribution) |
| Medicinal Plants | Water Web (moisture-loving species) | Pollination Web (flowering → pollinator support) |
| Fibers | Forest Web (vines on trees) | Archaeological Web (preserved textiles reveal historical use) |
| Animal Products | Pollination Web (bees, butterflies) | Forest Web (birds, nest colonies) |
| Organic Matter | Decomposition Web | Soil Web (humus → plant growth) |
| Water | Water Web (the entire hydrological system) | Soil Web (water transports and deposits minerals) |
| Crystals | Resonance Web | Archaeological Web (crystals in instruments) |
| Resonance Moss | Resonance Web | Forest Web (grows on stone and crystal in forested areas) |

### 17.3 — Discovery Method Verification

Every resource can be discovered through at least three of the eight discovery methods:

| Resource | Primary Discovery | Secondary Discovery | Tertiary Discovery |
|----------|------------------|---------------------|-------------------|
| Clay | Geological Understanding (sedimentation logic) | Direct Observation (pool edges) | Historical Knowledge (Golden Age pottery records) |
| Medicinal Herbs | Direct Observation (distinctive appearance) | Pattern Recognition (habitat preferences) | Experimentation (testing unknown plants for effects) |
| Crystal Fragments | Environmental Indicators (Resonance Moss) | Direct Observation (glow in darkness) | Geological Understanding (exposed in eroded areas) |
| Ancient Components | Direct Observation (on/near equipment) | Historical Knowledge (equipment manifests) | Pattern Recognition (types of components in types of districts) |
| Honey | Animal Behavior (bird activity near hives) | Direct Observation (honeycomb visible in arches) | Historical Knowledge (beehive records) |

### 17.4 — Scientific Discovery Verification

Every resource category teaches at least one major scientific principle:

| Category | Scientific Principles Taught |
|----------|---------------------------|
| Stone | Composite materials, structural engineering, weathering |
| Minerals | Sedimentation, particle sorting, erosion |
| Metals | Oxidation, alloy properties, corrosion chemistry |
| Wood | Species-specific material properties, sustainable harvesting |
| Plants | Domestication/feralization, annual life cycles, seed dispersal |
| Medicinal Plants | Secondary metabolites, dosage, preparation methods |
| Fibers | Plant cell structure, tensile strength, textile production |
| Animal Products | Molting cycles, social insect behavior, pollination mutualism |
| Organic Matter | Decomposition succession, nutrient cycling, soil food webs |
| Water | The water cycle, closed-loop hydrology, filtration |
| Crystals | Crystal lattice structure, resonance energy storage, doping |
| Resonance Moss | Biological adaptation to novel energy sources, symbiosis |
| Ancient Components | Precision manufacturing, standardization, material durability |
| Scientific Artifacts | Instrument-based observation, measurement, data collection |
| Forgotten Technology | Systems thinking, reverse engineering, technological prerequisites |
| Unknown Materials | Molecular engineering, materials science frontier, consistent physics |

---

## CLOSING STATEMENT

This Resource Ecology Design Document defines every material on the Ark of Genesis — its origin, its ecosystem, its relationships, its discovery, and its role in player progression. Resources are organized by ecological logic, not game-logic. Rarity follows from natural constraints, not arbitrary tiers. Discovery comes from observation and understanding, not UI markers.

The Ark is now ecologically complete. Every resource has a story. Every material has a reason for being where it is. The player who pays attention — who observes patterns, who follows ecological relationships, who reads the landscape — will understand the island at a level no minimap could provide.

The work of building this ecology in the engine begins.

---

*Resource Ecology Design Document v1.0 — ratified 2026-07-08*
*Lead Gameplay Systems Designer, Ecologist, Resource Economy Designer, Survival Systems Director, Environmental Simulation Architect: ArchBishop, by order of Lord Commander Ahmad*
