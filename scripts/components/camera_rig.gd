extends Node3D
class_name CameraRig

## 3rd-person orthographic camera rig — pixel-perfect voxel rendering.
##
## Standing Rule: Everything in the game world is Voxels per pixel size.
## Orthographic projection ensures 1 world unit = 1 pixel at the target
## internal resolution (640×360), regardless of distance.
##
## Controls:
##   Right-click drag  → orbit (yaw + pitch)
##   Scroll wheel      → zoom in / out (adjusts ortho size)
##   V (toggle)        → swap shoulder side

@export var follow_target: NodePath
@export var follow_speed: float = 8.0
@export var orbit_sensitivity: float = 0.25
@export var pitch_min: float = -80.0
@export var pitch_max: float = -10.0
@export var zoom_min: float = 0.25
@export var zoom_max: float = 4.0
@export var zoom_default: float = 1.0
@export var zoom_step: float = 0.125
@export var shoulder_offset: float = 0.6

# Private state
var _yaw: float = 180.0
var _pitch: float = -45.0
var _zoom: float = 1.0
var _shoulder_side: int = 1
var _is_orbiting: bool = false

@onready var _spring_arm: SpringArm3D = $SpringArm3D
@onready var _camera: Camera3D = $SpringArm3D/Camera3D

const BASE_ORTHO_SIZE: float = 180.0
const CAMERA_DISTANCE: float = 40.0


func _ready() -> void:
	_camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	_camera.current = true
	_zoom = zoom_default
	_apply_ortho_size()
	_apply_rotation()
	_spring_arm.spring_length = CAMERA_DISTANCE
	_spring_arm.position = Vector3(shoulder_offset * _shoulder_side, 0, 0)
	print("CAMERA_RIG_OK  ortho_size:%.1f  zoom:%.2f  pitch:%.1f  yaw:%.1f" % [
		_camera.size, _zoom, _pitch, _yaw
	])


func _physics_process(delta: float) -> void:
	var target: Node3D = _resolve_target()
	if target:
		var desired: Vector3 = target.global_position
		global_position = global_position.lerp(desired, follow_speed * delta)
	var target_offset: float = shoulder_offset * _shoulder_side
	_spring_arm.position.x = move_toward(_spring_arm.position.x, target_offset, 2.0 * delta)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				_is_orbiting = true
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			else:
				_is_orbiting = false
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom = clampf(_zoom + zoom_step, zoom_min, zoom_max)
			_apply_ortho_size()
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom = clampf(_zoom - zoom_step, zoom_min, zoom_max)
			_apply_ortho_size()
	if event is InputEventMouseMotion and _is_orbiting:
		_yaw   -= event.relative.x * orbit_sensitivity
		_pitch -= event.relative.y * orbit_sensitivity
		_pitch  = clampf(_pitch, pitch_min, pitch_max)
		_apply_rotation()
	if event is InputEventKey and event.pressed and event.keycode == KEY_V:
		_shoulder_side *= -1


func get_active_camera() -> Camera3D:
	return _camera


func _apply_rotation() -> void:
	rotation_degrees = Vector3(_pitch, _yaw, 0)


func _apply_ortho_size() -> void:
	_camera.size = BASE_ORTHO_SIZE / _zoom


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
