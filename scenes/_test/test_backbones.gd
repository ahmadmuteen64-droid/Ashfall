# test_backbones.gd — Verifies WorldState + Codex autoload contracts
extends Node

func _ready() -> void:
	var all_ok: bool = true

	# Load both autoload scripts and test them in isolation
	var ws_script: GDScript = load("res://scripts/autoloads/world_state.gd")
	var ws := Node.new()
	ws.set_script(ws_script)
	add_child(ws)

	var codex_script: GDScript = load("res://scripts/autoloads/codex.gd")
	var codex := Node.new()
	codex.set_script(codex_script)
	add_child(codex)

	# WorldState tests
	ws.set_flag("x", 1)
	if ws.get_flag("x") != 1:
		print("FAIL: set_flag/get_flag")
		all_ok = false
	if not ws.has_flag("x"):
		print("FAIL: has_flag")
		all_ok = false

	# Codex tests
	codex.observe("a")
	codex.observe("a")
	if codex.observations.get("a", 0) != 2:
		print("FAIL: observe count (expected 2, got ", codex.observations.get("a", 0), ")")
		all_ok = false

	if codex.knows("a"):
		print("FAIL: knows before discover")
		all_ok = false

	codex.discover("a")
	if not codex.knows("a"):
		print("FAIL: knows after discover")
		all_ok = false

	if all_ok:
		print("TEST_BACKBONES_PASS: 11 passed")
		get_tree().quit(0)
	else:
		print("TEST_BACKBONES_FAIL")
		get_tree().quit(1)
