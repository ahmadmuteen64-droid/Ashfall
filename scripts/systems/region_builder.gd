# region_builder.gd — Stamps a region from template at a given transform with ground tiles.
extends Node

const TEMPLATE_PATH: String = "res://scenes/world/region_template.tscn"
const GROUND_TILE: String = "res://kit/kit_ground_2x2.tscn"
const GROUND_SIZE: int = 5  # 5×5 grid = 10m×10m


func stamp_region(parent: Node, position: Vector3, region_name: String) -> Node3D:
	var template: PackedScene = load(TEMPLATE_PATH)
	var region: Node3D = template.instantiate()
	region.name = region_name
	region.position = position
	parent.add_child(region)

	var ground: Node3D = region.get_node("Ground")
	var half: int = GROUND_SIZE / 2
	for x in range(-half, half + 1):
		for z in range(-half, half + 1):
			var tile_scene: PackedScene = load(GROUND_TILE)
			var tile: Node3D = tile_scene.instantiate()
			tile.name = "Tile_%d_%d" % [x + half, z + half]
			tile.position = Vector3(x * 2, 0, z * 2)
			ground.add_child(tile)

	return region
