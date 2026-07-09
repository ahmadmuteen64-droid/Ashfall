# Codex.gd — Autoload singleton for the player's knowledge graph
# Phase T1: 6-stage confidence replacing old 3-level system.
# Unknown(0)→Glimpsed(1)→Partial(2)→Working(3)→Verified(4)→Mastery(5)
extends Node

enum Confidence { UNKNOWN, GLIMPSED, PARTIAL, WORKING, VERIFIED, MASTERY }

signal observed(id: String)
signal node_understood(id: String)
signal confidence_changed(id: String, old_level: int, new_level: int)
signal pattern_ready(type_key: String)

# Core data stores
var observations: Dictionary = {}        # id → int (observe count)
var nodes: Dictionary = {}               # id → int (Confidence enum value)
var _knowledge: Dictionary = {}          # id → Resource (KnowledgeNode .tres)
var _type_counts: Dictionary = {}        # type_key → int
var _observation_contexts: Dictionary = {}  # id → Array[String] (context tags)

# Confidence driver records per node
var _repetition_count: Dictionary = {}   # id → int
var _varied_contexts: Dictionary = {}    # id → Array[String]
var _corroborations: Dictionary = {}     # id → int
var _predictive_successes: Dictionary = {}  # id → int
var _contradictions: Dictionary = {}     # id → int
var _context_failures: Dictionary = {}   # id → int


func _ready() -> void:
	_load_knowledge_nodes()
	print("CODEX_OK")


func _load_knowledge_nodes() -> void:
	var dir := DirAccess.open("res://data/codex/")
	if not dir:
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tres"):
			var kn: Resource = load("res://data/codex/" + file_name)
			if kn:
				var nid_raw = kn.get("node_id")
				var nid: String = str(nid_raw) if nid_raw != null else ""
				if nid != "":
					_knowledge[nid] = kn
		file_name = dir.get_next()


# ── Observation ────────────────────────────────────────────────

func observe(id: String, type_key: String = "", context: String = "") -> void:
	if not observations.has(id):
		observations[id] = 0
	observations[id] += 1

	# Track context for varied-context verification
	if context != "":
		if not _observation_contexts.has(id):
			_observation_contexts[id] = []
		var ctxs: Array = _observation_contexts[id]
		if context not in ctxs:
			ctxs.append(context)
			_varied_contexts[id] = ctxs.size()

	# Track repetition
	if not _repetition_count.has(id):
		_repetition_count[id] = 0
	_repetition_count[id] += 1

	observed.emit(id)

	if type_key != "":
		if not _type_counts.has(type_key):
			_type_counts[type_key] = 0
		_type_counts[type_key] += 1
		if _type_counts[type_key] >= 3:
			pattern_ready.emit(type_key)

	# Auto-evaluate confidence after observation
	_evaluate_confidence(id)


# ── Confidence evaluation ──────────────────────────────────────

func _evaluate_confidence(id: String) -> void:
	var old_level: int = nodes.get(id, Confidence.UNKNOWN)
	var new_level: int = _calculate_confidence(id)

	if new_level != old_level:
		var prev := old_level
		nodes[id] = new_level
		confidence_changed.emit(id, prev, new_level)
	else:
		nodes[id] = new_level


func _calculate_confidence(id: String) -> int:
	var count: int = observations.get(id, 0)

	# Base level from repetition
	if count == 0:
		return Confidence.UNKNOWN
	elif count == 1:
		return Confidence.GLIMPSED
	elif count <= 3:
		pass  # GLIMPSED baseline, may promote
	else:
		pass  # higher baseline

	# Score-based approach for levels 2-5
	var score: int = 0

	# Repetition: each observation beyond the first
	var reps: int = _repetition_count.get(id, count)
	score += min(reps * 1, 10)

	# Varied context verification
	var ctxs: int = _varied_contexts.get(id, 0)
	score += ctxs * 3

	# Corroboration from other nodes
	var corr: int = _corroborations.get(id, 0)
	score += corr * 2

	# Predictive success
	var pred: int = _predictive_successes.get(id, 0)
	score += pred * 4

	# Contradictions reduce score
	var cont: int = _contradictions.get(id, 0)
	score -= cont * 5

	# Context failures reduce score
	var cfails: int = _context_failures.get(id, 0)
	score -= cfails * 3

	# Map score to confidence level
	if score <= 2:
		return Confidence.GLIMPSED
	elif score <= 6:
		return Confidence.PARTIAL
	elif score <= 14:
		return Confidence.WORKING
	elif score <= 24:
		return Confidence.VERIFIED
	else:
		return Confidence.MASTERY


# ── Confidence drivers ─────────────────────────────────────────

func add_corroboration(id: String) -> void:
	if not _corroborations.has(id):
		_corroborations[id] = 0
	_corroborations[id] += 1
	_evaluate_confidence(id)


func add_predictive_success(id: String) -> void:
	if not _predictive_successes.has(id):
		_predictive_successes[id] = 0
	_predictive_successes[id] += 1
	_evaluate_confidence(id)


func record_contradiction(id: String) -> void:
	if not _contradictions.has(id):
		_contradictions[id] = 0
	_contradictions[id] += 1
	_evaluate_confidence(id)


func record_context_failure(id: String) -> void:
	if not _context_failures.has(id):
		_context_failures[id] = 0
	_context_failures[id] += 1
	_evaluate_confidence(id)


# ── Discovery & confirmation ───────────────────────────────────

func knows(id: String) -> bool:
	return nodes.get(id, Confidence.UNKNOWN) > Confidence.UNKNOWN


func discover(id: String) -> void:
	if nodes.get(id, Confidence.UNKNOWN) == Confidence.UNKNOWN:
		nodes[id] = Confidence.GLIMPSED
		confidence_changed.emit(id, Confidence.UNKNOWN, Confidence.GLIMPSED)


func confirm(id: String) -> void:
	if nodes.get(id, Confidence.UNKNOWN) > Confidence.UNKNOWN:
		node_understood.emit(id)


func get_confidence(id: String) -> int:
	return nodes.get(id, Confidence.UNKNOWN)


func get_confidence_name(id: String) -> String:
	var level: int = get_confidence(id)
	match level:
		Confidence.UNKNOWN:   return "Unknown"
		Confidence.GLIMPSED:  return "Glimpsed"
		Confidence.PARTIAL:   return "Partial"
		Confidence.WORKING:   return "Working"
		Confidence.VERIFIED:  return "Verified"
		Confidence.MASTERY:   return "Mastery"
	return "Unknown"


# ── Knowledge node resource access ─────────────────────────────

func get_knowledge_node(id: String) -> Resource:
	return _knowledge.get(id, null)


func get_all_nodes() -> Array:
	var result: Array = []
	for id in _knowledge:
		result.append(_knowledge[id])
	return result


func get_all_discovered() -> Array[String]:
	var out: Array[String] = []
	for id in nodes:
		if nodes[id] > Confidence.UNKNOWN:
			out.append(id)
	return out
