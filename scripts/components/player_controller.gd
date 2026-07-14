extends CharacterBody3D

@export var speed: float = 3.0
@export var acceleration: float = 20.0
@export var friction: float = 15.0
@export var jump_height: float = 2.0
@export var sprint_multiplier: float = 1.6
@export var glide_duration: float = 1.0
@export var max_air_jumps: int = 2
@export var rotation_speed: float = 12.0  ## How fast the player turns to face movement/camera direction

var _gravity: float = 9.8
var _jump_velocity: float = 0.0
var _input_dir: Vector2 = Vector2.ZERO
var _is_sprinting: bool = false
var _is_gliding: bool = false
var _glide_timer: float = 0.0
var _can_wall_jump: bool = false
var _air_jumps_remaining: int = 0
@onready var _wind_particles: GPUParticles3D = $WindParticles


func _ready() -> void:
	_jump_velocity = sqrt(2.0 * _gravity * jump_height)
	print("PLAYER_OK")


func _physics_process(delta: float) -> void:
	_is_sprinting = Input.is_action_pressed("sprint")
	_input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")

	var did_jump: bool = false

	# ── Refill air jumps on landing ──────────────────
	if is_on_floor():
		_air_jumps_remaining = max_air_jumps
		_is_gliding = false
		_glide_timer = 0.0
		_can_wall_jump = false

	# ── Wall glide ────────────────────────────────────
	if not is_on_floor() and is_on_wall() and _is_sprinting:
		if not _is_gliding:
			_is_gliding = true
			_glide_timer = 0.0
		_glide_timer += delta
		if _glide_timer <= glide_duration:
			velocity.y = maxf(velocity.y, -_gravity * 0.3)
			_can_wall_jump = true
			var wn: Vector3 = get_wall_normal()
			velocity.x += wn.x * 2.0 * delta
			velocity.z += wn.z * 2.0 * delta
		else:
			_is_gliding = false
			_can_wall_jump = false

	# ── Jump ──────────────────────────────────────────
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = _jump_velocity
			did_jump = true
		elif _can_wall_jump and _is_gliding:
			velocity.y = _jump_velocity
			var wn: Vector3 = get_wall_normal()
			velocity.x = wn.x * speed * 1.5
			velocity.z = wn.z * speed * 1.5
			_is_gliding = false
			_can_wall_jump = false
			did_jump = true
		elif _air_jumps_remaining > 0:
			velocity.y = _jump_velocity
			_air_jumps_remaining -= 1
			did_jump = true

	# ── Gravity ───────────────────────────────────────
	if not is_on_floor():
		if _is_gliding:
			velocity.y -= _gravity * 0.15 * delta
		else:
			velocity.y -= _gravity * delta
	else:
		if not did_jump:
			velocity.y = -0.5

	# ── Movement ──────────────────────────────────────
	var cur_speed: float = speed * (sprint_multiplier if _is_sprinting else 1.0)
	var cam_basis: Basis = _get_camera_basis()
	var world_dir: Vector3 = cam_basis * Vector3(_input_dir.x, 0, _input_dir.y)
	world_dir = world_dir.normalized()

	var target_vel: Vector3 = world_dir * cur_speed
	if world_dir.length() > 0.01:
		velocity.x = move_toward(velocity.x, target_vel.x, acceleration * delta)
		velocity.z = move_toward(velocity.z, target_vel.z, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		velocity.z = move_toward(velocity.z, 0, friction * delta)

	move_and_slide()

	# ── Wind particles: emit when gliding or falling fast ──
	if _wind_particles:
		var in_air := not is_on_floor()
		var moving_fast := velocity.length() > speed * 1.2
		_wind_particles.emitting = in_air and (_is_gliding or moving_fast)

	# ── Rotation: face movement direction (or camera forward when idle) ──
	_apply_facing(delta, world_dir)


func _apply_facing(delta: float, move_dir: Vector3) -> void:
	## FPS mode: player body faces the camera yaw.
	## When actively moving, blends slightly toward movement direction.
	var cam: Camera3D = get_viewport().get_camera_3d()
	if not cam:
		return
	# CameraRig = parent of SpringArm3D = parent of Camera3D
	var cam_rig: Node = cam.get_parent().get_parent()
	if cam_rig and cam_rig.has_method("get_yaw"):
		var target_yaw: float = deg_to_rad(cam_rig.get_yaw())
		if move_dir.length() > 0.01:
			var move_yaw: float = atan2(move_dir.x, move_dir.z)
			target_yaw = move_yaw
		rotation.y = rotate_toward(rotation.y, target_yaw, rotation_speed * delta)


func _get_camera_basis() -> Basis:
	## Returns the horizontal-only basis of the active 3D camera
	## so movement is always relative to where the player is looking.
	var cam: Camera3D = get_viewport().get_camera_3d()
	if cam:
		var b: Basis = cam.global_transform.basis
		# Flatten forward onto XZ plane
		var forward: Vector3 = -b.z
		forward.y = 0.0
		if forward.length_squared() < 0.001:
			return Basis()
		forward = forward.normalized()
		var right: Vector3 = forward.cross(Vector3.UP).normalized()
		return Basis(right, Vector3.UP, forward)
	return Basis()
