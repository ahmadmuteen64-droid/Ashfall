extends Node3D
class_name CameraRig

@export var height: float = 15.0
@export var distance: float = 0.0
@export var pitch_deg: float = 45.0
@export var follow_speed: float = 5.0

var _camera: Camera3D


func _ready() -> void:
	_camera = get_node_or_null("Camera3D")
	if not _camera:
		_camera = Camera3D.new()
		_camera.name = "Camera3D"
		_camera.current = true
		add_child(_camera, true)
	_camera.rotation_degrees = Vector3(-pitch_deg, 0, 0)
	print("CAMERA_OK")


func _physics_process(delta: float) -> void:
	var target = _recursive_search(get_tree().root)
	if target:
		var desired = target.global_position + Vector3(0, height, distance)
		global_position = global_position.lerp(desired, follow_speed * delta)


func _recursive_search(node: Node) -> Node3D:
	if node.name == "CameraTarget":
		var n3d = node as Node3D
		if n3d:
			return n3d
	for child in node.get_children():
		var found = _recursive_search(child)
		if found:
			return found
	return null
