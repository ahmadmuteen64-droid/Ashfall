# main_menu.gd — Y1: Menu, pause, save
extends Control

var _is_paused: bool = false


func _ready() -> void:
	# Connect buttons
	var vbox := get_node_or_null("VBox")
	if vbox:
		var new_btn := vbox.get_node_or_null("NewGame")
		var cont_btn := vbox.get_node_or_null("Continue")
		var quit_btn := vbox.get_node_or_null("Quit")
		if new_btn:
			new_btn.pressed.connect(_on_new_game)
		if cont_btn:
			cont_btn.pressed.connect(_on_continue)
			cont_btn.disabled = not _has_save()
		if quit_btn:
			quit_btn.pressed.connect(_on_quit)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_toggle_pause()


func _toggle_pause() -> void:
	_is_paused = not _is_paused
	get_tree().paused = _is_paused
	visible = _is_paused


func _on_new_game() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/world/main.tscn")


func _on_continue() -> void:
	var save := get_node_or_null("/root/SaveSystem")
	if save and save.has_method("load_game"):
		save.load_game()
	get_tree().paused = false
	visible = false


func _on_quit() -> void:
	get_tree().quit()


func _has_save() -> bool:
	return FileAccess.file_exists("user://save_game.json")
