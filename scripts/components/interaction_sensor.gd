extends Area3D

@export var sensor_range: float = 3.0

var _nearest: Node = null


func _ready() -> void:
	var shape := CollisionShape3D.new()
	var sphere := SphereShape3D.new()
	sphere.radius = sensor_range
	shape.shape = sphere
	add_child(shape)
	print("SENSOR_READY range:", sensor_range)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		print("SENSOR_INPUT: interact pressed, nearest=", _nearest.name if _nearest else "none")
		if _nearest and _nearest.has_method("interact"):
			_nearest.interact(get_parent())


func _physics_process(_delta: float) -> void:
	var best: Node = null
	var best_dist: float = INF
	for body in get_overlapping_bodies():
		if body.is_in_group("interactable"):
			var dist: float = global_position.distance_to(body.global_position)
			if dist < best_dist:
				best_dist = dist
				best = body
	for area in get_overlapping_areas():
		if area.is_in_group("interactable"):
			var dist: float = global_position.distance_to(area.global_position)
			if dist < best_dist:
				best_dist = dist
				best = area
	if best != _nearest:
		print("SENSOR_NEAR:", best.name if best else "none")
	_nearest = best
