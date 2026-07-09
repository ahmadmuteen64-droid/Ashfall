extends Node

enum WeatherState { CLEAR, OVERCAST }

var _state: WeatherState = WeatherState.CLEAR
var _timer: float = 0.0
const MIN_CYCLE: float = 120.0  # min 2 min between changes
const MAX_CYCLE: float = 240.0  # max 4 min

signal weather_changed(new_state: int)


func _ready() -> void:
	_reset_timer()
	print("WEATHER_OK")


func _process(delta: float) -> void:
	_timer -= delta
	if _timer <= 0.0:
		_toggle()
		_reset_timer()


func _reset_timer() -> void:
	_timer = randf_range(MIN_CYCLE, MAX_CYCLE)


func _toggle() -> void:
	if _state == WeatherState.CLEAR:
		_state = WeatherState.OVERCAST
	else:
		_state = WeatherState.CLEAR
	weather_changed.emit(_state)


func get_state() -> int:
	return _state


func is_clear() -> bool:
	return _state == WeatherState.CLEAR
