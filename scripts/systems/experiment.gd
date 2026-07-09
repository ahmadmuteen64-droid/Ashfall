extends Node
class_name ExperimentEngine

var _reactions: Array[ReactionDef] = []
var _attempts: Array[Dictionary] = []


func _ready() -> void:
	_load_reactions()


func _load_reactions() -> void:
	var dir := DirAccess.open("res://data/reactions/")
	if not dir:
		print("EXPERIMENT: No reactions directory")
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tres"):
			var reaction: ReactionDef = load("res://data/reactions/" + file_name)
			if reaction:
				_reactions.append(reaction)
		file_name = dir.get_next()


func run(input_ids: Array[String], conditions: Dictionary) -> Dictionary:
	var best_match: ReactionDef = null
	for reaction in _reactions:
		if _inputs_match(input_ids, reaction.inputs):
			best_match = reaction
			break

	if not best_match:
		_attempts.append({"inputs": input_ids, "result": "no_match"})
		return {"success": false, "message": "No reaction found for these inputs."}

	# Era gate check
	if best_match.requires_knows != "":
		var codex := get_node_or_null("/root/Codex")
		if codex and not codex.knows(best_match.requires_knows):
			_attempts.append({"inputs": input_ids, "result": "era_gated", "requires": best_match.requires_knows})
			return {"success": false, "message": "You lack the understanding to perform this reaction."}

	# Condition check
	for cond in best_match.conditions:
		if not conditions.has(cond):
			_attempts.append({"inputs": input_ids, "result": "missing_condition", "missing": cond})
			return {"success": false, "message": "Missing condition: " + cond}

	# Success
	var codex := get_node_or_null("/root/Codex")
	if codex and best_match.result_node != "":
		codex.discover(best_match.result_node)
		if codex.has_method("confirm"):
			codex.confirm(best_match.result_node)

	_attempts.append({"inputs": input_ids, "result": "success", "discovered": best_match.result_node})
	var result_data: Dictionary = {
		"success": true,
		"discovered": best_match.result_node,
		"byproducts": best_match.byproducts.duplicate()
	}

	# Add byproducts to inventory
	var inv := get_node_or_null("/root/Inventory")
	if inv:
		for bp in best_match.byproducts:
			inv.add(bp)

	return result_data


func _inputs_match(given: Array[String], required: Array[String]) -> bool:
	if given.size() != required.size():
		return false
	var sorted_given := given.duplicate()
	sorted_given.sort()
	var sorted_req := required.duplicate()
	sorted_req.sort()
	return sorted_given == sorted_req
