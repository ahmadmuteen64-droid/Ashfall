# environmental_storytelling.gd — X1-X3: History read from the place
extends Node

# X1: Storytelling arrangements — placed in each district
# X2: Memory fragments — unreliable Memory nodes in Codex graph
# X3: Chronicle artefacts — findable items that reveal resource locations

var _found_artefacts: Array[String] = []


func place_storytelling_arrangement(district_id: String, position: Vector3) -> void:
	"""Called when building a district. Creates a readable arrangement."""
	print("STORY_ARRANGEMENT:" + district_id + " at " + str(position))


func read_arrangement(arrangement_id: String) -> String:
	"""Returns the story text for a given arrangement. No narration — the
	player reads it from the place, not from a text box."""
	var stories: Dictionary = {
		"atrium_table": "A massive stone table. Astronomical markings are carved into its surface — positions of floating islands, orbital paths, dates. The last entry is dated 5,000 years ago. A half-finished cup sits at one seat.",
		"gatehouse_log": "A departure log, water-damaged but legible. The last entry reads: 'Evacuation complete. All personnel transported to Surface Waystation 7. Director remains aboard. End of log.'",
		"quarters_doorframe": "Height markings on a doorframe. The earliest is at a 4-year-old's height. The latest at roughly 12. They stop in the year of the evacuation. A child grew up here.",
		"cascade_notebook": "A researcher's notebook, fallen beneath a seed tray. The last entry: 'Soil pH dropping in Terrace 3. Adjusting limestone input. Should stabilize by [date].' The researcher was troubleshooting right up to the end.",
	}
	return stories.get(arrangement_id, "Faded text, too worn to read.")


# ── X2: Memory fragments ───────────────────────────────────────

func record_memory_fragment(fragment_id: String, codex_node: String) -> void:
	"""Wire a memory fragment to the Codex as a Memory-type node.
	Memories are unreliable — they may contradict observations."""
	var codex := get_node_or_null("/root/Codex")
	if not codex:
		return
	codex.discover(codex_node)
	codex.set_node_type(codex_node, Codex.NodeType.MEMORY if Codex.has_method("set_node_type") else 9)
	# Memory contradiction: create an edge to the observed fact
	var observed_id := fragment_id.replace("_memory", "")
	if codex.has_method("add_edge"):
		codex.add_edge(codex_node, observed_id, 4, 1.0)  # CONTRADICTION edge
	print("MEMORY_FRAGMENT:" + fragment_id)


# ── X3: Chronicle artefacts ────────────────────────────────────

func place_chronicle_artefact(artefact_id: String, position: Vector3, reveals_resource: String) -> void:
	"""Places a findable artefact. Reading it reveals a resource location."""
	print("ARTEFACT_PLACED:" + artefact_id + " reveals " + reveals_resource + " at " + str(position))


func read_artefact(artefact_id: String) -> Dictionary:
	"""Returns artefact text and any revealed resource location."""
	var artefacts: Dictionary = {
		"cargo_manifest": {"text": "Cargo Manifest — Inbound: 12 crates resonance crystal (raw). Destination: Stasis Sanctum storage bay 4. Routed by: Quartermaster Voss.", "reveals": "crystal_shard", "location": Vector3(-10, 0, -20)},
		"broken_instrument": {"text": "A shattered resonance spectrometer. Calibration label reads: 'Property: harmonic frequency. Range: 2-18 kHz. Recalibrate after each use.' A partial reading is still visible on the cracked display.", "reveals": "resonance_moss", "location": Vector3(8, 0, -12)},
		"first_delver_inscription": {"text": "'I, Kaelen Voss, First Delver of the Resonance Core expedition, hereby record that the Core is accessible only through the Celestial Ring — the harmonic lock opens at dawn when the Ring's crystals align with the sun. Do not attempt entry at any other time.'", "reveals": "resonance_core", "location": Vector3(-20, 0, -2)},
	}
	var data: Dictionary = artefacts.get(artefact_id, {"text": "Worn beyond recognition.", "reveals": "", "location": Vector3.ZERO})
	if artefact_id not in _found_artefacts:
		_found_artefacts.append(artefact_id)
	return data
