@tool
class_name VoxelType
extends Resource
## Defines a single voxel block type — material, health, tool requirements, drops.
## Thermal simulation properties added for phase-change physics.

enum PhaseState { SOLID, LIQUID, GAS }         ## Material phases for thermal simulation

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

# ── Thermal / phase-change properties ──────────────────────
@export var melting_point: float = 0.0         ## Temp at which solid → liquid (0 = N/A)
@export var boiling_point: float = 0.0          ## Temp at which liquid → gas (0 = N/A)
@export var freezing_point: float = 0.0         ## Temp at which liquid → solid (0 = N/A)
@export var thermal_conductivity: float = 0.5   ## Heat transfer rate, 0.0–1.0
@export var density: float = 1.0                ## Relative density for fluid simulation
@export var state_on_melt: String = ""           ## Voxel type ID to become on melting
@export var state_on_boil: String = ""           ## Voxel type ID to become on boiling
@export var state_on_freeze: String = ""         ## Voxel type ID to become on freezing
@export var default_temperature: float = 20.0    ## Ambient world temperature
@export var is_flammable: bool = false           ## Can this material catch fire?
@export var phase_state: int = 0                 ## Natural/default state at room temp (0=SOLID, 1=LIQUID, 2=GAS)


func get_effective_health(tool: String = "") -> float:
	if required_tool.is_empty() or tool == required_tool:
		return health * hardness
	return health * hardness * 3.0  ## Wrong tool = 3x penalty


func get_phase_at(temperature: float) -> int:
	## Returns the phase state this material would be in at the given temperature.
	match phase_state:
		PhaseState.SOLID:
			if melting_point > 0.0 and temperature >= melting_point:
				return PhaseState.LIQUID
			return PhaseState.SOLID
		PhaseState.LIQUID:
			if boiling_point > 0.0 and temperature >= boiling_point:
				return PhaseState.GAS
			if freezing_point > 0.0 and temperature <= freezing_point:
				return PhaseState.SOLID
			return PhaseState.LIQUID
		PhaseState.GAS:
			if boiling_point > 0.0 and temperature < boiling_point:
				return PhaseState.LIQUID
			return PhaseState.GAS
	return PhaseState.SOLID
