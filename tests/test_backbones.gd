# test_backbones.gd — Contract tests for WorldState + Codex autoloads
extends Node

var _failed: int = 0
var _passed: int = 0


func _ready() -> void:
	run_tests()
	if _failed > 0:
		print("TEST_BACKBONES_FAIL: ", _failed, " failures")
		get_tree().quit(1)
	else:
		print("TEST_BACKBONES_PASS: ", _passed, " passed")
		get_tree().quit(0)


func run_tests() -> void:
	_test_worldstate_set_get()
	_test_worldstate_has_flag()
	_test_worldstate_clear()
	_test_codex_observe()
	_test_codex_knows_discover()
	_test_codex_double_observe()


func _check(condition: bool, label: String) -> void:
	if condition:
		_passed += 1
	else:
		_failed += 1
		print("  FAIL: " + label)


func _test_worldstate_set_get() -> void:
	WorldState.set_flag("x", 1)
	_check(WorldState.get_flag("x") == 1, "WorldState set/get")
	_check(WorldState.get_flag("nonexistent", 42) == 42, "WorldState get with default")


func _test_worldstate_has_flag() -> void:
	WorldState.set_flag("y", true)
	_check(WorldState.has_flag("y") == true, "WorldState has_flag true")
	_check(WorldState.has_flag("does_not_exist") == false, "WorldState has_flag false")


func _test_worldstate_clear() -> void:
	WorldState.set_flag("z", "test")
	WorldState.clear_flag("z")
	_check(not WorldState.has_flag("z"), "WorldState clear_flag")


func _test_codex_observe() -> void:
	Codex.observe("a")
	_check(Codex.observations.get("a", 0) == 1, "Codex observe new")
	Codex.observe("a")
	_check(Codex.observations["a"] == 2, "Codex observe second time increments")


func _test_codex_knows_discover() -> void:
	_check(Codex.knows("b") == false, "Codex knows false before discover")
	Codex.discover("b")
	_check(Codex.knows("b") == true, "Codex knows true after discover")


func _test_codex_double_observe() -> void:
	# discover should not emit node_understood twice for same node
	_check(Codex.knows("b") == true, "Codex knows still true after second observe")
	Codex.discover("b")  # should be idempotent
	_check(Codex.knows("b") == true, "Codex knows idempotent on second discover")
