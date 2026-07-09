# test_ring1.gd — End-to-end Spine verification: examine → discover → gate opens
extends Node

func _ready() -> void:
	var all_ok: bool = true

	# 1 — Load and instantiate Codex (isolated, no autoload)
	var codex_script: GDScript = load("res://scripts/autoloads/codex.gd")
	var codex := Node.new()
	codex.set_script(codex_script)
	add_child(codex)

	# 2 — Create Interactable (EXAMINE type)
	var inter_script: GDScript = load("res://scripts/components/interactable.gd")
	var interactable := Area3D.new()
	interactable.set_script(inter_script)
	interactable.interactable_id = "crystal_test"
	interactable.interact_type = 0  # EXAMINE
	add_child(interactable)

	# 3 — Create Observable with discovery threshold
	var obs_script: GDScript = load("res://scripts/components/observable.gd")
	var observable := Node.new()
	observable.set_script(obs_script)
	observable.observable_id = "crystal_test"
	observable.discover_threshold = 3
	observable.discover_node = "resonance_basics"
	observable.properties = {"type": "crystal"}
	interactable.add_child(observable)

	# 4 — Create Gate requiring resonance_basics
	var gate_script: GDScript = load("res://scripts/components/gate.gd")
	var gate := Node3D.new()
	gate.set_script(gate_script)
	gate.require_knows = "resonance_basics"
	gate.gate_id = "obs_gate"
	var barrier := StaticBody3D.new()
	barrier.name = "BarrierBody"
	barrier.collision_layer = 1
	gate.add_child(barrier)
	add_child(gate)

	# 5 — Simulate the chain: examine 3×
	interactable.interact(null)
	interactable.interact(null)
	interactable.interact(null)

	# 6 — Verify Codex recorded observations
	if codex.observations.get("crystal_test", 0) != 3:
		print("FAIL: observations != 3 (got ", codex.observations.get("crystal_test", 0), ")")
		all_ok = false

	# 7 — Verify discovery happened
	if not codex.knows("resonance_basics"):
		print("FAIL: resonance_basics not discovered after 3 examines")
		all_ok = false

	# 8 — Verify gate opened (collision disabled)
	if barrier.collision_layer != 0:
		print("FAIL: gate barrier still has collision")
		all_ok = false

	if all_ok:
		print("TEST_RING1_PASS")
		get_tree().quit(0)
	else:
		print("TEST_RING1_FAIL")
		get_tree().quit(1)
