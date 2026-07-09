# loop_tracker.gd — Tracks traversal beacons. Prints LOOP_COMPLETE when all visited.
extends Node

const REQUIRED: Array[String] = ["SpawnShrine","GreatTreePlaza","ForestPath","CrystalRift","Observatory"]
var _visited: Dictionary = {}


func _ready() -> void:
	for id in REQUIRED:
		_visited[id] = false


func visit(id: String) -> void:
	if not _visited.has(id):
		return
	if _visited[id]:
		return
	_visited[id] = true
	print("LOOP_VISIT:", id)
	if _all_visited():
		print("LOOP_COMPLETE")


func _all_visited() -> bool:
	for id in REQUIRED:
		if not _visited[id]:
			return false
	return true


func is_visited(id: String) -> bool:
	return _visited.get(id, false)
