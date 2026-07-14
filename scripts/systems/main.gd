# main.gd — Main scene root. Global input handling + character spawning.
extends Node3D

func _ready() -> void:
	print("MAIN_OK")
	_spawn_voxel_character()


func _spawn_voxel_character() -> void:
	var player := get_node_or_null("Player")
	if not player: return
	# Remove old cylinder body
	var old := player.get_node_or_null("BodyMesh")
	if old: old.queue_free()
	# Spawn voxel character
	var vc := VoxelCharacter.new()
	vc.name = "VoxelChar"
	vc.position = Vector3(0, -1.0, 0)  # align feet to player origin
	player.add_child(vc)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_J:
		var journal := get_node_or_null("JournalUI")
		if journal and journal.has_method("toggle"):
			journal.toggle()
