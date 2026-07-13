#!/usr/bin/env python3
"""Generate AshFall crafting .tres files from Infinite Craft recipes.
Organized into knowledge-gated progression tiers.
"""

import os

BASE = "/home/iama/ash-fall/data"

# ── Tier 1: No gate — trial and error ────────────────────────
TIER1_REACTIONS = [
    # (input1, input2, result, display_name, emoji, byproduct)
    ("crystal_shard", "iron_fragment", "resonant_alloy", "Resonant Alloy", "🔮", ""),
    ("crystal_shard", "coal_dust", "charged_gem", "Charged Gem", "💎", "obsidian_shard"),
    ("resonance_moss", "clay_deposit", "resonant_ceramic", "Resonant Ceramic", "🏺", ""),
    ("vine_fiber", "iron_fragment", "reinforced_cable", "Reinforced Cable", "🔗", ""),
    ("copper_ore", "iron_fragment", "ancient_bronze", "Ancient Bronze", "🗿", "forge_ember"),
    ("copper_ore", "forge_ember", "conductive_alloy", "Conductive Alloy", "⚡", ""),
    ("pollen_dust", "nectar_sap", "growth_elixir", "Growth Elixir", "🧪", ""),
    ("obsidian_shard", "coal_dust", "abrasive_paste", "Abrasive Paste", "🪨", ""),
    ("iron_fragment", "forge_ember", "steel_ingot", "Steel Ingot", "🪙", ""),
    ("clay_deposit", "forge_ember", "ceramic_plate", "Ceramic Plate", "🍽️", ""),
    ("vine_fiber", "vine_fiber", "woven_fabric", "Woven Fabric", "🧵", ""),
    ("coal_dust", "coal_dust", "carbon_powder", "Carbon Powder", "⬛", ""),
]

# ── Tier 2: Requires knowledge ────────────────────────────────
TIER2_REACTIONS = [
    ("crystal_shard", "nectar_sap", "crystal_bloom", "Crystal Bloom", "🌺", "pollen_dust", "resonance_basics"),
    ("crystal_shard", "quicksilver_drop", "reflective_lens", "Reflective Lens", "🔍", "crystal_shard", "resonance_basics"),
    ("crystal_shard", "resonance_moss", "resonance_core", "Resonance Core", "💠", "vine_fiber", "resonance_basics"),
    ("charged_gem", "resonant_alloy", "resonance_amplifier", "Resonance Amplifier", "📡", "", "resonance_basics"),
    ("resonant_alloy", "steel_ingot", "tuned_alloy", "Tuned Alloy", "🎵", "", "resonance_basics"),
    ("resonant_ceramic", "carbon_powder", "insulated_ceramic", "Insulated Ceramic", "🧱", "", "resonance_basics"),
    ("reflective_lens", "resonant_alloy", "focusing_lens", "Focusing Lens", "🔬", "", "reflective_lens"),
    ("growth_elixir", "crystal_bloom", "awakening_essence", "Awakening Essence", "✨", "pollen_dust", "growth_elixir"),
    ("conductive_alloy", "charged_gem", "power_cell", "Power Cell", "🔋", "", "conductive_alloy"),
    ("steel_ingot", "woven_fabric", "armored_mesh", "Armored Mesh", "🛡️", "", "conductive_alloy"),
    ("reinforced_cable", "power_cell", "energy_conduit", "Energy Conduit", "⚡", "", "conductive_alloy"),
    ("ancient_bronze", "carbon_powder", "hardened_bronze", "Hardened Bronze", "🗡️", "", "ancient_bronze"),
]

# ── Tier 3: Requires multiple knowledge nodes ─────────────────
TIER3_REACTIONS = [
    ("resonance_core", "focusing_lens", "resonance_prism", "Resonance Prism", "🔶", "", "resonance_core"),
    ("resonance_amplifier", "energy_conduit", "resonance_relay", "Resonance Relay", "📶", "", "resonance_amplifier"),
    ("awakening_essence", "resonance_core", "living_crystal", "Living Crystal", "💎", "", "awakening_essence"),
    ("power_cell", "reflective_lens", "laser_emitter", "Laser Emitter", "💡", "", "power_cell"),
    ("tuned_alloy", "resonance_prism", "harmonic_alloy", "Harmonic Alloy", "🎶", "", "tuned_alloy"),
    ("insulated_ceramic", "energy_conduit", "thermal_shield", "Thermal Shield", "🔥", "", "insulated_ceramic"),
    ("armored_mesh", "resonant_ceramic", "resonant_armor", "Resonant Armor", "⚔️", "", "armored_mesh"),
    ("living_crystal", "growth_elixir", "crystal_seed", "Crystal Seed", "🌱", "", "living_crystal"),
]

