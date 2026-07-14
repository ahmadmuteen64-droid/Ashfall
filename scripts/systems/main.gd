extends Node3D

var _char_spawned: bool = false


func _ready() -> void:
	set_process(true)
	_create_loading_screen()
	print("MAIN_OK")


func _create_loading_screen() -> void:
	var ls := CanvasLayer.new()
	ls.name = "LoadingScreen"
	ls.set_script(load("res://scripts/ui/loading_screen.gd"))
	var panel := Panel.new()
	panel.name = "Panel"
	panel.anchor_left = 0.2; panel.anchor_right = 0.8
	panel.anchor_top = 0.3; panel.anchor_bottom = 0.7
	ls.add_child(panel)
	var vbox := VBoxContainer.new()
	vbox.name = "VBox"
	vbox.anchor_left = 0.05; vbox.anchor_right = 0.95
	vbox.anchor_top = 0.05; vbox.anchor_bottom = 0.95
	panel.add_child(vbox)
	var joke := Label.new(); joke.name = "JokeLabel"
	joke.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	joke.autowrap_mode = TextServer.AUTOWRAP_WORD
	vbox.add_child(joke)
	var spin := Label.new(); spin.name = "Spinner"
	spin.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(spin)
	var prog := ProgressBar.new(); prog.name = "Progress"
	prog.size_flags_horizontal = Control.SIZE_FILL
	vbox.add_child(prog)
	var title := Label.new(); title.name = "Title"
	title.text = "TRAVELLING THROUGH THE VOID..."
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 24)
	vbox.add_child(title)
	add_child(ls)


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
