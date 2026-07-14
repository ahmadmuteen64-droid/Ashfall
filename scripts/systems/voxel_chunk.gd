class_name VoxelChunk
extends Node3D
## Chunk of individual 1×1×1 voxel cubes. One MultiMeshInstance3D per material.
## Each voxel is a distinct cube — visible as individual pixels at game resolution.

const CHUNK_SIZE: int = 16

var grid: PackedInt32Array = []
var health_grid: PackedFloat32Array = []
var _type_table: Array = []
var _multimesh_by_material: Dictionary = {}  ## material_path -> MultiMeshInstance3D
var _transforms_by_material: Dictionary = {}  ## material_path -> Array[Transform3D]

@onready var _static_body: StaticBody3D = $StaticBody3D
@onready var _collision_shape: CollisionShape3D = $StaticBody3D/CollisionShape3D


func _ready() -> void:
	if grid.size() == 0:
		_init_empty()
	if not Engine.is_editor_hint():
		rebuild()


func _init_empty() -> void:
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
	if not is_in_bounds(x, y, z): return 0
	return grid[_idx(x, y, z)]


func set_voxel(x: int, y: int, z: int, type_id: int, health: float = -1.0) -> void:
	if not is_in_bounds(x, y, z): return
	var i: int = _idx(x, y, z)
	grid[i] = type_id
	if health < 0 and type_id > 0 and type_id < _type_table.size():
		var vt: VoxelType = _type_table[type_id]
		health_grid[i] = vt.health if vt else 10.0
	else:
		health_grid[i] = health


func damage_voxel(x: int, y: int, z: int, amount: float, tool: String = "") -> bool:
	if not is_in_bounds(x, y, z): return false
	var i: int = _idx(x, y, z)
	var tid: int = grid[i]
	if tid <= 0: return false
	var vt: VoxelType = _type_table[tid] if tid < _type_table.size() else null
	if vt and vt.is_ground: return false
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


## Rebuild all MultiMesh renders + collision from current grid.
func rebuild() -> void:
	# Clear old multimesh nodes
	for child in _multimesh_by_material.values():
		child.queue_free()
	_multimesh_by_material.clear()
	_transforms_by_material.clear()

	# Collect transforms per material
	var box: BoxMesh = BoxMesh.new()
	box.size = Vector3(1.0, 1.0, 1.0)

	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			for z in range(CHUNK_SIZE):
				var tid: int = get_voxel(x, y, z)
				if tid <= 0: continue
				var vt: VoxelType = _type_table[tid] if tid < _type_table.size() else null
				if not vt or not vt.material: continue
				var mat_path: String = vt.material.resource_path
				if mat_path.is_empty(): continue
				if not _transforms_by_material.has(mat_path):
					_transforms_by_material[mat_path] = Array()
				var t: Transform3D = Transform3D(Basis(), Vector3(float(x) + 0.5, float(y) + 0.5, float(z) + 0.5))
				_transforms_by_material[mat_path].append(t)

	# Create MultiMeshInstance3D per material
	for mat_path in _transforms_by_material:
		var transforms: Array = _transforms_by_material[mat_path]
		if transforms.size() == 0: continue

		var mm: MultiMesh = MultiMesh.new()
		mm.transform_format = MultiMesh.TRANSFORM_3D
		mm.mesh = box
		mm.instance_count = transforms.size()
		for i in range(transforms.size()):
			mm.set_instance_transform(i, transforms[i])

		var mmi: MultiMeshInstance3D = MultiMeshInstance3D.new()
		mmi.name = "MM_%s" % mat_path.get_file().get_basename()
		mmi.multimesh = mm
		mmi.material_override = load(mat_path)
		mmi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		add_child(mmi)
		_multimesh_by_material[mat_path] = mmi

	# Collision: trimesh from combined mesh
	_update_collision()


func _update_collision() -> void:
	if _multimesh_by_material.is_empty():
		_collision_shape.shape = null
		return

	# Build collision from merged visible faces (efficient) — not per-voxel
	var st: SurfaceTool = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			for z in range(CHUNK_SIZE):
				var tid: int = get_voxel(x, y, z)
				if tid <= 0: continue
				var vt: VoxelType = _type_table[tid] if tid < _type_table.size() else null
				if not vt or vt.is_ground: continue
				st.set_material(null)
				_add_collision_faces(st, x, y, z)

	st.generate_normals()
	var mesh: ArrayMesh = st.commit()
	if mesh and mesh.get_surface_count() > 0:
		_collision_shape.shape = mesh.create_trimesh_shape()
	else:
		_collision_shape.shape = null


func _add_collision_faces(st: SurfaceTool, x: int, y: int, z: int) -> void:
	# +X, -X, +Y, -Y, +Z, -Z
	var dirs: Array[Vector3i] = [Vector3i(1,0,0), Vector3i(-1,0,0), Vector3i(0,1,0), Vector3i(0,-1,0), Vector3i(0,0,1), Vector3i(0,0,-1)]
	for d in dirs:
		var nx: int = x + d.x; var ny: int = y + d.y; var nz: int = z + d.z
		if get_voxel(nx, ny, nz) > 0: continue
		var verts: Array[Vector3] = _face_verts(x, y, z, d.x, d.y, d.z)
		st.set_normal(Vector3(float(d.x), float(d.y), float(d.z)))
		st.add_vertex(verts[0]); st.add_vertex(verts[1]); st.add_vertex(verts[2])
		st.add_vertex(verts[0]); st.add_vertex(verts[2]); st.add_vertex(verts[3])


func _face_verts(x: int, y: int, z: int, nx: int, ny: int, nz: int) -> Array[Vector3]:
	var fx: float = float(x); var fy: float = float(y); var fz: float = float(z)
	match [nx, ny, nz]:
		[1, 0, 0]:   return [Vector3(fx+1,fy,fz),  Vector3(fx+1,fy+1,fz),  Vector3(fx+1,fy+1,fz+1),  Vector3(fx+1,fy,fz+1)]
		[-1, 0, 0]:  return [Vector3(fx,fy,fz+1),  Vector3(fx,fy+1,fz+1),  Vector3(fx,fy+1,fz),  Vector3(fx,fy,fz)]
		[0, 1, 0]:   return [Vector3(fx,fy+1,fz),  Vector3(fx+1,fy+1,fz),  Vector3(fx+1,fy+1,fz+1),  Vector3(fx,fy+1,fz+1)]
		[0, -1, 0]:  return [Vector3(fx,fy,fz+1),  Vector3(fx+1,fy,fz+1),  Vector3(fx+1,fy,fz),  Vector3(fx,fy,fz)]
		[0, 0, 1]:   return [Vector3(fx,fy,fz+1),  Vector3(fx,fy+1,fz+1),  Vector3(fx+1,fy+1,fz+1),  Vector3(fx+1,fy,fz+1)]
		[0, 0, -1]:  return [Vector3(fx+1,fy,fz),  Vector3(fx+1,fy+1,fz),  Vector3(fx,fy+1,fz),  Vector3(fx,fy,fz)]
		_: return []