# ── Tier 4: Breakthrough ──────────────────────────────────────
TIER4_REACTIONS = [
    ("harmonic_alloy", "resonance_relay", "ark_resonator", "Ark Resonator", "🏛️", "", "harmonic_alloy"),
    ("living_crystal", "laser_emitter", "crystal_beacon", "Crystal Beacon", "🚨", "", "living_crystal"),
    ("resonance_prism", "thermal_shield", "prismatic_barrier", "Prismatic Barrier", "🌈", "", "resonance_prism"),
    ("crystal_seed", "ark_resonator", "world_tree_core", "World Tree Core", "🌳", "", "crystal_seed"),
]

# ── Knowledge nodes ───────────────────────────────────────────
KNOWLEDGE_NODES = [
    ("resonance_basics", "Resonance Basics",
     "Crystals store and release kinetic energy through lattice vibration.",
     ["resonant_alloy", "resonance_core"], ["resonance_lens"]),
    ("conductive_alloy", "Conductive Alloy Theory",
     "Metal alloys can be engineered to channel both thermal and resonant energy simultaneously.",
     ["power_cell", "energy_conduit"], []),
    ("growth_elixir", "Growth Elixir Theory",
     "Certain organic compounds accelerate biological growth patterns when properly catalyzed.",
     ["crystal_bloom", "awakening_essence"], []),
    ("reflective_lens", "Optical Resonance",
     "Curved resonant crystal bends and focuses light at specific frequencies.",
     ["focusing_lens", "laser_emitter"], []),
    ("charged_gem", "Crystal Energy Storage",
     "Resonant crystals can store and discharge energy when properly charged.",
     ["power_cell", "charged_gem"], []),
    ("ancient_bronze", "Ancient Metallurgy",
     "The old-world technique of combining copper and iron produces alloys with unique properties.",
     ["hardened_bronze", "steel_ingot"], []),
    ("resonance_core", "Resonance Core Theory",
     "A concentrated crystal-moss-quicksilver matrix generates a self-sustaining resonance field.",
     ["living_crystal", "resonance_prism"], []),
    ("resonance_amplifier", "Signal Amplification",
     "Resonant alloys can amplify and relay crystal resonance signals across distance.",
     ["resonance_relay", "harmonic_alloy"], []),
    ("awakening_essence", "Crystalline Life",
     "The boundary between mineral and organic blurs when growth essence meets crystal bloom.",
     ["living_crystal", "crystal_seed"], []),
    ("tuned_alloy", "Harmonic Materials",
     "Materials can be tuned to specific resonance frequencies for precise applications.",
     ["harmonic_alloy", "resonance_prism"], []),
    ("power_cell", "Energy Storage Systems",
     "Combining conductive alloys with charged crystals creates stable power storage.",
     ["energy_conduit", "laser_emitter"], []),
    ("insulated_ceramic", "Thermal Insulation",
     "Carbon-enhanced ceramics provide superior insulation against heat and energy discharge.",
     ["thermal_shield", "resonant_armor"], []),
    ("armored_mesh", "Protective Materials",
     "Steel-woven fabric creates lightweight armor that distributes impact force.",
     ["resonant_armor", "thermal_shield"], []),
    ("living_crystal", "Living Crystal Theory",
     "Crystals infused with awakening essence exhibit organic growth patterns and self-repair.",
     ["crystal_seed", "crystal_beacon"], []),
    ("harmonic_alloy", "Harmonic Resonance Theory",
     "Alloys tuned to specific frequencies can resonate in sympathy with the Ark itself.",
     ["ark_resonator", "world_tree_core"], []),
]


def make_material(material_id, display_name, emoji, properties):
    """Generate a MaterialDef .tres file."""
    props_str = ", ".join(f'"{k}": "{v}"' for k, v in properties.items())
    return f"""[gd_resource type="Resource" script_class="MaterialDef" load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/resources/material_def.gd" id="1_script"]

[resource]
script = ExtResource("1_script")
material_id = "{material_id}"
display_name = "{display_name} {emoji}"
properties = {{{props_str}}}
known_properties = []
"""


