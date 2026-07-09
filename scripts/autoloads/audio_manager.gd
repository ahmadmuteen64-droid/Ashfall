# AudioManager.gd — Autoload stub for audio bus hierarchy
# Manages ambient crossfades, SFX routing, and music layers
extends Node

enum AudioBus {MASTER, AMBIENCE, SFX, MUSIC, VOICE}

signal district_audio_changed(from_district: String, to_district: String)

var current_district: String = ""
var crossfade_duration: float = 3.0
var music_layer_1_active: bool = true  # Always-on layer
var music_layer_2_active: bool = false  # On examine
var music_layer_3_active: bool = false  # On crystal/resonance proximity


func _ready() -> void:
	process_priority = -80


func set_district(district_slug: String) -> void:
	if district_slug != current_district:
		var previous := current_district
		current_district = district_slug
		district_audio_changed.emit(previous, district_slug)


func play_sfx(sfx_path: String, position: Vector3 = Vector3.ZERO) -> void:
	pass  # Full implementation in Phase 7


func trigger_music_layer(layer: int, active: bool) -> void:
	match layer:
		2: music_layer_2_active = active
		3: music_layer_3_active = active
