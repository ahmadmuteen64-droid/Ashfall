class_name VoxelWorld
extends Node3D
## World manager: loads voxel types, spawns chunks, handles sub-voxel destruction.
## Each voxel = 100 sub-voxels. Destruction spawns sub-voxel-scale physics debris.

const CHUNK_SIZE: int = 16
const TYPE_DIR: String = "res://data/voxel/types/"
const DAMAGE_PER_HIT: int = 25

var type_ids: Dictionary = {}
var type_table: Array = []
var _chunks: Array = []

@export var world_size_x: int = 4
@export var world_size_z: int = 4
@export var ground_y: int = 0


func _ready() -> void:
	_load_voxel_types()
	_generate_world()
	_create_floor_collision()
	print("VOXEL_WORLD_OK  types:%d  chunks:%d" % [type_table.size() - 1, _chunks.size()])


func _create_floor_collision() -> void:
	var floor: StaticBody3D = get_node_or_null("FloorCollision")
	if not floor: return
	var cs: CollisionShape3D = floor.get_node_or_null("CollisionShape3D")
	if not cs: return
	var box: BoxShape3D = BoxShape3D.new()
	var world_w: float = float(world_size_x * CHUNK_SIZE)
	var world_d: float = float(world_size_z * CHUNK_SIZE)
	box.size = Vector3(world_w, 0.5, world_d)
	cs.shape = box
	cs.position = Vector3(world_w / 2.0, 1.0, world_d / 2.0)
	floor.collision_layer = 1


func _load_voxel_types() -> void:
	type_table.clear()
	type_table.append(null)
	type_ids.clear()
	var type_files: Array = [
		"stone","dirt","grass","wood","leaves","brick","crystal","obsidian",
		"sand","gravel","moss","ice","ruined_stone","volcanic","snow","bedrock"
	]
	for name in type_files:
		var path: String = TYPE_DIR + name + ".tres"
		var vt: VoxelType = load(path) as VoxelType
		if vt:
			type_ids[name] = type_table.size()
			type_table.append(vt)
	print("VoxelWorld: loaded %d voxel types" % type_table.size())


func get_type_id(block_name: String) -> int:
	return type_ids.get(block_name, 0)


func get_type(id: int) -> VoxelType:
	if id > 0 and id < type_table.size():
		return type_table[id]
	return null


func _generate_world() -> void:
	_create_ground()
	_build_forest()
	_build_plains()
	_build_ruins()
	_build_crystal_cavern()
	_build_desert()
	_build_volcanic()
	_rebuild_all()


func _create_ground() -> void:
	var bedrock_id: int = get_type_id("bedrock")
	for cx in range(world_size_x):
		for cz in range(world_size_z):
			var chunk: VoxelChunk = _spawn_chunk(cx * CHUNK_SIZE, 0, cz * CHUNK_SIZE)
			chunk.register_types(type_table)
			chunk.fill_rect(0, ground_y, 0, CHUNK_SIZE, 1, CHUNK_SIZE, bedrock_id)


func _spawn_chunk(wx: int, wy: int, wz: int) -> VoxelChunk:
	var scene: PackedScene = load("res://scenes/world/voxel_chunk.tscn")
	var chunk: VoxelChunk = scene.instantiate()
	chunk.name = "Chunk_%d_%d_%d" % [wx, wy, wz]
	chunk.position = Vector3(float(wx), float(wy), float(wz))
	add_child(chunk)
	_chunks.append(chunk)
	return chunk


func get_chunk_at(wx: float, wy: float, wz: float) -> VoxelChunk:
	var cx: int = int(floor(wx / CHUNK_SIZE)) * CHUNK_SIZE
	var cz: int = int(floor(wz / CHUNK_SIZE)) * CHUNK_SIZE
	for c in _chunks:
		if int(c.position.x) == cx and int(c.position.z) == cz:
			return c
	return null


