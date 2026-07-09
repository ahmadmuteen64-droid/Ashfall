@tool
class_name ReactionDef
extends Resource

@export var reaction_id: String = ""
@export var inputs: Array[String] = []
@export var conditions: Dictionary = {}
@export var result_node: String = ""
@export var requires_knows: String = ""
@export var byproducts: Array[String] = []
