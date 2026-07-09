# WorldState.gd — Autoload singleton for global world flags
# Simple key-value store with signal on change.
extends Node

signal flag_changed(key: String, value: Variant)

var _flags: Dictionary = {}


func _ready() -> void:
	print("WORLDSTATE_OK")


func set_flag(key: String, value: Variant) -> void:
	_flags[key] = value
	flag_changed.emit(key, value)


func get_flag(key: String, default: Variant = null) -> Variant:
	return _flags.get(key, default)


func has_flag(key: String) -> bool:
	return _flags.has(key)


func clear_flag(key: String) -> void:
	_flags.erase(key)
