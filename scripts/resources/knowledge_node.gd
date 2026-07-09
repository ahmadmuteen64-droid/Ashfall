@tool
class_name KnowledgeNode
extends Resource

enum Confidence { SUSPECTED, TESTED, UNDERSTOOD }

@export var node_id: String = ""
@export var display_name: String = ""
@export var summary: String = ""
@export var links: Array[String] = []
@export var confidence: Confidence = Confidence.SUSPECTED
@export var unlocks: Array[String] = []