def make_reaction(reaction_id, inputs, result_node, byproducts, requires_knows, conditions):
    """Generate a ReactionDef .tres file."""
    inputs_str = ", ".join(f'"{x}"' for x in inputs)
    byproducts_str = ", ".join(f'"{x}"' for x in byproducts) if byproducts else ""
    cond_str = ", ".join(f'"{k}": "{v}"' for k, v in conditions.items())
    return f"""[gd_resource type="Resource" script_class="ReactionDef" load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/resources/reaction_def.gd" id="1_script"]

[resource]
script = ExtResource("1_script")
reaction_id = "{reaction_id}"
inputs = [{inputs_str}]
conditions = {{{cond_str}}}
result_node = "{result_node}"
requires_knows = "{requires_knows}"
byproducts = [{byproducts_str}]
"""


def make_knowledge(node_id, display_name, summary, links, unlocks):
    """Generate a KnowledgeNode .tres file."""
    links_str = ", ".join(f'"{x}"' for x in links)
    unlocks_str = ", ".join(f'"{x}"' for x in unlocks)
    return f"""[gd_resource type="Resource" script_class="KnowledgeNode" load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/resources/knowledge_node.gd" id="1_script"]

[resource]
script = ExtResource("1_script")
node_id = "{node_id}"
display_name = "{display_name}"
summary = "{summary}"
links = [{links_str}]
confidence = 2
unlocks = [{unlocks_str}]
"""


def main():
    mats_dir = os.path.join(BASE, "materials")
    rxns_dir = os.path.join(BASE, "reactions")
    codex_dir = os.path.join(BASE, "codex")

    created = {"materials": 0, "reactions": 0, "codex": 0}

    # ── Generate materials ──
    all_results = set()
    for tier in [TIER1_REACTIONS, TIER2_REACTIONS, TIER3_REACTIONS, TIER4_REACTIONS]:
        for rxn in tier:
            result_id = rxn[2]
            all_results.add((result_id, rxn[3], rxn[4]))

    for mat_id, display_name, emoji in sorted(all_results):
        fpath = os.path.join(mats_dir, f"{mat_id}.tres")
        if os.path.exists(fpath):
            continue
        props = {"type": "synthesized", "era": "golden"}
        content = make_material(mat_id, display_name, emoji, props)
        with open(fpath, "w") as f:
            f.write(content)
        created["materials"] += 1

    # ── Generate reactions ──
    for tier_name, tier_data, default_knows in [
        ("tier1", TIER1_REACTIONS, ""),
        ("tier2", TIER2_REACTIONS, ""),  # set per-reaction below
        ("tier3", TIER3_REACTIONS, ""),
        ("tier4", TIER4_REACTIONS, ""),
    ]:
        for rxn in tier_data:
            if len(rxn) == 5:
                a, b, rid, dname, emoji = rxn
                byproduct = ""
                knows = default_knows
            elif len(rxn) == 6:
                a, b, rid, dname, emoji, byproduct = rxn
                knows = default_knows
            else:
                a, b, rid, dname, emoji, byproduct, knows = rxn

            # For tier 2: special case - triple input
            if rid == "resonance_core":
                inputs_list = ["crystal_shard", "resonance_moss", "quicksilver_drop"]
                conds = {"heat": "required", "pressure": "required"}
                reaction_id = "triple_resonance_brew"
            else:
                inputs_list = [a, b]
                # Heat conditions for specific reactions
                if rid in ("charged_gem", "steel_ingot", "hardened_bronze", "ceramic_plate",
                          "power_cell", "thermal_shield", "resonant_armor"):
                    conds = {"heat": "required"}
                elif rid in ("reflective_lens", "focusing_lens", "laser_emitter"):
                    conds = {"pressure": "required"}
                elif rid in ("resonance_amplifier", "resonance_relay", "harmonic_alloy",
                            "ark_resonator", "crystal_beacon"):
                    conds = {"heat": "required", "pressure": "required"}
                else:
                    conds = {}
                reaction_id = f"{a}_{b}_to_{rid}"

            fpath = os.path.join(rxns_dir, f"{reaction_id}.tres")
            if os.path.exists(fpath):
                continue

            byproducts_list = [byproduct] if byproduct else []
            content = make_reaction(reaction_id, inputs_list, rid, byproducts_list, knows, conds)
            with open(fpath, "w") as f:
                f.write(content)
            created["reactions"] += 1

    # ── Generate knowledge nodes ──
    for node_id, display_name, summary, links, unlocks in KNOWLEDGE_NODES:
        fpath = os.path.join(codex_dir, f"{node_id}_knowledge.tres")
        if os.path.exists(fpath):
            continue
        content = make_knowledge(node_id, display_name, summary, links, unlocks)
        with open(fpath, "w") as f:
            f.write(content)
        created["codex"] += 1

    print(f"Created: {created['materials']} materials, {created['reactions']} reactions, {created['codex']} knowledge nodes")


if __name__ == "__main__":
    main()
