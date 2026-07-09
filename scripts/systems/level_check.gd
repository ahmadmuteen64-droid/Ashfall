# level_check.gd — Verifies walkable surfaces have collision
extends Node3D

func _ready() -> void:
	var collider_count: int = _count_colliders(get_tree().root)
	if collider_count > 0:
		print("WORLD_OK")
	else:
		print("WORLD_FAIL: No collision surfaces found")


func _count_colliders(node: Node) -> int:
	var count: int = 0
	if node is StaticBody3D or node is CSGShape3D:
		count += 1
	for child in node.get_children():
		count += _count_colliders(child)
	return count
