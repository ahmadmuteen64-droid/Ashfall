# test_smoke.gd — Minimal smoke test for the test harness
# Verifies the test infrastructure works.
extends Node

func _ready() -> void:
	_run_tests()


func _run_tests() -> void:
	print("TEST_SMOKE_BEGIN")
	_assert(1 == 1, "smoke: one equals one")
	print("TEST_SMOKE_PASS")
	get_tree().quit(0)


func _assert(condition: bool, label: String) -> void:
	if condition:
		print("  PASS: " + label)
	else:
		print("  FAIL: " + label)
		get_tree().quit(1)
