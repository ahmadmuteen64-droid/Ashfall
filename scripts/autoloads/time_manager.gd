extends Node

const CYCLE_DURATION: float = 300.0  # 5 min per full cycle

var _time: float = 0.0  # 0.0 = dawn, 0.25 = midday, 0.5 = dusk, 0.75 = midnight
var _sun: DirectionalLight3D = null

# Color temps: dawn 3500K orange, midday 5500K white, dusk 3500K, night 4100K blue
const DAWN_COLOR: Color = Color(1.0, 0.7, 0.4)
const MIDDAY_COLOR: Color = Color(1.0, 0.95, 0.8)
const DUSK_COLOR: Color = Color(1.0, 0.55, 0.3)
const NIGHT_COLOR: Color = Color(0.3, 0.35, 0.7)


func _ready() -> void:
	print("TIME_OK")


func _process(delta: float) -> void:
	_time += delta / CYCLE_DURATION
	if _time >= 1.0:
		_time -= 1.0
	_update_sun()


func _update_sun() -> void:
	if not _sun:
		_sun = _find_sun(get_tree().root)
		if not _sun:
			return
	# Rotate sun: dawn=0° (east), midday=90° (overhead), dusk=180° (west), night=270° (below)
	var angle: float = _time * TAU
	_sun.rotation_degrees = Vector3(-90 + rad_to_deg(angle) * 0.5, rad_to_deg(angle), 0)
	# Color interpolation
	if _time < 0.25:
		_sun.light_color = DAWN_COLOR.lerp(MIDDAY_COLOR, _time / 0.25)
	elif _time < 0.5:
		_sun.light_color = MIDDAY_COLOR.lerp(DUSK_COLOR, (_time - 0.25) / 0.25)
	elif _time < 0.75:
		_sun.light_color = DUSK_COLOR.lerp(NIGHT_COLOR, (_time - 0.5) / 0.25)
	else:
		_sun.light_color = NIGHT_COLOR.lerp(DAWN_COLOR, (_time - 0.75) / 0.25)
	_sun.light_energy = 1.0 if _time < 0.5 else lerp(1.0, 0.15, (_time - 0.5) / 0.5)


func _find_sun(node: Node) -> DirectionalLight3D:
	for child in node.get_children():
		if child is DirectionalLight3D:
			return child
		var found := _find_sun(child)
		if found:
			return found
	return null


func is_daytime() -> bool:
	return _time < 0.5


func get_time() -> float:
	return _time
