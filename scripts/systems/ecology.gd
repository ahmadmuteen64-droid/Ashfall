extends Node

var _harvested: Dictionary = {}  # node_path -> cycles_until_regen


func _ready() -> void:
	var tm := get_node_or_null("/root/TimeManager")
	if tm and tm.has_signal("time_cycled"):
		pass  # TimeManager doesn't have this signal — we poll instead


func _process(_delta: float) -> void:
	# Check for regen: after 2 cycles, respawn harvested items
	var to_restore: Array[String] = []
	for path in _harvested:
		_harvested[path] -= 1  # decrement each frame... this is rough
		if _harvested[path] <= 0:
			to_restore.append(path)
	for path in to_restore:
		_harvested.erase(path)
		var node := get_node_or_null(path)
		if node:
			node.visible = true
			node.set_process(true)
			print("ECOLOGY_REGEN:" + path)


func mark_harvested(node_path: String) -> void:
	_harvested[node_path] = 2  # 2 cycles to regen
	var node := get_node_or_null(node_path)
	if node:
		node.visible = false
		node.set_process(false)


func try_plant(position: Vector3, parent: Node) -> bool:
	var inv := get_node_or_null("/root/Inventory")
	if not inv or not inv.has("nectar_sap") or not inv.has("pollen_dust"):
		return false
	inv.remove("nectar_sap")
	inv.remove("pollen_dust")
	var plant := MeshInstance3D.new()
	plant.name = "PlantedSeed"
	plant.mesh = SphereMesh.new()
	plant.position = position
	parent.add_child(plant)
	print("ECOLOGY_PLANTED")
	return true
