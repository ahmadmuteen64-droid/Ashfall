extends Node

@export var observable_id: String = ""
@export var properties: Dictionary = {}
@export var discover_threshold: int = 0
@export var discover_node: String = ""

var _interactable: Node = null


func _ready() -> void:
	_interactable = get_parent()
	if _interactable and _interactable.has_signal("interacted"):
		_interactable.interacted.connect(_on_interacted)


func _on_interacted(id: String, type: int) -> void:
	# InteractType.EXAMINE = 0
	if type == 0:
		var codex := get_node_or_null("/root/Codex")
		if codex and codex.has_method("observe"):
			var type_key: String = properties.get("type", "")
			codex.observe(observable_id, type_key)
			if discover_threshold > 0 and discover_node != "":
				var count: int = codex.observations.get(observable_id, 0)
				if count >= discover_threshold:
					codex.discover(discover_node)
	# InteractType.COLLECT = 1
	elif type == 1:
		var inv := get_node_or_null("/root/Inventory")
		if inv and inv.has_method("add"):
			inv.add(observable_id)
	# InteractType.ACTIVATE = 2
	elif type == 2:
		var station := get_node_or_null("/root/MainRoot/ExperimentStationUI")
		if station and station.has_method("open"):
			station.open(_interactable)
