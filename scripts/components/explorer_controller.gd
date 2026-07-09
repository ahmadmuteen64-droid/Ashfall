# explorer_controller.gd — Simple first-person exploration controller
extends CharacterBody3D

@export var walk_speed: float = 6.0
@export var sprint_speed: float = 10.0
@export var jump_velocity: float = 5.0
@export var mouse_sensitivity: float = 0.003
@export var max_look_angle: float = 85.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") as float
var camera_rotation: Vector2 = Vector2.ZERO


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		camera_rotation.x -= event.relative.y * mouse_sensitivity
		camera_rotation.x = clampf(camera_rotation.x, deg_to_rad(-max_look_angle), deg_to_rad(max_look_angle))
		camera_rotation.y -= event.relative.x * mouse_sensitivity
		$Camera3D.rotation = Vector3(camera_rotation.x, camera_rotation.y, 0)

	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var is_sprinting: bool = Input.is_action_pressed("sprint") and is_on_floor()
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var cam_basis: Basis = $Camera3D.global_transform.basis
	var direction: Vector3 = (cam_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var speed: float = sprint_speed if is_sprinting else walk_speed

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
