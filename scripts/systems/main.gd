extends Node3D

var _char_spawned: bool = false


func _ready() -> void:
	set_process(true)
	# Freeze player until voxel world is ready
	var p := get_node_or_null("Player")
	if p: p.set_physics_process(false)
	print("MAIN_OK")


func _process(_delta: float) -> void:
	if not _char_spawned:
		_char_spawned = true
		_spawn_voxel_character()


func _spawn_voxel_character() -> void:
	var player := get_node_or_null("Player")
	if not player: return
	var old := player.get_node_or_null("BodyMesh")
	if old: old.queue_free()
	var vc := VoxelCharacter.new()
	vc.name = "VoxelChar"
	vc.position = Vector3(0, -1.0, 0)
	player.add_child(vc)
	print("VOXEL_CHAR_SPAWNED")


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_J:
		var journal := get_node_or_null("JournalUI")
		if journal and journal.has_method("toggle"):
			journal.toggle()
