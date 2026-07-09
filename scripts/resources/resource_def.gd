# ResourceDef.gd — Custom Resource class defining a collectible resource type
# All resource types in Aperture are defined as .tres files using this class
class_name ResourceDef
extends Resource

enum Category {STONE, CRYSTAL, BOTANICAL, ANIMAL, DECOMPOSITION, WATER, METAL, ARTIFACT}
enum Scarcity {ABUNDANT, COMMON, UNCOMMON, RARE, UNIQUE}

@export var resource_id: String = ""
@export var display_name: String = ""
@export var category: Category = Category.STONE
@export var description: String = ""
@export_multiline var ecological_notes: String = ""
@export var scarcity: Scarcity = Scarcity.COMMON
@export var renewable: bool = false
@export var regeneration_time_days: float = 365.0  # In-game days
@export var harvest_tool_required: String = ""  # Empty = bare hands
@export var harvest_yield_min: int = 1
@export var harvest_yield_max: int = 3
@export var codex_entry_id: String = ""
@export var mesh_variants: Array[PackedScene] = []
@export var spawn_elevation_min: float = -999.0
@export var spawn_elevation_max: float = 999.0
@export var spawn_slope_max: float = 90.0  # Maximum slope in degrees
@export var spawn_moisture_min: float = 0.0
@export var spawn_moisture_max: float = 1.0
@export var spawn_districts: Array[String] = []  # District slugs
@export var companion_species: Array[String] = []  # Resource IDs of plants found nearby
@export var seasonal_available: bool = false
@export var seasonal_months: Array[int] = []  # 1-12, empty = year-round