func damage_voxel_at(world_pos: Vector3, amount: int) -> Dictionary:
	var result: Dictionary = {"destroyed": false, "sub_voxels_lost": 0, "debris_pos": world_pos, "voxel_type": 0}
	var chunk: VoxelChunk = get_chunk_at(world_pos.x, world_pos.y, world_pos.z)
	if not chunk: return result
	var lx: int = _to_local(world_pos.x)
	var ly: int = _to_local(world_pos.y)
	var lz: int = _to_local(world_pos.z)
	result.voxel_type = chunk.get_voxel(lx, ly, lz)
	if result.voxel_type <= 0: return result
	var dmg: Dictionary = chunk.damage_voxel(lx, ly, lz, amount)
	result.sub_voxels_lost = dmg.get("sub_voxels_lost", 0)
	if dmg.get("destroyed", false):
		result.destroyed = true
		_spawn_debris(world_pos, result.voxel_type, result.sub_voxels_lost)
		chunk.rebuild()
	return result


func _to_local(world_coord: float) -> int:
	var l: int = int(world_coord) % CHUNK_SIZE
	if l < 0: l += CHUNK_SIZE
	return l


func _spawn_debris(world_pos: Vector3, type_id: int, sub_voxels: int) -> void:
	var vt: VoxelType = get_type(type_id)
	if not vt: return
	var count: int = clampi(sub_voxels / 10, 1, 15)
	for i in range(count):
		var debris: RigidBody3D = RigidBody3D.new()
		debris.name = "Debris"
		var sz: float = randf_range(0.05, 0.2)
		debris.position = world_pos + Vector3(randf_range(-0.3, 0.3), randf_range(0.1, 0.5), randf_range(-0.3, 0.3))
		debris.collision_layer = 2; debris.collision_mask = 1
		debris.mass = sz * 2.0; debris.gravity_scale = 1.5
		var mi: MeshInstance3D = MeshInstance3D.new()
		var box: BoxMesh = BoxMesh.new()
		box.size = Vector3(sz, sz, sz)
		mi.mesh = box; mi.material_override = vt.material
		debris.add_child(mi)
		var col: CollisionShape3D = CollisionShape3D.new()
		var bs: BoxShape3D = BoxShape3D.new()
		bs.size = Vector3(sz, sz, sz)
		col.shape = bs
		debris.add_child(col)
		add_child(debris)
		debris.apply_central_impulse(Vector3(randf_range(-2, 2), randf_range(3, 6), randf_range(-2, 2)))
		debris.apply_torque_impulse(Vector3(randf_range(-5, 5), randf_range(-5, 5), randf_range(-5, 5)))
		var timer: Timer = Timer.new()
		timer.wait_time = 4.0; timer.one_shot = true
		timer.timeout.connect(debris.queue_free)
		debris.add_child(timer); timer.start()


func _set_world_voxel(wx: int, wy: int, wz: int, type_id: int) -> void:
	var cx: int = int(floor(float(wx) / CHUNK_SIZE)) * CHUNK_SIZE
	var cz: int = int(floor(float(wz) / CHUNK_SIZE)) * CHUNK_SIZE
	for c in _chunks:
		if int(c.position.x) == cx and int(c.position.z) == cz:
			c.set_voxel(wx - cx, wy, wz - cz, type_id)
			return


func _rebuild_all() -> void:
	for c in _chunks:
		c.rebuild()


## ── World Building ─────────────────────────────────────

func _build_forest() -> void:
	var wood_id: int = get_type_id("wood")
	var leaves_id: int = get_type_id("leaves")
	var grass_id: int = get_type_id("grass")
	var dirt_id: int = get_type_id("dirt")
	for x in range(0, 16):
		for z in range(0, 32):
			_set_world_voxel(x, ground_y + 1, z, grass_id)
			_set_world_voxel(x, ground_y, z, dirt_id)
	var trees: Array = [[3,3],[7,5],[11,8],[4,14],[9,18],[2,22],[12,25],[6,28],[14,3],[8,12],[13,20],[5,26]]
	for tp in trees:
		var tx: int = tp[0]; var tz: int = tp[1]
		for ty in range(ground_y + 1, ground_y + 6):
			_set_world_voxel(tx, ty, tz, wood_id)
		for dx in range(-2, 3):
			for dz in range(-2, 3):
				for dy in range(4, 7):
					if abs(dx) <= 1 or abs(dz) <= 1 or dy == 4:
						_set_world_voxel(tx + dx, ground_y + dy, tz + dz, leaves_id)


