# test_examine_codex.gd — Verify EXAMINE interaction writes to Codex
extends Node

func _ready() -> void:
	var all_ok: bool = true

	# Load Codex script and create isolated instance
	var codex_script: GDScript = load("res://scripts/autoloads/codex.gd")
	var codex := Node.new()
	codex.set_script(codex_script)
	codex.name = "Codex"
	add_child(codex)

	# Create Interactable (EXAMINE type)
	var inter_script: GDScript = load("res://scripts/components/interactable.gd")
	var interactable := Area3D.new()
	interactable.set_script(inter_script)
	interactable.interact_type = 0  # EXAMINE
	interactable.interactable_id = "test_orb"
	add_child(interactable)

	# Create Observable as child
	var obs_script: GDScript = load("res://scripts/components/observable.gd")
	var observable := Node.new()
	observable.set_script(obs_script)
	observable.observable_id = "knowledge_test_orb"
	interactable.add_child(observable)

	# Trigger interaction (simulate player pressing E)
	interactable.interact(null)

	# Verify Codex recorded the observation
	if not codex.observations.has("knowledge_test_orb"):
		print("FAIL: Codex did not record observation")
		all_ok = false
	elif codex.observations["knowledge_test_orb"] != 1:
		print("FAIL: Codex observation count wrong:", codex.observations["knowledge_test_orb"])
		all_ok = false

	if all_ok:
		print("TEST_EXAMINE_CODEX_PASS")
		get_tree().quit(0)
	else:
		print("TEST_EXAMINE_CODEX_FAIL")
		get_tree().quit(1)
