extends MeshInstance3D
class_name Cape

## Verlet-integrated cloth cape — 10×14 vertex grid, each vertex simulated independently.
## Top rows pinned to player shoulders. Rest responds to gravity, wind (player velocity),
## and per-state multipliers (walk/run/jump/glide/fall).

const COLS: int = 10
const ROWS: int = 14
const VERT_COUNT: int = COLS * ROWS
const PIN_ROWS: int = 2
const CONSTRAINT_ITERS: int = 5

@export var rest_x: float = 0.15
@export var rest_y: float = 0.15

@export var gravity: float = 9.8
@export var damping: float = 0.97        ## 1.0 = no energy loss
@export var stiffness: float = 0.4       ## Constraint correction strength
@export var wind_scale: float = 8.0      ## How much player velocity pushes fabric
@export var flutter_amp: float = 0.6     ## Amplitude of idle flutter oscillation

var _pos: PackedVector3Array
var _prev: PackedVector3Array
var _mesh: ArrayMesh
var _base_y: float = 0.85
var _base_z: float = -0.35
var _motion: String = "idle"


func _ready() -> void:
	_pos = PackedVector3Array()
	_prev = PackedVector3Array()
	_pos.resize(VERT_COUNT)
	_prev.resize(VERT_COUNT)

	var total_w: float = rest_x * float(COLS - 1)
	var start_x: float = -total_w * 0.5

	for row in range(ROWS):
		for col in range(COLS):
			var idx: int = row * COLS + col
			var v := Vector3(start_x + float(col) * rest_x, -float(row) * rest_y, 0.0)
			_pos[idx] = v
			_prev[idx] = v

	_mesh = ArrayMesh.new()
	_build_mesh()
	mesh = _mesh
	print("CAPE_OK  verts:", VERT_COUNT)


func _build_mesh() -> void:
	var indices := PackedInt32Array()
	for row in range(ROWS - 1):
		for col in range(COLS - 1):
			var a: int = row * COLS + col
			var b: int = a + 1
			var c: int = a + COLS
			var d: int = c + 1
			indices.append_array([a, b, d, a, d, c])

	var normals := PackedVector3Array()
	normals.resize(VERT_COUNT)
	normals.fill(Vector3.BACK)

	var uvs := PackedVector2Array()
	uvs.resize(VERT_COUNT)
	for row in range(ROWS):
		for col in range(COLS):
			uvs[row * COLS + col] = Vector2(float(col) / float(COLS - 1), float(row) / float(ROWS - 1))

	var arrays: Array = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = _pos
	arrays[Mesh.ARRAY_NORMAL] = normals
	arrays[Mesh.ARRAY_INDEX] = indices
	arrays[Mesh.ARRAY_TEX_UV] = uvs

	_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)


func _physics_process(delta: float) -> void:
	var player: CharacterBody3D = _find_player()
	if not player:
		return

	_detect_motion(player)
	var wind: Vector3 = _compute_wind(player)

	# ── 1. Verlet integration ──────────────────────────────────
	#     new_pos = pos + (pos - prev) * damping + acceleration * dt²
	#     acceleration = gravity + wind_force (wind is already scaled)
	var dt2: float = delta * delta
	for i in range(VERT_COUNT):
		if _is_pinned(i):
			continue
		var vel: Vector3 = (_pos[i] - _prev[i]) * damping
		_prev[i] = _pos[i]
		_pos[i] += vel + (Vector3.DOWN * gravity + wind) * dt2

	# ── 2. Pin top rows to shoulder attachment ─────────────────
	for i in range(VERT_COUNT):
		if not _is_pinned(i):
			continue
		var _col: int = i % COLS
		var row: int = i / COLS
		var target := Vector3(_pos[i].x, _base_y - float(row) * rest_y, _base_z)
		_pos[i] = target
		_prev[i] = target

	# ── 3. Distance constraints ─────────────────────────────────
	for _iter in range(CONSTRAINT_ITERS):
		for row in range(ROWS):
			for col in range(COLS):
				var i: int = row * COLS + col
				# Horizontal
				if col < COLS - 1:
					_constrain(i, i + 1, rest_x)
				# Vertical
				if row < ROWS - 1:
					_constrain(i, i + COLS, rest_y)
				# Shear (diagonal) — staggered
				if (row + col) & 1 == 0:
					var diag: float = sqrt(rest_x * rest_x + rest_y * rest_y)
					if col < COLS - 1 and row < ROWS - 1:
						_constrain(i, i + COLS + 1, diag)
					if col > 0 and row < ROWS - 1:
						_constrain(i, i + COLS - 1, diag)

	# ── 4. Push to GPU ─────────────────────────────────────────
	_mesh.surface_update_vertex_region(0, 0, _pos.to_byte_array())


func _is_pinned(idx: int) -> bool:
	return (idx / COLS) < PIN_ROWS


func _detect_motion(player: CharacterBody3D) -> void:
	var vel: Vector3 = player.velocity
	var h: float = Vector2(vel.x, vel.z).length()
	var v: float = vel.y
	var floor_ok: bool = player.is_on_floor()
	var wall_ok: bool = player.is_on_wall()

	if not floor_ok and wall_ok and h > 3.0 and abs(v) < 3.0:
		_motion = "glide"
	elif not floor_ok and v > 2.0:
		_motion = "jump"
	elif not floor_ok:
		_motion = "fall"
	elif h > 5.0:
		_motion = "run"
	elif h > 0.5:
		_motion = "walk"
	else:
		_motion = "idle"


func _compute_wind(player: CharacterBody3D) -> Vector3:
	## Returns a wind ACCELERATION vector (not a force — already scaled for use as acceleration).
	var vel: Vector3 = player.velocity
	var t: float = Time.get_ticks_msec() * 0.001

	match _motion:
		"walk":
			return -vel * wind_scale * 0.25 + _flutter(t, 1.5)
		"run":
			return -vel * wind_scale * 0.6 + _flutter(t, 2.5)
		"jump":
			var w := -vel * wind_scale * 1.2
			w.y += abs(vel.y) * wind_scale * 0.5
			return w + _flutter(t, 3.0)
		"glide":
			var w := -vel * wind_scale * 2.5
			w.y -= gravity * 0.3  # slight downward bias so it streams, not lifts
			return w + _flutter(t, 4.0)
		"fall":
			var w := -vel * wind_scale * 0.4
			w.y += abs(vel.y) * wind_scale * 0.6  # billow up
			return w + _flutter(t, 2.0)
		_:  # idle — gentle drift
			return _flutter(t, 1.0)


func _flutter(t: float, strength: float) -> Vector3:
	return Vector3(
		sin(t * 3.7 + 0.3) * flutter_amp * strength,
		cos(t * 2.9 + 1.1) * flutter_amp * strength * 0.4,
		cos(t * 4.1 + 0.7) * flutter_amp * strength * 0.6
	)


func _constrain(i: int, j: int, rest: float) -> void:
	var delta: Vector3 = _pos[j] - _pos[i]
	var dist: float = delta.length()
	if dist < 0.0001:
		return
	var correction: Vector3 = delta * (1.0 - rest / dist) * 0.5 * stiffness
	if not _is_pinned(i):
		_pos[i] += correction
	if not _is_pinned(j):
		_pos[j] -= correction


func _find_player() -> CharacterBody3D:
	var node := get_parent()
	while node:
		if node is CharacterBody3D:
			return node
		node = node.get_parent()
	return null