func _build_plains() -> void:
	var grass_id: int = get_type_id("grass")
	var dirt_id: int = get_type_id("dirt")
	for x in range(16, 48):
		for z in range(0, 32):
			var h: int = ground_y + 1 + int(sin(float(x) * 0.2) * cos(float(z) * 0.15) * 2.0)
			_set_world_voxel(x, h, z, grass_id)
			_set_world_voxel(x, h - 1, z, dirt_id)


func _build_ruins() -> void:
	var brick_id: int = get_type_id("brick")
	var ruined_id: int = get_type_id("ruined_stone")
	var moss_id: int = get_type_id("moss")
	for x in range(35, 60):
		for z in range(35, 60):
			if (x + z) % 3 != 0:
				_set_world_voxel(x, ground_y + 1, z, ruined_id)
	for x in range(36, 59):
		_set_world_voxel(x, ground_y + 2, 36, ruined_id)
		_set_world_voxel(x, ground_y + 3, 36, ruined_id)
		if x % 4 == 0:
			_set_world_voxel(x, ground_y + 4, 36, brick_id)
	for i in range(4):
		var cx: int = 38 + i * 6
		for cy in range(ground_y + 1, ground_y + 8):
			_set_world_voxel(cx, cy, 52, brick_id)
		for dx in range(-1, 2):
			for dz in range(-1, 2):
				_set_world_voxel(cx + dx, ground_y + 8, 52 + dz, brick_id)
	for i in range(3):
		var ax: int = 41 + i * 6
		for ay in range(ground_y + 5, ground_y + 8):
			_set_world_voxel(ax, ay, 52, brick_id)
	for _i in range(20):
		_set_world_voxel(randi_range(36, 58), ground_y + 2, randi_range(37, 59), moss_id)


func _build_crystal_cavern() -> void:
	var crystal_id: int = get_type_id("crystal")
	var obsidian_id: int = get_type_id("obsidian")
	var stone_id: int = get_type_id("stone")
	for x in range(2, 14):
		for z in range(34, 62):
			_set_world_voxel(x, ground_y + 1, z, obsidian_id)
			_set_world_voxel(x, ground_y, z, stone_id)
	for x in range(4, 12):
		for z in range(38, 58):
			_set_world_voxel(x, ground_y + 1, z, 0)
	for _i in range(15):
		var cx: int = randi_range(3, 13)
		var cz: int = randi_range(35, 61)
		var h: int = randi_range(2, 5)
		for y in range(ground_y + 1, ground_y + h):
			_set_world_voxel(cx, y, cz, crystal_id)


func _build_desert() -> void:
	var sand_id: int = get_type_id("sand")
	var gravel_id: int = get_type_id("gravel")
	for x in range(48, 64):
		for z in range(0, 32):
			var h: int = ground_y + 1 + int(abs(sin(float(x) * 0.15) * cos(float(z) * 0.2) * 3.0))
			_set_world_voxel(x, h, z, sand_id)
			_set_world_voxel(x, h - 1, z, sand_id)
	for _i in range(30):
		_set_world_voxel(randi_range(48, 63), ground_y + 1, randi_range(0, 31), gravel_id)


func _build_volcanic() -> void:
	var volcanic_id: int = get_type_id("volcanic")
	var obsidian_id: int = get_type_id("obsidian")
	var snow_id: int = get_type_id("snow")
	for x in range(32, 48):
		for z in range(0, 32):
			_set_world_voxel(x, ground_y + 1, z, volcanic_id)
	for _i in range(12):
		var bx: int = randi_range(33, 46)
		var bz: int = randi_range(2, 29)
		var h: int = randi_range(4, 10)
		for y in range(ground_y + 1, ground_y + h):
			_set_world_voxel(bx, y, bz, volcanic_id)
			if y <= ground_y + 2:
				_set_world_voxel(bx + 1, y, bz, volcanic_id)
				_set_world_voxel(bx, y, bz + 1, volcanic_id)
		_set_world_voxel(bx, ground_y + h, bz, snow_id)
	for _i in range(20):
		_set_world_voxel(randi_range(33, 46), ground_y + 1, randi_range(2, 29), obsidian_id)
