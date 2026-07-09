# LandmarkConfig.gd — Custom Resource class defining a landmark
class_name LandmarkConfig
extends Resource

enum Tier {T1_HERO, T2_MAJOR, T3_MINOR}

@export var landmark_name: String = ""
@export var landmark_slug: String = ""
@export var tier: Tier = Tier.T2_MAJOR
@export var owning_district: String = ""
@export var description: String = ""
@export var visual_identity: String = ""
@export var navigation_purpose: String = ""
@export var historical_purpose: String = ""
@export var gameplay_purpose: String = ""
@export var future_use: String = ""
@export var lod0_range: float = 30.0
@export var lod1_range: float = 150.0
@export var lod2_range: float = 500.0
@export var primary_interaction: String = ""
@export var secondary_interaction: String = ""
@export var hidden_interaction: String = ""
@export var memory_fragment_id: String = ""
@export var dominant_sound: String = ""
@export var light_quality: String = ""
