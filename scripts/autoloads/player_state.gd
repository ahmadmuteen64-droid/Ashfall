# PlayerState.gd — Player state machine (V4)
# Surviving states after C-3 cuts: HEALTHY, EXHAUSTED, OVERLOADED, FOCUSED, SLEEPING, RESEARCHING
# CUT: HUNGRY, BLOOD_DEFICIENCY, POISONED, ILL, SUNLIGHT_EXPOSURE
extends Node

enum State { HEALTHY, EXHAUSTED, OVERLOADED, FOCUSED, SLEEPING, RESEARCHING }

var _current: int = State.HEALTHY
var _carry_weight: float = 0.0
var _max_carry: float = 50.0  # kg

signal state_changed(old_state: int, new_state: int)


func _ready() -> void:
	print("PLAYERSTATE_OK")


func set_state(new_state: int) -> void:
	if new_state != _current:
		var old := _current
		_current = new_state
		state_changed.emit(old, new_state)


func get_state() -> int:
	return _current


func add_weight(kg: float) -> void:
	_carry_weight += kg
	if _carry_weight > _max_carry:
		set_state(State.OVERLOADED)


func remove_weight(kg: float) -> void:
	_carry_weight = max(0.0, _carry_weight - kg)
	if _carry_weight <= _max_carry and _current == State.OVERLOADED:
		set_state(State.HEALTHY)


func get_carry_weight() -> float:
	return _carry_weight


func is_overloaded() -> bool:
	return _current == State.OVERLOADED
