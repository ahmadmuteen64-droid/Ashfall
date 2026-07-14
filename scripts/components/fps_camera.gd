extends Camera3D

## Switchable FPS / TPS camera — independent of the Player node.
##
## V toggles between first-person and third-person.
## FPS: camera at head, body meshes hidden (shadow-only).
## TPS: camera orbits behind player, full body visible, controls inverted.
## Movement code reads this camera's basis for direction.

@export var follow_target: NodePath
@export var mouse_sensitivity: float = 0.2
@export var pitch_min: float = -89.0
@export var pitch_max: float = 89.0
@export var eye_height: float = 0.0

# ── Third-person settings ───────────────────────────────
@export var tps_distance: float = 5.0
@export var tps_height: float = 1.5
@export var tps_distance_min: float = 1.5
@export var tps_distance_max: float = 15.0

var _yaw: float = 0.0
var _pitch: float = 0.0
var _mouse_captured: bool = false
var _is_third_person: bool = false


func _ready() -> void:
	current = true
	near = 0.05
	far = 500.0
	fov = 75.0
	_capture_mouse()
	_update_body_visibility()
	print("FPS_CAMERA_OK  fov:%.1f  eye:%.1f" % [fov, eye_height])


func _physics_process(_delta: float) -> void:
	var target := _resolve_target()
	if not target:
		return

	var head_pos := target.global_position + Vector3(0, eye_height, 0)

	if _is_third_person:
		# Orbit behind the player at tps_distance
		var yaw_rad := deg_to_rad(_yaw)
		var pitch_rad := deg_to_rad(_pitch)
		var orbit_offset := Vector3(0, 0, tps_distance)
		orbit_offset = orbit_offset.rotated(Vector3.RIGHT, -pitch_rad)
		orbit_offset = orbit_offset.rotated(Vector3.UP, -yaw_rad)
		global_position = head_pos + Vector3(0, tps_height, 0) + orbit_offset
		look_at(head_pos, Vector3.UP)
	else:
		# FPS — snap to head, rotation set in _input via mouse
		global_position = head_pos


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_ESCAPE:
				if _mouse_captured:
					Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
					_mouse_captured = false
				else:
					_capture_mouse()
			KEY_V:
				_is_third_person = not _is_third_person
				_update_body_visibility()

	if event is InputEventMouseMotion and _mouse_captured:
		if _is_third_person:
			# Inverted both axes — drag-the-world feel
			_yaw += event.relative.x * mouse_sensitivity
			_pitch += event.relative.y * mouse_sensitivity
		else:
			# FPS — direct look
			_yaw -= event.relative.x * mouse_sensitivity
			_pitch -= event.relative.y * mouse_sensitivity
		_pitch = clampf(_pitch, pitch_min, pitch_max)

		if not _is_third_person:
			# FPS — apply rotation directly
			rotation_degrees = Vector3(_pitch, _yaw, 0)
		# TPS rotation is applied in _physics_process via look_at

	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if not _mouse_captured:
					_capture_mouse()
			MOUSE_BUTTON_WHEEL_UP:
				if _is_third_person:
					tps_distance = clampf(tps_distance - 0.5, tps_distance_min, tps_distance_max)
				else:
					fov = clampf(fov - 2.0, 30.0, 120.0)
			MOUSE_BUTTON_WHEEL_DOWN:
				if _is_third_person:
					tps_distance = clampf(tps_distance + 0.5, tps_distance_min, tps_distance_max)
				else:
					fov = clampf(fov + 2.0, 30.0, 120.0)


func _capture_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_mouse_captured = true


func _resolve_target() -> Node3D:
	if not follow_target.is_empty():
		var n := get_node_or_null(follow_target)
		if n is Node3D:
			return n
	return null


func _update_body_visibility() -> void:
	## FPS: body meshes cast shadows only (invisible to camera).
	## TPS: full visible body + shadows.
	var player := _find_player()
	if not player:
		return

	for mesh_name in ["BodyMesh", "CapeMesh"]:
		var mesh := player.get_node_or_null(mesh_name)
		if mesh is GeometryInstance3D:
			if _is_third_person:
				mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
				mesh.visible = true
			else:
				mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY
				mesh.visible = false


func _find_player() -> Node:
	var parent := get_parent()
	if not parent:
		return null
	return parent.get_node_or_null("Player")
