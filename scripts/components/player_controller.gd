extends CharacterBody3D

## First-person player controller with proper FPS mouse look.
##
## Yaw (mouse X) rotates the Player body so movement follows the camera.
## Pitch (mouse Y) rotates the Head node, clamped to avoid flipping.
## Camera3D is a child of Head.

# ── Movement ────────────────────────────────────────────
@export var speed: float = 6.0
@export var acceleration: float = 20.0
@export var friction: float = 15.0
@export var jump_height: float = 2.0
@export var sprint_multiplier: float = 1.6
@export var glide_duration: float = 1.0
@export var max_air_jumps: int = 2

# ── Mouse look ──────────────────────────────────────────
@export var mouse_sensitivity: float = 0.003
@export var pitch_min: float = -89.0
@export var pitch_max: float = 89.0

var _gravity: float = 9.8
var _jump_velocity: float = 0.0
var _input_dir: Vector2 = Vector2.ZERO
var _is_sprinting: bool = false
var _is_gliding: bool = false
var _glide_timer: float = 0.0
var _can_wall_jump: bool = false
var _air_jumps_remaining: int = 0

@onready var _head: Node3D = $Head
@onready var _camera: Camera3D = $Head/Camera3D
@onready var _wind_particles: GPUParticles3D = $WindParticles


func _ready() -> void:
	_jump_velocity = sqrt(2.0 * _gravity * jump_height)
	_camera.current = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	print("PLAYER_OK")


# ── Mouse look & input ──────────────────────────────────

func _unhandled_input(event: InputEvent) -> void:
	# Mouse look
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Yaw: rotate the whole body left/right
		rotate_y(-event.relative.x * mouse_sensitivity)
		# Pitch: rotate the head up/down, clamp to avoid flipping
		_head.rotate_x(-event.relative.y * mouse_sensitivity)
		_head.rotation.x = clampf(_head.rotation.x, deg_to_rad(pitch_min), deg_to_rad(pitch_max))

	# Escape to toggle mouse capture
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			else:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# Click to re-capture mouse
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# FOV with scroll wheel
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_camera.fov = clampf(_camera.fov - 2.0, 30.0, 120.0)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_camera.fov = clampf(_camera.fov + 2.0, 30.0, 120.0)


# ── Movement ─────────────────────────────────────────────

func _physics_process(delta: float) -> void:
	_is_sprinting = Input.is_action_pressed("sprint")
	_input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")

	var did_jump := false

	# Refill air jumps on landing
	if is_on_floor():
		_air_jumps_remaining = max_air_jumps
		_is_gliding = false
		_glide_timer = 0.0
		_can_wall_jump = false

	# Wall glide — hold sprint against a wall to slide down
	if not is_on_floor() and is_on_wall() and _is_sprinting:
		if not _is_gliding:
			_is_gliding = true
			_glide_timer = 0.0
		_glide_timer += delta
		if _glide_timer <= glide_duration:
			velocity.y = maxf(velocity.y, -_gravity * 0.3)
			_can_wall_jump = true
			var wn := get_wall_normal()
			velocity.x += wn.x * 2.0 * delta
			velocity.z += wn.z * 2.0 * delta
		else:
			_is_gliding = false
			_can_wall_jump = false

	# Jump — ground first, then wall, then air
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = _jump_velocity
			did_jump = true
		elif _can_wall_jump and _is_gliding:
			velocity.y = _jump_velocity
			var wn := get_wall_normal()
			velocity.x = wn.x * speed * 1.5
			velocity.z = wn.z * speed * 1.5
			_is_gliding = false
			_can_wall_jump = false
			did_jump = true
		elif _air_jumps_remaining > 0:
			velocity.y = _jump_velocity
			_air_jumps_remaining -= 1
			did_jump = true

	# Gravity
	if not is_on_floor():
		if _is_gliding:
			velocity.y -= _gravity * 0.15 * delta
		else:
			velocity.y -= _gravity * delta
	else:
		if not did_jump:
			velocity.y = -0.5

	# Horizontal movement — relative to player's facing direction
	var cur_speed := speed * (sprint_multiplier if _is_sprinting else 1.0)
	var direction := (transform.basis * Vector3(_input_dir.x, 0, _input_dir.y)).normalized()

	var target_vel := direction * cur_speed
	if direction.length() > 0.01:
		velocity.x = move_toward(velocity.x, target_vel.x, acceleration * delta)
		velocity.z = move_toward(velocity.z, target_vel.z, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		velocity.z = move_toward(velocity.z, 0, friction * delta)

	move_and_slide()

	# Wind particles — emit when gliding or falling fast
	if _wind_particles:
		var in_air := not is_on_floor()
		var moving_fast := velocity.length() > speed * 1.2
		_wind_particles.emitting = in_air and (_is_gliding or moving_fast)
