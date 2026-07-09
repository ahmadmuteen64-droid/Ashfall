class_name Interactable
extends Area3D

enum InteractType { EXAMINE, COLLECT, ACTIVATE }

@export var interact_type: InteractType = InteractType.EXAMINE
@export var interactable_id: String = ""

signal interacted(id: String, type: int)


func _ready() -> void:
	add_to_group("interactable")


func interact(by: Node) -> void:
	interacted.emit(interactable_id, interact_type)
	print("INTERACT:" + interactable_id)
