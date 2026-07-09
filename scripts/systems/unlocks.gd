extends Node

var _granted: Array[String] = []


func _ready() -> void:
	var codex := get_node_or_null("/root/Codex")
	if codex and codex.has_signal("node_understood"):
		codex.node_understood.connect(_on_node_understood)


func _on_node_understood(id: String) -> void:
	if id in _granted:
		return
	var codex := get_node_or_null("/root/Codex")
	if not codex:
		return
	var kn: Resource = codex.get_knowledge_node(id) if codex.has_method("get_knowledge_node") else null
	if not kn:
		return
	var unlocks: Array = kn.get("unlocks")
	if unlocks == null:
		return
	var ws := get_node_or_null("/root/WorldState")
	for unlock_id in unlocks:
		_granted.append(id)
		print("UNLOCK:" + str(unlock_id))
		if ws:
			ws.set_flag("unlock_" + str(unlock_id), true)


func is_unlocked(ability_id: String) -> bool:
	var ws := get_node_or_null("/root/WorldState")
	if ws:
		return ws.has_flag("unlock_" + ability_id)
	return false
