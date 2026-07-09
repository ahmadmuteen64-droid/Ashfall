# SaveSystem.gd — Y1: Autosave on discovery + region entry, versioned schema
extends Node

const SAVE_PATH: String = "user://save.json"
const SAVE_VERSION: int = 1

signal game_saved
signal game_loaded


func _ready() -> void:
	_load()
	var codex := get_node_or_null("/root/Codex")
	if codex and codex.has_signal("confidence_changed"):
		codex.confidence_changed.connect(_on_discovery_autosave)


func _on_discovery_autosave(_id: String, old_level: int, new_level: int) -> void:
	if new_level >= 3 and old_level < 3:
		save()
		print("AUTOSAVE:discovery")


func save() -> void:
	var data: Dictionary = {
		"version": SAVE_VERSION,
		"timestamp": Time.get_unix_time_from_system(),
		"observations": _get_codex_data("observations"),
		"nodes": _get_codex_data("nodes"),
		"flags": _get_worldstate_data(),
		"inventory": _get_inventory_data(),
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		game_saved.emit()
		print("SAVE_OK")


func load_game() -> bool:
	return _load()


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)


func _load() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return false
	var text: String = file.get_as_text()
	var parsed: Variant = JSON.parse_string(text)
	if parsed == null or not (parsed is Dictionary):
		return false
	var data: Dictionary = parsed as Dictionary
	if data.get("version", 0) != SAVE_VERSION:
		print("SAVE_VERSION_MISMATCH")
	_restore(data)
	game_loaded.emit()
	print("LOAD_OK")
	return true


func _get_codex_data(key: String) -> Dictionary:
	var codex := get_node_or_null("/root/Codex")
	if codex:
		var val: Variant = codex.get(key)
		if val is Dictionary:
			return (val as Dictionary).duplicate()
	return {}


func _get_worldstate_data() -> Dictionary:
	var ws := get_node_or_null("/root/WorldState")
	if ws:
		var flags: Variant = ws.get("_flags")
		if flags is Dictionary:
			return (flags as Dictionary).duplicate()
	return {}


func _get_inventory_data() -> Dictionary:
	var inv := get_node_or_null("/root/Inventory")
	if inv:
		return inv.get_all()
	return {}


func _restore(data: Dictionary) -> void:
	if data.has("observations"):
		var codex := get_node_or_null("/root/Codex")
		var obs: Variant = data["observations"]
		if codex and obs is Dictionary:
			codex.observations = obs as Dictionary
	if data.has("nodes"):
		var codex := get_node_or_null("/root/Codex")
		var nds: Variant = data["nodes"]
		if codex and nds is Dictionary:
			codex.nodes = nds as Dictionary
	if data.has("flags"):
		var ws := get_node_or_null("/root/WorldState")
		var fl: Variant = data["flags"]
		if ws and fl is Dictionary:
			ws.set("_flags", fl as Dictionary)
	if data.has("inventory"):
		var inv := get_node_or_null("/root/Inventory")
		var inv_data: Variant = data["inventory"]
		if inv and inv_data is Dictionary:
			inv.set("_items", inv_data as Dictionary)
			inv.changed.emit()
