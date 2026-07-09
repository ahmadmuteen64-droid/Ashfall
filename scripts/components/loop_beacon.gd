extends Area3D

@export var beacon_id: String = ""

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		var tracker = get_tree().root.get_node_or_null("MainRoot/LoopTracker")
		if tracker and tracker.has_method("visit"):
			tracker.visit(beacon_id)
