# Codex.gd — Autoload singleton for the player's knowledge graph
extends Node

signal observed(id: String)
signal node_understood(id: String)
signal pattern_ready(type_key: String)

var observations: Dictionary = {}   # id -> int (observe count)
var nodes: Dictionary = {}          # id -> bool (discovered)
var _knowledge: Dictionary = {}     # id -> Resource
var _type_counts: Dictionary = {}   # type_key -> int


func _ready() -> void:
	_load_knowledge_nodes()
	print("CODEX_OK")


func _load_knowledge_nodes() -> void:
	var dir := DirAccess.open("res://data/codex/")
	if not dir:
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tres"):
			var kn: Resource = load("res://data/codex/" + file_name)
			if kn:
				var nid_raw = kn.get("node_id")
				var nid: String = str(nid_raw) if nid_raw != null else ""
				if nid != "":
					_knowledge[nid] = kn
		file_name = dir.get_next()


func observe(id: String, type_key: String = "") -> void:
	if not observations.has(id):
		observations[id] = 0
	observations[id] += 1
	observed.emit(id)
	if type_key != "":
		if not _type_counts.has(type_key):
			_type_counts[type_key] = 0
		_type_counts[type_key] += 1
		if _type_counts[type_key] >= 3:
			pattern_ready.emit(type_key)


func knows(id: String) -> bool:
	return nodes.get(id, false)


func discover(id: String) -> void:
	if not nodes.get(id, false):
		nodes[id] = true


func confirm(id: String) -> void:
	if nodes.get(id, false):
		node_understood.emit(id)


func get_confidence(id: String) -> int:
	var kn: Resource = _knowledge.get(id, null)
	if kn:
		return kn.get("confidence")
	return -1


func get_knowledge_node(id: String) -> Resource:
	return _knowledge.get(id, null)


func get_all_nodes() -> Array:
	var result: Array = []
	for id in _knowledge:
		result.append(_knowledge[id])
	return result
