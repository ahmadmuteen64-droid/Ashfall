# test_loop.gd — Verifies traversal loop: visit all 5 areas → all visited
extends Node

func _ready() -> void:
	var tracker_script: GDScript = load("res://scripts/systems/loop_tracker.gd")
	var tracker: Node = Node.new()
	tracker.set_script(tracker_script)
	add_child(tracker)

	var areas: Array[String] = ["SpawnShrine","GreatTreePlaza","ForestPath","CrystalRift","Observatory"]
	var all_ok: bool = true

	# Initially none visited
	for area in areas:
		if tracker.is_visited(area):
			print("FAIL: ", area, " already visited at start")
			all_ok = false

	# Visit all
	for area in areas:
		tracker.visit(area)

	# All should be visited now
	for area in areas:
		if not tracker.is_visited(area):
			print("FAIL: ", area, " not visited after visit()")
			all_ok = false

	if all_ok:
		print("TEST_LOOP_PASS")
		get_tree().quit(0)
	else:
		print("TEST_LOOP_FAIL")
		get_tree().quit(1)
