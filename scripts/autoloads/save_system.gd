extends Node

const SAVE_PATH: String = "user://save.json"


func _ready() -> void:
	_load()


func save() -> void:
	var data := {
		"observations": _get_codex_data("observations"),
		"nodes": _get_codex_data("nodes"),
		"flags": _get_worldstate_data(),
		"inventory": _get_inventory_data()
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		print("SAVE_OK")


func _load() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return
	var text := file.get_as_text()
	var data = JSON.parse_string(text)
	if data == null:
		return
	_restore(data)
	print("LOAD_OK")


func _get_codex_data(key: String) -> Dictionary:
	var codex := get_node_or_null("/root/Codex")
	if codex:
		return codex.get(key).duplicate()
	return {}


func _get_worldstate_data() -> Dictionary:
	var ws := get_node_or_null("/root/WorldState")
	if ws:
		return ws.get("_flags").duplicate() if ws.get("_flags") else {}
	return {}


func _get_inventory_data() -> Dictionary:
	var inv := get_node_or_null("/root/Inventory")
	if inv:
		return inv.get_all()
	return {}


func _restore(data: Dictionary) -> void:
	if data.has("observations"):
		var codex := get_node_or_null("/root/Codex")
		if codex:
			codex.observations = data.observations
	if data.has("nodes"):
		var codex := get_node_or_null("/root/Codex")
		if codex:
			codex.nodes = data.nodes
	if data.has("flags"):
		var ws := get_node_or_null("/root/WorldState")
		if ws:
			ws.set("_flags", data.flags)
	if data.has("inventory"):
		var inv := get_node_or_null("/root/Inventory")
		if inv:
			inv.set("_items", data.inventory)
			inv.changed.emit()
