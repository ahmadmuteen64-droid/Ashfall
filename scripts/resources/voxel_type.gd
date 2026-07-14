@tool
class_name VoxelType
extends Resource
## Defines a single voxel block type — material, health, tool requirements, drops.

@export var id: String = ""                    ## Unique identifier (e.g. "stone", "oak_wood")
@export var display_name: String = ""          ## Human-readable name
@export var material: Material                 ## StandardMaterial3D for rendering
@export var health: float = 10.0               ## Hit points before destruction
@export var required_tool: String = ""         ## Tool needed ("" = bare hands OK, "pickaxe", "axe")
@export var tool_multiplier: float = 1.0       ## Damage multiplier when using correct tool
@export var drop_item: String = ""             ## Item ID dropped on destruction ("" = self id)
@export var drop_count: int = 1                ## How many items drop
@export var hardness: float = 1.0              ## 0=instant, 1=normal, 3=hard (relative damage divider)
@export var is_ground: bool = false            ## Ground plane — indestructible
@export var description: String = ""           ## Flavor text for Codex
@export var era_tag: String = ""               ## Chronology era for reaction system


func get_effective_health(tool: String = "") -> float:
	if required_tool.is_empty() or tool == required_tool:
		return health * hardness
	return health * hardness * 3.0  ## Wrong tool = 3x penalty
