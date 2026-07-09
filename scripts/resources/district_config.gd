# DistrictConfig.gd — Custom Resource class defining a district
# Each district on each island has a .tres file using this class
class_name DistrictConfig
extends Resource

@export var district_name: String = ""
@export var district_slug: String = ""
@export var island_slug: String = ""
@export var description: String = ""
@export var elevation_min: float = 0.0
@export var elevation_max: float = 10.0
@export var area_approx_m2: float = 1000.0
@export var primary_emotion: String = ""
@export var core_teaching: String = ""
@export var connected_districts: Array[String] = []
@export var landmark_slugs: Array[String] = []  # Slugs of landmarks owned by this district
@export var portal_count: int = 2
@export var estimated_object_count: int = 100
@export var loading_phase: int = 2  # Per the streaming strategy
@export var sun_contribution: float = 1.0  # 0=interior, 1=fully exposed
@export var sky_contribution: float = 1.0
@export var ambient_color: Color = Color(0.4, 0.42, 0.5)
@export var ambient_energy: float = 0.5
@export var fog_enabled: bool = false
@export var fog_density: float = 0.0
@export var dominant_sounds: Array[String] = []
@export var light_quality: String = ""
