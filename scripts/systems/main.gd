# main.gd — Main scene root. Global input handling.
extends Node3D

func _ready() -> void:
	print("MAIN_OK")


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_J:
		var journal := get_node_or_null("JournalUI")
		if journal and journal.has_method("toggle"):
			journal.toggle()
