extends Node
class_name VoxelSimEngine
## Pure-logic simulation engine for voxel phase changes.
## Given a VoxelType and a temperature, computes the resulting phase state
## and the type it transforms into.


## Returns the phase state for the given voxel type at the given temperature.
func get_phase_at(vtype: VoxelType, temperature: float) -> int:
	if not vtype:
		return VoxelType.PhaseState.SOLID
	return vtype.get_phase_at(temperature)


## Returns the VoxelType that this material becomes at the given temperature.
## Falls back to the original type if no transformation is configured or
## the target type doesn't exist on disk.
func get_transformed_type(vtype: VoxelType, temperature: float) -> VoxelType:
	if not vtype:
		return null

	var phase := get_phase_at(vtype, temperature)
	if phase == vtype.phase_state:
		return vtype  ## No change

	var target_id := ""
	match phase:
		VoxelType.PhaseState.LIQUID:
			if vtype.phase_state == VoxelType.PhaseState.SOLID:
				target_id = vtype.state_on_melt
			elif vtype.phase_state == VoxelType.PhaseState.GAS:
				target_id = ""  ## Gas condenses back — uses same type
		VoxelType.PhaseState.GAS:
			target_id = vtype.state_on_boil
		VoxelType.PhaseState.SOLID:
			target_id = vtype.state_on_freeze

	if target_id.is_empty():
		return vtype

	var target := load_type(target_id)
	return target if target else vtype


## Returns the full transformation chain for a voxel type.
## Each entry is a Dictionary with keys:
##   threshold: float, from_phase: int, to_phase: int, target_id: String
func get_transformation_chain(vtype: VoxelType) -> Array[Dictionary]:
	if not vtype:
		return []

	var chain: Array[Dictionary] = []

	match vtype.phase_state:
		VoxelType.PhaseState.SOLID:
			# Solid → Liquid → Gas
			if vtype.melting_point > 0.0:
				chain.append({
					threshold = vtype.melting_point,
					from_phase = VoxelType.PhaseState.SOLID,
					to_phase = VoxelType.PhaseState.LIQUID,
					target_id = vtype.state_on_melt
				})
				# Check if the melted type can also boil
				if not vtype.state_on_melt.is_empty():
					var liquid := load_type(vtype.state_on_melt)
					if liquid and liquid.boiling_point > 0.0:
						chain.append({
							threshold = liquid.boiling_point,
							from_phase = VoxelType.PhaseState.LIQUID,
							to_phase = VoxelType.PhaseState.GAS,
							target_id = liquid.state_on_boil
						})

		VoxelType.PhaseState.LIQUID:
			# Liquid → Gas (heat) and Liquid → Solid (cool)
			if vtype.boiling_point > 0.0:
				chain.append({
					threshold = vtype.boiling_point,
					from_phase = VoxelType.PhaseState.LIQUID,
					to_phase = VoxelType.PhaseState.GAS,
					target_id = vtype.state_on_boil
				})
			if vtype.freezing_point > 0.0:
				chain.append({
					threshold = vtype.freezing_point,
					from_phase = VoxelType.PhaseState.LIQUID,
					to_phase = VoxelType.PhaseState.SOLID,
					target_id = vtype.state_on_freeze
				})

		VoxelType.PhaseState.GAS:
			# Gas → Liquid (cool)
			if vtype.boiling_point > 0.0:
				chain.append({
					threshold = vtype.boiling_point,
					from_phase = VoxelType.PhaseState.GAS,
					to_phase = VoxelType.PhaseState.LIQUID,
					target_id = vtype.state_on_freeze  ## condensation target
				})

	return chain


## Loads a VoxelType resource by its string ID.
func load_type(type_id: String) -> VoxelType:
	if type_id.is_empty():
		return null
	var path := "res://data/voxel/types/" + type_id + ".tres"
	if ResourceLoader.exists(path):
		return load(path)
	return null


## Scans data/voxel/types/ and returns all voxel type IDs.
func get_all_type_ids() -> Array[String]:
	var ids: Array[String] = []
	var dir := DirAccess.open("res://data/voxel/types/")
	if not dir:
		return ids
	dir.list_dir_begin()
	var fn := dir.get_next()
	while fn != "":
		if fn.ends_with(".tres"):
			var full_path := "res://data/voxel/types/" + fn
			var vt: VoxelType = load(full_path)
			if vt and not vt.id.is_empty():
				ids.append(vt.id)
		fn = dir.get_next()
	ids.sort()
	return ids


## Returns a human-readable label for a phase state.
func get_phase_label(phase: int) -> String:
	match phase:
		VoxelType.PhaseState.SOLID:
			return "SOLID"
		VoxelType.PhaseState.LIQUID:
			return "LIQUID"
		VoxelType.PhaseState.GAS:
			return "GAS"
	return "UNKNOWN"


## Returns a display color for a phase state.
func get_phase_color(phase: int) -> Color:
	match phase:
		VoxelType.PhaseState.SOLID:
			return Color(0.6, 0.55, 0.5)    ## Grey-brown
		VoxelType.PhaseState.LIQUID:
			return Color(0.2, 0.5, 0.9)      ## Blue
		VoxelType.PhaseState.GAS:
			return Color(0.85, 0.85, 0.9)    ## White-grey
	return Color.WHITE
