class_name VoxelChunk
extends Node3D
## 16³ chunk of voxels. Each voxel = 100 sub-voxels internally for granular
## destruction and physics. Rendered as individual MultiMesh cubes.
## Collision: trimesh from merged faces, box fallback guarantees player can walk.

const CHUNK_SIZE: int = 16
const VOXEL_SIZE: float = 1.0
const SUB_PER_VOXEL: int = 100          ## Sub-voxels per voxel per axis (health = 100)
const SUB_SIZE: float = 0.01            ## 1/100th of a voxel

var grid: PackedInt32Array = []          ## Voxel type IDs (0 = air)
var health_grid: PackedInt32Array = []   ## Sub-voxels remaining (0-100, 0 = destroyed)
var _type_table: Array = []              ## Index -> VoxelType
var _multimesh_by_mat: Dictionary = {}   ## material_path -> MultiMeshInstance3D
var _transforms_by_mat: Dictionary = {}  ## material_path -> Array[Transform3D]

@onready var _static_body: StaticBody3D = $StaticBody3D
@onready var _collision_shape: CollisionShape3D = $StaticBody3D/CollisionShape3D


func _ready() -> void:
	if grid.size() == 0:
		_init_empty()
	if not Engine.is_editor_hint():
		rebuild()


func _init_empty() -> void:
	var total: int = CHUNK_SIZE * CHUNK_SIZE * CHUNK_SIZE
	grid.resize(total); health_grid.resize(total)
	grid.fill(0); health_grid.fill(0)


func _idx(x: int, y: int, z: int) -> int:
	return x + y * CHUNK_SIZE + z * CHUNK_SIZE * CHUNK_SIZE


func is_in_bounds(x: int, y: int, z: int) -> bool:
	return x >= 0 and x < CHUNK_SIZE and y >= 0 and y < CHUNK_SIZE and z >= 0 and z < CHUNK_SIZE


func get_voxel(x: int, y: int, z: int) -> int:
	if not is_in_bounds(x, y, z): return 0
	return grid[_idx(x, y, z)]


func set_voxel(x: int, y: int, z: int, type_id: int) -> void:
	if not is_in_bounds(x, y, z): return
	var i: int = _idx(x, y, z)
	grid[i] = type_id
	health_grid[i] = SUB_PER_VOXEL if type_id > 0 else 0


## Returns number of sub-voxels destroyed (0 = none, 100 = full voxel gone).
## Calls back with {destroyed: bool, sub_voxels_lost: int}
func damage_voxel(x: int, y: int, z: int, amount: int) -> Dictionary:
	if not is_in_bounds(x, y, z): return {"destroyed": false, "sub_voxels_lost": 0}
	var i: int = _idx(x, y, z)
	var tid: int = grid[i]
	if tid <= 0: return {"destroyed": false, "sub_voxels_lost": 0}
	var vt: VoxelType = _type_table[tid] if tid < _type_table.size() else null
	if vt and vt.is_ground: return {"destroyed": false, "sub_voxels_lost": 0}

	var lost: int = mini(amount, health_grid[i])
	health_grid[i] -= lost
	if health_grid[i] <= 0:
		grid[i] = 0
		return {"destroyed": true, "sub_voxels_lost": lost}
	return {"destroyed": false, "sub_voxels_lost": lost}


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


func register_types(types: Array) -> void:
	_type_table = types.duplicate()


