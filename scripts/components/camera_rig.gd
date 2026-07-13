extends Node3D
class_name CameraRig

## 3rd-person orbit camera rig.
## Attach as a sibling of the player — it follows the target independently
## so camera rotation does not rotate the player body.
##
## Controls:
##   Right-click drag  → orbit (yaw + pitch)
##   Scroll wheel      → zoom in / out
##   V (toggle)        → swap shoulder side

@export var follow_target: NodePath          ## NodePath to the player or a Marker3D
@export var follow_speed: float = 8.0        ## Lerp speed for position follow
@export var orbit_sensitivity: float = 0.25  ## Degrees per pixel of mouse drag
@export var pitch_min: float = -80.0         ## Max look-up angle
@export var pitch_max: float = -10.0         ## Max look-down angle
@export var distance_min: float = 2.0        ## Closest zoom
@export var distance_max: float = 20.0       ## Farthest zoom
@export var distance_default: float = 8.0    ## Starting distance
@export var shoulder_offset: float = 0.6     ## Horizontal offset for over-the-shoulder feel

# Private state
var _yaw: float = 180.0  ## Start behind the player (+Z in Godot's default orientation)
var _pitch: float = -25.0
var _distance: float = distance_default
var _shoulder_side: int = 1                  ## +1 right, -1 left
var _is_orbiting: bool = false

@onready var _spring_arm: SpringArm3D = $SpringArm3D
@onready var _camera: Camera3D = $SpringArm3D/Camera3D


func _ready() -> void:
	_distance = distance_default
	_spring_arm.spring_length = _distance
	_spring_arm.position = Vector3(shoulder_offset * _shoulder_side, 0, 0)
	_camera.current = true
	_apply_rotation()
	print("CAMERA_RIG_OK  distance:", _distance, " pitch:", _pitch, " yaw:", _yaw)


func _physics_process(delta: float) -> void:
	# --- follow target ---
	var target: Node3D = _resolve_target()
	if target:
		var desired: Vector3 = target.global_position
		global_position = global_position.lerp(desired, follow_speed * delta)

	# --- update spring arm shoulder offset ---
	var target_offset: float = shoulder_offset * _shoulder_side
	_spring_arm.position.x = move_toward(_spring_arm.position.x, target_offset, 2.0 * delta)


func _unhandled_input(event: InputEvent) -> void:
	# --- orbit ---
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				_is_orbiting = true
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			else:
				_is_orbiting = false
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

		# --- zoom ---
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_distance = clampf(_distance - 1.0, distance_min, distance_max)
			_spring_arm.spring_length = _distance
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_distance = clampf(_distance + 1.0, distance_min, distance_max)
			_spring_arm.spring_length = _distance

	if event is InputEventMouseMotion and _is_orbiting:
		_yaw   -= event.relative.x * orbit_sensitivity
		_pitch -= event.relative.y * orbit_sensitivity
		_pitch  = clampf(_pitch, pitch_min, pitch_max)
		_apply_rotation()

	# --- shoulder swap ---
	if event is InputEventKey and event.pressed and event.keycode == KEY_V:
		_shoulder_side *= -1


## Returns the Camera3D so other systems (e.g. player movement) can read its basis.
func get_active_camera() -> Camera3D:
	return _camera


func _apply_rotation() -> void:
	rotation_degrees = Vector3(_pitch, _yaw, 0)


func _resolve_target() -> Node3D:
	if not follow_target.is_empty():
		var n := get_node_or_null(follow_target)
		if n is Node3D:
			return n
	# fallback: search for CameraTarget marker
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
