# WeatherController.gd — Emergent weather from state, not coin flips (W2)
extends Node

enum WeatherState { CLEAR, OVERCAST, RAIN, FOG, STORM }

var _state: WeatherState = WeatherState.CLEAR
var _temperature: float = 20.0   # °C
var _pressure: float = 1013.0     # hPa
var _humidity: float = 50.0       # %

const MIN_CYCLE: float = 120.0
const MAX_CYCLE: float = 240.0

signal weather_changed(new_state: int)


func _ready() -> void:
	_reset_state()
	print("WEATHER_OK")


func _process(delta: float) -> void:
	# Natural drift of atmospheric variables
	_temperature += (randf() - 0.5) * 0.02
	_pressure += (randf() - 0.5) * 0.05
	_humidity += (randf() - 0.5) * 0.03

	# Clamp to realistic ranges
	_temperature = clampf(_temperature, 5.0, 35.0)
	_pressure = clampf(_pressure, 980.0, 1040.0)
	_humidity = clampf(_humidity, 10.0, 100.0)

	# Weather emerges from the three variables
	_emerge_weather()


func _emerge_weather() -> void:
	var new_state: WeatherState = WeatherState.CLEAR

	if _humidity > 80 and _temperature > 25 and _pressure < 1000:
		new_state = WeatherState.STORM
	elif _humidity > 70 and _pressure < 1005:
		new_state = WeatherState.RAIN
	elif _humidity > 60 and _temperature < 15:
		new_state = WeatherState.FOG
	elif _humidity > 50:
		new_state = WeatherState.OVERCAST
	else:
		new_state = WeatherState.CLEAR

	if new_state != _state:
		_state = new_state
		weather_changed.emit(_state)


func _reset_state() -> void:
	_temperature = randf_range(10.0, 30.0)
	_pressure = randf_range(990.0, 1030.0)
	_humidity = randf_range(30.0, 70.0)


func get_state() -> int:
	return _state


func is_clear() -> bool:
	return _state == WeatherState.CLEAR


func get_variables() -> Dictionary:
	return {"temperature": _temperature, "pressure": _pressure, "humidity": _humidity}
