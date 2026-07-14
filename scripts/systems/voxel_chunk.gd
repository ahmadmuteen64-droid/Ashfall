class_name VoxelChunk
extends Node3D

## Chunk of sub-voxel cubes. Collision via per-column BoxShape3D.
## VOXEL_SIZE = 0.1 units (10 sub-voxels per unit).

const CHUNK_SIZE: int = 32
const VOXEL_SIZE: float = 0.2
const SUB_PER_VOXEL: int = 100

var grid: PackedInt32Array = []
var health_grid: PackedInt32Array = []
var _type_table: Array = []
var _multimesh_by_mat: Dictionary = {}
var _transforms_by_mat: Dictionary = {}

@onready var _static_body: StaticBody3D = $StaticBody3D


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
	health_grid.fill(0)


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


func rebuild() -> void:
	_clear_multimeshes()
	if grid.size() == 0: return

	var box: BoxMesh = BoxMesh.new()
	box.size = Vector3(VOXEL_SIZE, VOXEL_SIZE, VOXEL_SIZE)
	var half: float = VOXEL_SIZE / 2.0

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
				var t: Transform3D = Transform3D(Basis(), Vector3(float(x) * VOXEL_SIZE + half, float(y) * VOXEL_SIZE + half, float(z) * VOXEL_SIZE + half))
				_transforms_by_mat[mat_path].append(t)

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
	for child in _static_body.get_children():
		if child is CollisionShape3D:
			child.queue_free()

	var processed: Dictionary = {}
	# Minimum merge span: 4 voxels (0.8 units) so player capsule (r=0.35) can't slip through
	const MIN_MERGE: int = 4

	# First pass: fill any gaps so columns don't have holes
	_fill_gaps()

	for x in range(0, CHUNK_SIZE, MIN_MERGE):
		for z in range(0, CHUNK_SIZE, MIN_MERGE):
			var key: String = "%d,%d" % [x, z]
			if processed.get(key, false): continue

			var min_y: int = 999; var max_y: int = -1
			for dx in range(MIN_MERGE):
				for dz in range(MIN_MERGE):
					if x + dx >= CHUNK_SIZE or z + dz >= CHUNK_SIZE: continue
					for y in range(CHUNK_SIZE):
						if get_voxel(x + dx, y, z + dz) > 0:
							if y < min_y: min_y = y
							if y > max_y: max_y = y

			if max_y < 0: continue

			var bw: float = float(MIN_MERGE) * VOXEL_SIZE
			var bh: float = float(max_y - min_y + 1) * VOXEL_SIZE
			var bd: float = float(MIN_MERGE) * VOXEL_SIZE

			var box_shape: BoxShape3D = BoxShape3D.new()
			box_shape.size = Vector3(bw, bh, bd)
			var cs: CollisionShape3D = CollisionShape3D.new()
			cs.shape = box_shape
			cs.position = Vector3(float(x) * VOXEL_SIZE + bw / 2.0, float(min_y) * VOXEL_SIZE + bh / 2.0, float(z) * VOXEL_SIZE + bd / 2.0)
			_static_body.add_child(cs)

			for dx in range(MIN_MERGE):
				for dz in range(MIN_MERGE):
					if x + dx < CHUNK_SIZE and z + dz < CHUNK_SIZE:
						processed["%d,%d" % [x + dx, z + dz]] = true


func _fill_gaps() -> void:
	# Fill single-voxel gaps between solid columns so collision is continuous
	for x in range(1, CHUNK_SIZE - 1):
		for z in range(1, CHUNK_SIZE - 1):
			for y in range(1, CHUNK_SIZE - 1):
				if get_voxel(x, y, z) > 0: continue
				# If surrounded on all 4 horizontal sides, fill the gap
				if get_voxel(x-1, y, z) > 0 and get_voxel(x+1, y, z) > 0 and get_voxel(x, y, z-1) > 0 and get_voxel(x, y, z+1) > 0:
					var neighbor_type: int = get_voxel(x-1, y, z)
					set_voxel(x, y, z, neighbor_type)


func _column_matches(x: int, z: int, ref_min_y: int, ref_max_y: int) -> bool:
	var min_y: int = -1; var max_y: int = -1
	for y in range(CHUNK_SIZE):
		if get_voxel(x, y, z) > 0:
			if min_y < 0: min_y = y
			max_y = y
	return min_y == ref_min_y and max_y == ref_max_y
