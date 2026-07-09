# resource_placer.gd — Reads SpawnTable data and instances resource nodes
class_name ResourcePlacer
extends Node3D

@export var spawn_table_path: String = ""
@export var seed_value: int = 0

var _spawned_nodes: Array[Node3D] = []
var _rng: RandomNumberGenerator


func _ready() -> void:
	_rng = RandomNumberGenerator.new()
	if seed_value != 0:
		_rng.seed = seed_value
	else:
		_rng.randomize()


func place_resources(table: SpawnTable) -> void:
	clear_resources()
	for entry: SpawnTable.SpawnEntry in table.spawn_entries:
		_place_entry(entry)


func _place_entry(entry: SpawnTable.SpawnEntry) -> void:
	var count: int = _rng.randi_range(entry.min_instances, entry.max_instances)
	var placed: int = 0
	var attempts: int = 0
	var max_attempts: int = count * 10

	while placed < count and attempts < max_attempts:
		attempts += 1
		var pos: Vector3 = _generate_position()
		if _validate_position(pos, entry):
			_instance_resource(entry.resource_id, pos)
			placed += 1


func _generate_position() -> Vector3:
	return Vector3(
		_rng.randf_range(-100.0, 100.0),
		0.0,
		_rng.randf_range(-110.0, 100.0)
	)


func _validate_position(pos: Vector3, entry: SpawnTable.SpawnEntry) -> bool:
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(
		pos + Vector3.UP * 50.0,
		pos + Vector3.DOWN * 50.0
	)
	var hit: Dictionary = space_state.intersect_ray(query)
	if hit.is_empty():
		return false

	var normal: Vector3 = hit["normal"] as Vector3
	var slope_angle: float = rad_to_deg(normal.angle_to(Vector3.UP))
	if slope_angle > 45.0:
		return false

	for existing: Node3D in _spawned_nodes:
		var hit_pos: Vector3 = hit["position"] as Vector3
		if existing.global_position.distance_to(hit_pos) < entry.min_distance_between:
			return false

	return true


func _instance_resource(resource_id: String, position: Vector3) -> void:
	var marker := Node3D.new()
	marker.name = "res_" + resource_id
	marker.global_position = position
	marker.set_meta("resource_id", resource_id)
	add_child(marker)
	_spawned_nodes.append(marker)


func clear_resources() -> void:
	for node: Node3D in _spawned_nodes:
		node.queue_free()
	_spawned_nodes.clear()
