# TimeManager.gd — 26-minute day cycle with four phases
# W1: Upgraded from 5-min to 26-min day, night is genuinely dark.
extends Node

const CYCLE_DURATION: float = 1560.0  # 26 min per full cycle (W1 spec)

var _time: float = 0.25  # Start at midday
var _sun: DirectionalLight3D = null

const DAWN_COLOR: Color = Color(1.0, 0.7, 0.4)
const MIDDAY_COLOR: Color = Color(1.0, 0.95, 0.8)
const DUSK_COLOR: Color = Color(1.0, 0.55, 0.3)
const NIGHT_COLOR: Color = Color(0.15, 0.18, 0.4)  # Genuinely dark

signal phase_changed(phase: String)


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
	var angle: float = _time * TAU
	_sun.rotation_degrees = Vector3(-90 + rad_to_deg(angle) * 0.5, rad_to_deg(angle), 0)
	if _time < 0.25:
		_sun.light_color = DAWN_COLOR.lerp(MIDDAY_COLOR, _time / 0.25)
	elif _time < 0.5:
		_sun.light_color = MIDDAY_COLOR.lerp(DUSK_COLOR, (_time - 0.25) / 0.25)
	elif _time < 0.75:
		_sun.light_color = DUSK_COLOR.lerp(NIGHT_COLOR, (_time - 0.5) / 0.25)
	else:
		_sun.light_color = NIGHT_COLOR.lerp(DAWN_COLOR, (_time - 0.75) / 0.25)
	_sun.light_energy = 2.0 if _time < 0.4 else lerp(2.0, 0.05, (_time - 0.4) / 0.35)


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


func is_night() -> bool:
	return _time >= 0.5


func get_time() -> float:
	return _time


func get_phase() -> String:
	if _time < 0.25:  return "dawn"
	elif _time < 0.5: return "day"
	elif _time < 0.75: return "dusk"
	else:              return "night"
