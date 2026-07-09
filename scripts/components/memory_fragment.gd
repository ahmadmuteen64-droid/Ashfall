# memory_fragment.gd — Triggered on examine; shows brief text + writes to journal
extends Node

@export var fragment_id: String = ""
@export var text: String = ""
@export var trigger_knowledge: String = ""
var _triggered: bool = false


func _ready() -> void:
	var parent := get_parent()
	if parent and parent.has_signal("interacted"):
		parent.interacted.connect(_on_interacted)


func _on_interacted(id: String, type: int) -> void:
	if _triggered or type != 0:  # EXAMINE only
		return
	_triggered = true
	print("MEMORY:" + fragment_id)
	# Trigger knowledge if specified
	if trigger_knowledge != "":
		var codex := get_node_or_null("/root/Codex")
		if codex:
			codex.discover(trigger_knowledge)
