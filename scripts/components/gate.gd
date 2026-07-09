extends Node3D

@export var require_knows: String = ""
@export var require_flag: String = ""
@export var gate_id: String = ""

@onready var _body: StaticBody3D = $BarrierBody
@onready var _is_open: bool = false


func _ready() -> void:
	if require_knows != "":
		var codex := get_node_or_null("/root/Codex")
		if codex and codex.has_signal("node_understood"):
			codex.node_understood.connect(_on_node_understood)
		if codex and codex.knows(require_knows):
			_open()
	if require_flag != "":
		var ws := get_node_or_null("/root/WorldState")
		if ws and ws.has_signal("flag_changed"):
			ws.flag_changed.connect(_on_flag_changed)
		if ws and ws.has_flag(require_flag):
			_open()


func _on_node_understood(id: String) -> void:
	if id == require_knows:
		_open()


func _on_flag_changed(key: String, _value) -> void:
	if key == require_flag:
		_open()


func _open() -> void:
	if _is_open:
		return
	_is_open = true
	if _body:
		_body.collision_layer = 0
		_body.visible = false
	print("GATE_OPEN:" + gate_id)
