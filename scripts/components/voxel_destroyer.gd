extends Node
## Attach to the player. On interact (E), casts a ray from the camera
## and damages the targeted voxel in the VoxelWorld.
##
## Standing Rule: All non-ground voxels are destructible.

@export var damage_per_hit: float = 5.0
@export var ray_length: float = 10.0
@export var tool_name: String = ""  ## "pickaxe", "axe", or "" for hands

var _voxel_world: VoxelWorld


func _ready() -> void:
	# Find VoxelWorld in the scene tree
	var root: Node = get_tree().current_scene
	_voxel_world = _find_voxel_world(root)
	print("VOXEL_DESTROYER_READY  world:", "found" if _voxel_world else "MISSING")


func _find_voxel_world(node: Node) -> VoxelWorld:
	if node is VoxelWorld:
		return node
	for child in node.get_children():
		var found: VoxelWorld = _find_voxel_world(child)
		if found:
			return found
	return null


func _input(event: InputEvent) -> void:
	if not _voxel_world:
		return
	if event.is_action_pressed("interact"):
		_try_destroy_voxel()


func _try_destroy_voxel() -> void:
	var cam: Camera3D = get_viewport().get_camera_3d()
	if not cam:
		return
	# Ray from camera center
	var from: Vector3 = cam.global_position
	var to: Vector3 = from - cam.global_transform.basis.z * ray_length
	var space_state: PhysicsDirectSpaceState3D = get_viewport().get_world_3d().direct_space_state
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = 1  # World collision layer
	var result: Dictionary = space_state.intersect_ray(query)
	if result.is_empty():
		return
	var hit_pos: Vector3 = result.position
	# Offset slightly into the voxel from the hit face
	var normal: Vector3 = result.normal
	var target: Vector3 = hit_pos + normal * 0.1
	var damage_result: Dictionary = _voxel_world.damage_voxel_at(target, damage_per_hit, tool_name)
	if damage_result.get("destroyed", false):
		print("VOXEL_DESTROYED at ", target)