## Full rebuild: clear all MultiMeshes, build fresh from grid, rebuild collision.
func rebuild() -> void:
	_clear_multimeshes()
	if grid.size() == 0: return

	var box: BoxMesh = BoxMesh.new()
	box.size = Vector3(VOXEL_SIZE, VOXEL_SIZE, VOXEL_SIZE)

	# Collect transforms per material
	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			for z in range(CHUNK_SIZE):
				var tid: int = get_voxel(x, y, z)
				if tid <= 0: continue
				var vt: VoxelType = _type_table[tid] if tid < _type_table.size() else null
				if not vt or not vt.material: continue
				var mat_path: String = vt.material.resource_path
				if mat_path.is_empty(): continue
				if not _transforms_by_mat.has(mat_path):
					_transforms_by_mat[mat_path] = []
				var t: Transform3D = Transform3D(Basis(), Vector3(float(x) + 0.5, float(y) + 0.5, float(z) + 0.5))
				_transforms_by_mat[mat_path].append(t)

	# Create MultiMeshInstance3D per material
	for mat_path in _transforms_by_mat:
		var transforms: Array = _transforms_by_mat[mat_path]
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
		_multimesh_by_mat[mat_path] = mmi

	_rebuild_collision()


func _clear_multimeshes() -> void:
	for mmi in _multimesh_by_mat.values():
		mmi.queue_free()
	_multimesh_by_mat.clear()
	_transforms_by_mat.clear()


func _rebuild_collision() -> void:
	# Build trimesh from visible voxel faces
	var st: SurfaceTool = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			for z in range(CHUNK_SIZE):
				if get_voxel(x, y, z) <= 0: continue
				_add_six_faces(st, x, y, z)

	st.generate_normals()
	var mesh: ArrayMesh = st.commit()
	if mesh and mesh.get_surface_count() > 0:
		_collision_shape.shape = mesh.create_trimesh_shape()
	else:
		# Fallback: box covering chunk volume — player always has something to stand on
		var box_shape: BoxShape3D = BoxShape3D.new()
		box_shape.size = Vector3(CHUNK_SIZE, CHUNK_SIZE, CHUNK_SIZE)
		_collision_shape.shape = box_shape


func _add_six_faces(st: SurfaceTool, x: int, y: int, z: int) -> void:
	var dirs: Array = [
		[1,0,0], [-1,0,0], [0,1,0], [0,-1,0], [0,0,1], [0,0,-1]
	]
	for d in dirs:
		var nx: int = d[0]; var ny: int = d[1]; var nz: int = d[2]
		if get_voxel(x + nx, y + ny, z + nz) > 0: continue
		st.set_normal(Vector3(float(nx), float(ny), float(nz)))
		var v: Array = _face_verts(x, y, z, nx, ny, nz)
		st.add_vertex(v[0]); st.add_vertex(v[1]); st.add_vertex(v[2])
		st.add_vertex(v[0]); st.add_vertex(v[2]); st.add_vertex(v[3])


func _face_verts(x: int, y: int, z: int, nx: int, ny: int, nz: int) -> Array:
	var fx: float = float(x); var fy: float = float(y); var fz: float = float(z)
	match [nx, ny, nz]:
		[1, 0, 0]:   return [Vector3(fx+1,fy,fz),   Vector3(fx+1,fy+1,fz),   Vector3(fx+1,fy+1,fz+1),   Vector3(fx+1,fy,fz+1)]
		[-1, 0, 0]:  return [Vector3(fx,fy,fz+1),   Vector3(fx,fy+1,fz+1),   Vector3(fx,fy+1,fz),     Vector3(fx,fy,fz)]
		[0, 1, 0]:   return [Vector3(fx,fy+1,fz),   Vector3(fx+1,fy+1,fz),   Vector3(fx+1,fy+1,fz+1),   Vector3(fx,fy+1,fz+1)]
		[0, -1, 0]:  return [Vector3(fx,fy,fz+1),   Vector3(fx+1,fy,fz+1),   Vector3(fx+1,fy,fz),       Vector3(fx,fy,fz)]
		[0, 0, 1]:   return [Vector3(fx,fy,fz+1),   Vector3(fx,fy+1,fz+1),   Vector3(fx+1,fy+1,fz+1),   Vector3(fx+1,fy,fz+1)]
		[0, 0, -1]:  return [Vector3(fx+1,fy,fz),   Vector3(fx+1,fy+1,fz),   Vector3(fx,fy+1,fz),       Vector3(fx,fy,fz)]
	return []
