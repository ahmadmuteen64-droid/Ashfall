extends Node3D
class_name CameraRig

## First-person perspective camera — mouse look, no orbit, no zoom.
##
## Mouse captured on game start. Move mouse to look around.
## ESC toggles mouse capture (for UI interaction).
## Camera is locked to player eye level (~1.7 units above feet).

@export var follow_target: NodePath
@export var mouse_sensitivity: float = 3.0
@export var pitch_min: float = -89.0
@export var pitch_max: float = 89.0
@export var fov: float = 75.0
@export var eye_height: float = 1.7

var _yaw: float = 0.0
var _pitch: float = 0.0
var _mouse_captured: bool = false

@onready var _camera: Camera3D = $SpringArm3D/Camera3D


func _ready() -> void:
	_camera.projection = Camera3D.PROJECTION_PERSPECTIVE
	_camera.fov = fov
	_camera.near = 0.05
	_camera.current = true
	_capture_mouse()
	print("CAMERA_RIG_FPS_OK  fov:%.1f  eye:%.1f" % [fov, eye_height])


func _physics_process(_delta: float) -> void:
	var target: Node3D = _resolve_target()
	if target:
		global_position = target.global_position + Vector3(0, eye_height, 0)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			_toggle_mouse()

	if event is InputEventMouseMotion and _mouse_captured:
		_yaw -= event.relative.x * mouse_sensitivity * 0.01
		_pitch -= event.relative.y * mouse_sensitivity * 0.01
		_pitch = clampf(_pitch, pitch_min, pitch_max)
		_apply_rotation()

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and not _mouse_captured:
			_capture_mouse()
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			fov = clampf(fov - 2.0, 30.0, 120.0)
			_camera.fov = fov
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			fov = clampf(fov + 2.0, 30.0, 120.0)
			_camera.fov = fov


func get_active_camera() -> Camera3D:
	return _camera


func get_yaw() -> float:
	return _yaw


func _apply_rotation() -> void:
	rotation_degrees = Vector3(0, _yaw, 0)
	_camera.rotation_degrees = Vector3(_pitch, 0, 0)


func _capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_mouse_captured = true


func _toggle_mouse() -> void:
	if _mouse_captured:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		_mouse_captured = false
	else:
		_capture_mouse()


func _resolve_target() -> Node3D:
	if not follow_target.is_empty():
		var n := get_node_or_null(follow_target)
		if n is Node3D:
			return n
	var found := _find_by_name(get_tree().root, "CameraTarget")
	if found is Node3D:
		return found
	return null


func _find_by_name(node: Node, target_name: String) -> Node:
	if node.name == target_name:
		return node
	for child in node.get_children():
		var r := _find_by_name(child, target_name)
		if r:
			return r
	return null
