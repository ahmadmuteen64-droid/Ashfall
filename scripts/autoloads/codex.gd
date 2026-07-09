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


# ═══════════════════════════════════════════════════════════════
# T2 — Node taxonomy
# ═══════════════════════════════════════════════════════════════

enum NodeType {
	OBSERVATION, MATERIAL, PROPERTY, PROCESS, REACTION,
	TECHNIQUE, TOOL, NATURAL_LAW, THEORY, MEMORY,
	HYPOTHESIS,  # T4 — player-created
}

var _node_types: Dictionary = {}  # id → NodeType


func set_node_type(id: String, ntype: int) -> void:
	_node_types[id] = ntype


func get_node_type(id: String) -> int:
	return _node_types.get(id, NodeType.OBSERVATION)


# ═══════════════════════════════════════════════════════════════
# T3 — Typed edges + propagation
# ═══════════════════════════════════════════════════════════════

enum EdgeType { CAUSATION, CORRELATION, COMPOSITION, CONTEXT, CONTRADICTION, SUPPORT }

var _edges: Array[Dictionary] = []  # [{from, to, type, weight}]


func add_edge(from_id: String, to_id: String, etype: int, weight: float = 1.0) -> void:
	_edges.append({"from": from_id, "to": to_id, "type": etype, "weight": weight})


func get_edges_from(id: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for e in _edges:
		if e["from"] == id:
			result.append(e)
	return result


func get_edges_to(id: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for e in _edges:
		if e["to"] == id:
			result.append(e)
	return result


func propagate_confidence(from_id: String) -> void:
	"""When a node's confidence rises, propagate to linked nodes based on edge type."""
	var from_level: int = nodes.get(from_id, Confidence.UNKNOWN)
	var edges_out: Array = get_edges_from(from_id)

	for e in edges_out:
		var to_id: String = e["to"]
		var etype: int = e["type"]
		var weight: float = e["weight"]

		match etype:
			EdgeType.SUPPORT:
				# Supporting node verified → modest boost to supported node
				if from_level >= Confidence.WORKING:
					if not _corroborations.has(to_id):
						_corroborations[to_id] = 0
					_corroborations[to_id] += int(weight)
					_evaluate_confidence(to_id)
			EdgeType.CONTRADICTION:
				# Contradicting node verified → penalty to contradicted node
				if from_level >= Confidence.WORKING:
					if not _contradictions.has(to_id):
						_contradictions[to_id] = 0
					_contradictions[to_id] += int(weight)
					_evaluate_confidence(to_id)
			EdgeType.COMPOSITION:
				# Understanding a component helps understand the whole
				if from_level >= Confidence.PARTIAL:
					if not _corroborations.has(to_id):
						_corroborations[to_id] = 0
					_corroborations[to_id] += 1
					_evaluate_confidence(to_id)
			EdgeType.CAUSATION:
				# Understanding a cause helps understand the effect
				if from_level >= Confidence.WORKING:
					if not _corroborations.has(to_id):
						_corroborations[to_id] = 0
					_corroborations[to_id] += 1
					_evaluate_confidence(to_id)


func get_all_edges() -> Array[Dictionary]:
	return _edges.duplicate()


# ═══════════════════════════════════════════════════════════════
# T4 — Hypothesis and theory lifecycle
# ═══════════════════════════════════════════════════════════════

var _hypotheses: Dictionary = {}     # id → {statement, creator_context, created_at}
var _overturned: Array[String] = []  # ids of overturned theories


func create_hypothesis(id: String, statement: String, context: String = "") -> void:
	"""Player deliberately creates a hypothesis. Never auto-generated."""
	_hypotheses[id] = {
		"statement": statement,
		"context": context,
		"created_at": Time.get_ticks_msec(),
	}
	set_node_type(id, NodeType.HYPOTHESIS)
	if nodes.get(id, Confidence.UNKNOWN) == Confidence.UNKNOWN:
		nodes[id] = Confidence.GLIMPSED


func test_hypothesis(id: String, success: bool) -> void:
	"""Test result: success confirms, failure may overturn."""
	var current: int = nodes.get(id, Confidence.UNKNOWN)
	if success:
		if current < Confidence.WORKING:
			nodes[id] = Confidence.WORKING
			confidence_changed.emit(id, current, Confidence.WORKING)
		add_predictive_success(id)
	else:
		# Failure can overturn a theory
		if current >= Confidence.WORKING:
			_overturned.append(id)
			nodes[id] = Confidence.PARTIAL  # drops but doesn't vanish
			confidence_changed.emit(id, current, Confidence.PARTIAL)
			# A broader theory may form — UI says "Your understanding deepened"
		record_contradiction(id)


func get_hypothesis(id: String) -> Dictionary:
	return _hypotheses.get(id, {})


func get_all_hypotheses() -> Array[String]:
	return _hypotheses.keys()


func is_overturned(id: String) -> bool:
	return id in _overturned
