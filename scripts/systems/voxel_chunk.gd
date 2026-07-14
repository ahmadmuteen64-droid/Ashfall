class_name VoxelChunk
extends Node3D
## 16x16x16 voxel chunk with mesh generation, trimesh collision, and per-voxel health.

const CHUNK_SIZE: int = 16
const VOXEL_SIZE: float = 1.0

var grid: PackedInt32Array = []
var health_grid: PackedFloat32Array = []
var _type_table: Array = []

@onready var _mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var _static_body: StaticBody3D = $StaticBody3D
@onready var _collision_shape: CollisionShape3D = $StaticBody3D/CollisionShape3D


func _ready() -> void:
	if grid.size() == 0:
		_init_empty_grid()
	if not Engine.is_editor_hint():
		rebuild()


func _init_empty_grid() -> void:
	var total: int = CHUNK_SIZE * CHUNK_SIZE * CHUNK_SIZE
	grid.resize(total)
	health_grid.resize(total)
	grid.fill(0)
	health_grid.fill(0.0)


func _idx(x: int, y: int, z: int) -> int:
	return x + y * CHUNK_SIZE + z * CHUNK_SIZE * CHUNK_SIZE


func is_in_bounds(x: int, y: int, z: int) -> bool:
	return x >= 0 and x < CHUNK_SIZE and y >= 0 and y < CHUNK_SIZE and z >= 0 and z < CHUNK_SIZE


func get_voxel(x: int, y: int, z: int) -> int:
	if not is_in_bounds(x, y, z):
		return 0
	return grid[_idx(x, y, z)]


func set_voxel(x: int, y: int, z: int, type_id: int, health: float = -1.0) -> void:
	if not is_in_bounds(x, y, z):
		return
	var i: int = _idx(x, y, z)
	grid[i] = type_id
	if health < 0 and type_id > 0 and type_id < _type_table.size():
		var vt: VoxelType = _type_table[type_id]
		health_grid[i] = vt.health if vt else 10.0
	else:
		health_grid[i] = health


func damage_voxel(x: int, y: int, z: int, amount: float, tool: String = "") -> bool:
	if not is_in_bounds(x, y, z):
		return false
	var i: int = _idx(x, y, z)
	var type_id: int = grid[i]
	if type_id <= 0:
		return false
	var vt: VoxelType = _type_table[type_id] if type_id < _type_table.size() else null
	if vt and vt.is_ground:
		return false
	health_grid[i] -= amount
	if health_grid[i] <= 0.0:
		grid[i] = 0
		health_grid[i] = 0.0
		return true
	return false


func fill_rect(x0: int, y0: int, z0: int, w: int, h: int, d: int, type_id: int) -> void:
	for x in range(x0, x0 + w):
		for y in range(y0, y0 + h):
			for z in range(z0, z0 + d):
				set_voxel(x, y, z, type_id)


func fill_sphere(cx: float, cy: float, cz: float, radius: float, type_id: int) -> void:
	var r2: float = radius * radius
	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			for z in range(CHUNK_SIZE):
				var dx: float = float(x) + 0.5 - cx
				var dy: float = float(y) + 0.5 - cy
				var dz: float = float(z) + 0.5 - cz
				if dx * dx + dy * dy + dz * dz <= r2:
					set_voxel(x, y, z, type_id)


func fill_cylinder(cx: float, cz: float, y0: int, y1: int, radius: float, type_id: int) -> void:
	var r2: float = radius * radius
	for x in range(CHUNK_SIZE):
		for z in range(CHUNK_SIZE):
			var dx: float = float(x) + 0.5 - cx
			var dz: float = float(z) + 0.5 - cz
			if dx * dx + dz * dz <= r2:
				for y in range(y0, y1):
					set_voxel(x, y, z, type_id)


func register_types(types: Array) -> void:
	_type_table = types.duplicate()
	_type_table.insert(0, null)


func rebuild() -> void:
	var st: SurfaceTool = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			for z in range(CHUNK_SIZE):
				var type_id: int = get_voxel(x, y, z)
				if type_id > 0:
					_add_voxel_faces(st, x, y, z, type_id)
	st.generate_normals()
	# Skip tangents: solid-color voxel faces with UVs set don't need them
	var mesh: ArrayMesh = st.commit()
	if mesh:
		_mesh_instance.mesh = mesh
		_mesh_instance.visible = true
		_collision_shape.shape = mesh.create_trimesh_shape()
	else:
		_mesh_instance.visible = false
		_collision_shape.shape = null


func _add_voxel_faces(st: SurfaceTool, x: int, y: int, z: int, type_id: int) -> void:
	var vt: VoxelType = _type_table[type_id] if type_id < _type_table.size() else null
	if not vt or not vt.material:
		return
	st.set_material(vt.material)
	# +X, -X, +Y, -Y, +Z, -Z
	_add_face(st, x, y, z, 1, 0, 0)
	_add_face(st, x, y, z, -1, 0, 0)
	_add_face(st, x, y, z, 0, 1, 0)
	_add_face(st, x, y, z, 0, -1, 0)
	_add_face(st, x, y, z, 0, 0, 1)
	_add_face(st, x, y, z, 0, 0, -1)


func _add_face(st: SurfaceTool, x: int, y: int, z: int, nx: int, ny: int, nz: int) -> void:
	var neighbor: int = get_voxel(x + nx, y + ny, z + nz)
	if neighbor > 0:
		return  # Face is hidden
	var normal: Vector3 = Vector3(float(nx), float(ny), float(nz))
	var origin: Vector3 = Vector3(float(x), float(y), float(z))
	var tangent: Vector3
	var bitangent: Vector3
	if abs(nx) > 0:
		tangent = Vector3(0, 0, 1)
		bitangent = Vector3(0, 1, 0)
	elif abs(ny) > 0:
		tangent = Vector3(1, 0, 0)
		bitangent = Vector3(0, 0, 1)
	else:
		tangent = Vector3(1, 0, 0)
		bitangent = Vector3(0, 1, 0)
	# Offset to voxel face
	var face_origin: Vector3 = origin
	if nx > 0:
		face_origin.x += 1.0
	if ny > 0:
		face_origin.y += 1.0
	if nz > 0:
		face_origin.z += 1.0
	var v0: Vector3 = face_origin
	var v1: Vector3 = face_origin + tangent
	var v2: Vector3 = face_origin + tangent + bitangent
	var v3: Vector3 = face_origin + bitangent
	st.set_normal(normal)
	st.add_vertex(v3)
	st.add_vertex(v2)
	st.add_vertex(v0)
	st.add_vertex(v3)
	st.add_vertex(v0)
	st.add_vertex(v1)
