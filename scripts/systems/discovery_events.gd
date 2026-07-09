# discovery_events.gd — W5: Discovery is an event, not a notification
extends Node

var _last_discovery: String = ""
var _discovery_count: int = 0


func _ready() -> void:
	var codex := get_node_or_null("/root/Codex")
	if codex:
		codex.confidence_changed.connect(_on_confidence_changed)


func _on_confidence_changed(id: String, old_level: int, new_level: int) -> void:
	# Discovery event: reaching VERIFIED or MASTERY
	if new_level >= 3 and old_level < 3:  # WORKING → VERIFIED
		_trigger_discovery(id, "verified")
	elif new_level >= 4 and old_level < 4:  # VERIFIED → MASTERY
		_trigger_discovery(id, "mastery")


func _trigger_discovery(id: String, tier: String) -> void:
	_discovery_count += 1
	_last_discovery = id

	# Non-prescriptive line — never tells the player where to go
	var lines: Array[String] = [
		"You understand: " + id,
		"The pieces fit together: " + id,
		"A connection forms: " + id,
		"Something clicks into place: " + id,
	]
	var msg := lines[_discovery_count % lines.size()]
	print("DISCOVERY:" + id + ":" + tier)
	print(msg)

	# Light-temperature shift
	var sun := _find_sun(get_tree().root)
	if sun:
		sun.light_energy = 3.0  # brief flash
		await get_tree().create_timer(0.3).timeout
		var tm := get_node_or_null("/root/TimeManager")
		if tm and tm.is_daytime():
			sun.light_energy = 2.0


func _find_sun(node: Node) -> DirectionalLight3D:
	for child in node.get_children():
		if child is DirectionalLight3D:
			return child
		var found := _find_sun(child)
		if found:
			return found
	return null
