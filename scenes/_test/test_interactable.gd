# test_interactable.gd — Verifies Interactable component: group, signal, types
extends Node

func _ready() -> void:
	var all_ok: bool = true

	# 1 — Create an interactable of each type
	var examine_obj: Interactable = Interactable.new()
	examine_obj.interact_type = Interactable.InteractType.EXAMINE
	examine_obj.interactable_id = "test_examine"

	var collect_obj: Interactable = Interactable.new()
	collect_obj.interact_type = Interactable.InteractType.COLLECT
	collect_obj.interactable_id = "test_collect"

	var activate_obj: Interactable = Interactable.new()
	activate_obj.interact_type = Interactable.InteractType.ACTIVATE
	activate_obj.interactable_id = "test_activate"

	# 2 — Verify group membership after adding to tree
	add_child(examine_obj)
	add_child(collect_obj)
	add_child(activate_obj)

	if not examine_obj.is_in_group("interactable"):
		print("FAIL: examine not in interactable group")
		all_ok = false

	if not collect_obj.is_in_group("interactable"):
		print("FAIL: collect not in interactable group")
		all_ok = false

	# 3 — Verify interactions signal
	var signaled: Array = []

	var _on_interacted = func(id: String, type: int):
		signaled.append({"id": id, "type": type})

	examine_obj.interacted.connect(_on_interacted)
	examine_obj.interact(null)

	if signaled.size() != 1:
		print("FAIL: signal not emitted")
		all_ok = false
	elif signaled[0].id != "test_examine" or signaled[0].type != Interactable.InteractType.EXAMINE:
		print("FAIL: wrong signal data")
		all_ok = false

	if all_ok:
		print("TEST_INTERACTABLE_PASS")
		get_tree().quit(0)
	else:
		print("TEST_INTERACTABLE_FAIL")
		get_tree().quit(1)
