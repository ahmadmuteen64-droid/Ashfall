# SpawnTable.gd — Custom Resource defining resource spawn rules for a zone
class_name SpawnTable
extends Resource

@export var zone_slug: String = ""
@export var zone_display_name: String = ""
@export var district_slug: String = ""
@export var spawn_entries: Array[SpawnEntry] = []


# SpawnEntry defines one resource type within a spawn table
class SpawnEntry:
	extends Resource
	@export var resource_id: String = ""
	@export var weight: float = 1.0  # Relative probability
	@export var min_instances: int = 0
	@export var max_instances: int = 10
	@export var cluster_size_min: int = 1
	@export var cluster_size_max: int = 3
	@export var cluster_radius: float = 2.0
	@export var min_distance_between: float = 5.0  # Min separation between spawns
