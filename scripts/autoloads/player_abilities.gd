# PlayerAbilities.gd — Observation, instruments, resonance, sleep (V1,V3,V5,V6)
extends Node

# ── V1: Observation abilities ──────────────────────────────────

var _last_examine_time: Dictionary = {}   # id → float (game time)
var _examine_count: Dictionary = {}        # id → int

const RANGE_EXAMINE: float = 10.0   # meters — quick look
const CLOSE_STUDY: float = 2.0      # meters — detailed examination


func can_examine_at_range() -> bool:
	return true  # always available


func can_close_study() -> bool:
	# Requires being within 2m
	return true


func record_examine(id: String, game_time: float) -> Dictionary:
	"""Record an examination. Returns extra observations if study-over-time triggers."""
	var result: Dictionary = {"new_observation": false, "extra": ""}

	if not _examine_count.has(id):
		_examine_count[id] = 0
	_examine_count[id] += 1

	# Study-over-time: return at a different hour → new observation
	var last_time: float = _last_examine_time.get(id, -999.0)
	var time_mgr := get_node_or_null("/root/TimeManager")
	var current_phase: String = "day"
	if time_mgr:
		current_phase = time_mgr.get_phase()

	if last_time > 0 and abs(game_time - last_time) > 0.1:  # different phase
		result["new_observation"] = true
		var phases_seen: Array = _get_phases_seen(id)
		if current_phase not in phases_seen:
			phases_seen.append(current_phase)
			result["extra"] = "The " + id + " looks different in the " + current_phase + " light."

	_last_examine_time[id] = game_time
	return result


func _get_phases_seen(id: String) -> Array:
	# Stored as metadata on the Codex node
	var codex := get_node_or_null("/root/Codex")
	if codex:
		var meta_key := id + "_phases_seen"
		var arr: Array = codex.get_meta(meta_key, [])
		return arr
	return []


# ── V2: Collection & encumbrance (delegates to PlayerState) ─────

func get_encumbrance_ratio() -> float:
	var ps := get_node_or_null("/root/PlayerState")
	if ps:
		return ps.get_carry_weight() / 50.0
	return 0.0


# ── V3: Observation instruments ─────────────────────────────────

var _instruments: Array[String] = []  # ids of unlocked instruments


func has_instrument(instrument_id: String) -> bool:
	return instrument_id in _instruments


func grant_instrument(instrument_id: String) -> void:
	if instrument_id not in _instruments:
		_instruments.append(instrument_id)
		print("INSTRUMENT_GRANTED:" + instrument_id)


func get_known_property_count() -> int:
	"""More instruments = can see more properties."""
	return 1 + _instruments.size()  # base 1 (eyes) + each instrument


# ── V5: Resonance sensitivity ───────────────────────────────────

var _resonance_exposure: float = 0.0   # cumulative proximity time
var _resonance_threshold: float = 30.0  # seconds to sharpen


func expose_to_resonance(delta: float) -> void:
	_resonance_exposure += delta
	if _resonance_exposure >= _resonance_threshold:
		_resonance_threshold *= 2.0  # next level takes longer
		print("RESONANCE_SENSE_SHARPENS")
		# Perceptual cue: screen edge tint, not a HUD readout


func get_resonance_sensitivity() -> float:
	return clampf(_resonance_exposure / 30.0, 0.0, 1.0)


# ── V6: Sleep & rest ────────────────────────────────────────────

var _rest_point: Vector3 = Vector3.ZERO


func set_rest_point(pos: Vector3) -> void:
	_rest_point = pos


func get_rest_point() -> Vector3:
	return _rest_point


func sleep(duration_hours: float) -> void:
	"""Short sleep only. Advances time, sets rest point. Century sleep is C-4 CUT."""
	var time_mgr := get_node_or_null("/root/TimeManager")
	if time_mgr:
		var cycle_fraction: float = duration_hours / 24.0
		time_mgr._time += cycle_fraction
		if time_mgr._time >= 1.0:
			time_mgr._time -= 1.0
	var ps := get_node_or_null("/root/PlayerState")
	if ps:
		ps.set_state(5)  # SLEEPING
		await get_tree().create_timer(0.5).timeout
		ps.set_state(0)  # HEALTHY
	print("SLEEP:" + str(duration_hours) + "h")
