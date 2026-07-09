# InteractionManager.gd — Autoload singleton for player-world interaction
# Routes raycast-based interaction to the correct handler
extends Node

signal object_examined(object_id: String, object_name: String, category: String)
signal object_collected(object_id: String, resource_slug: String, quantity: int)
signal object_activated(object_id: String, mechanism_type: String)
signal journal_entry_added(entry_id: String)

const INTERACTION_RANGE: float = 15.0


func request_interact(source_node: Node3D) -> Dictionary:
	var result: Dictionary = {"success": false, "type": "", "object_id": "", "data": {}}

	var space_state: PhysicsDirectSpaceState3D = source_node.get_world_3d().direct_space_state
	var origin: Vector3 = source_node.global_position
	var target: Vector3 = origin - source_node.global_transform.basis.z * INTERACTION_RANGE

	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, target)
	query.collision_mask = 1 << 2
	query.exclude = [source_node]

	var hit: Dictionary = space_state.intersect_ray(query)
	if hit.is_empty():
		return result

	var collider: Node3D = hit["collider"] as Node3D
	if not collider.is_in_group("interactable"):
		return result

	result["success"] = true
	result["object_id"] = collider.get_meta("object_id", "")

	var interaction_type: String = collider.get_meta("interaction_type", "examine") as String
	result["type"] = interaction_type

	match interaction_type:
		"examine":
			_handle_examine(collider, result)
		"collect":
			_handle_collect(collider, result)
		"activate":
			_handle_activate(collider, result)
		"sustained":
			_handle_sustained(collider, result)

	return result


func _handle_examine(collider: Node3D, result: Dictionary) -> void:
	var obj_name: String = collider.get_meta("display_name", "Unknown Object") as String
	var category: String = collider.get_meta("category", "general") as String
	var journal_entry: String = collider.get_meta("journal_entry", "") as String
	object_examined.emit(result["object_id"], obj_name, category)
	if not journal_entry.is_empty():
		journal_entry_added.emit(journal_entry)


func _handle_collect(collider: Node3D, result: Dictionary) -> void:
	var resource_slug: String = collider.get_meta("resource_slug", "") as String
	var quantity: int = collider.get_meta("quantity", 1) as int
	object_collected.emit(result["object_id"], resource_slug, quantity)
	if collider.has_method("on_harvested"):
		collider.on_harvested(quantity)


func _handle_activate(collider: Node3D, result: Dictionary) -> void:
	var mechanism_type: String = collider.get_meta("mechanism_type", "") as String
	object_activated.emit(result["object_id"], mechanism_type)
	if collider.has_method("on_activated"):
		collider.on_activated()


func _handle_sustained(collider: Node3D, result: Dictionary) -> void:
	var duration: float = collider.get_meta("sustain_duration", 3.0) as float
	if collider.has_method("on_sustained_interact"):
		collider.on_sustained_interact(duration)
	result["data"]["sustain_duration"] = duration
