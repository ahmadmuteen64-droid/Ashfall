# test_smoke.gd — Self-running smoke test
extends Node


func _ready() -> void:
	run_test()
	get_tree().quit(0)


func run_test() -> void:
	assert(1 == 1, "smoke: one equals one")
	print("TEST_SMOKE_PASS")
