class_name VoxelWorld
extends Node3D
## World manager at sub-voxel scale. VOXEL_SIZE=0.2 gives 5 voxels per world unit.
## 64x64 unit world = 320x320 voxels = 10x10 chunks of 32^3 each.

const CHUNK_SIZE: int = 32
const VOXEL_SIZE: float = 0.2
const VOXELS_PER_UNIT: int = 5
const TYPE_DIR: String = "res://data/voxel/types/"
const DAMAGE_PER_HIT: int = 25

var type_ids: Dictionary = {}
var type_table: Array = []
var _chunks: Array = []           ## 2D array [cx][cz] for direct indexing

@export var chunks_x: int = 10
@export var chunks_z: int = 10


func _ready() -> void:
	_load_voxel_types()
	_spawn_all_chunks()
	_build_world()
	var timer := Timer.new()
	timer.wait_time = 0.05
	timer.one_shot = true
	timer.timeout.connect(spawn_interactables)
	add_child(timer)
	timer.start()
	_create_floor()
	_rebuild_all()
	print("VOXEL_WORLD_OK  types:%d  chunks:%d  voxels_per_unit:%d" % [type_table.size() - 1, chunks_x * chunks_z, VOXELS_PER_UNIT])


func _load_voxel_types() -> void:
	type_table.clear(); type_table.append(null); type_ids.clear()
	var names: Array = ["stone","dirt","grass","wood","leaves","brick","crystal","obsidian","sand","gravel","moss","ice","ruined_stone","volcanic","snow","bedrock"]
	for nm in names:
		var vt: VoxelType = load(TYPE_DIR + nm + ".tres") as VoxelType
		if vt: type_ids[nm] = type_table.size(); type_table.append(vt)
	print("VoxelWorld: loaded %d voxel types" % type_table.size())


func get_type_id(nm: String) -> int: return type_ids.get(nm, 0)
func get_type(id: int) -> VoxelType:
	if id > 0 and id < type_table.size(): return type_table[id]
	return null


func _spawn_all_chunks() -> void:
	_chunks.clear()
	for cx in range(chunks_x):
		_chunks.append([])
		for cz in range(chunks_z):
			var scene: PackedScene = load("res://scenes/world/voxel_chunk.tscn")
			var chunk: VoxelChunk = scene.instantiate()
			chunk.name = "Chunk_%d_%d" % [cx, cz]
			var wu: float = float(CHUNK_SIZE) * VOXEL_SIZE
			chunk.position = Vector3(float(cx) * wu, 0.0, float(cz) * wu)
			chunk.register_types(type_table)
			add_child(chunk)
			_chunks[cx].append(chunk)


func _chunk_at(cx: int, cz: int) -> VoxelChunk:
	if cx >= 0 and cx < _chunks.size() and cz >= 0 and cz < _chunks[cx].size():
		return _chunks[cx][cz]
	return null



func get_chunk_at(wx: float, _wy: float, wz: float) -> VoxelChunk:
	var cx: int = int(floor(wx / (float(CHUNK_SIZE) * VOXEL_SIZE)))
	var cz: int = int(floor(wz / (float(CHUNK_SIZE) * VOXEL_SIZE)))
	return _chunk_at(cx, cz)


func damage_voxel_at(world_pos: Vector3, amount: int) -> Dictionary:
	var result: Dictionary = {"destroyed": false, "sub_voxels_lost": 0, "debris_pos": world_pos, "voxel_type": 0}
	var vx: int = int(world_pos.x / VOXEL_SIZE)
	var vy: int = int(world_pos.y / VOXEL_SIZE)
	var vz: int = int(world_pos.z / VOXEL_SIZE)
	var cx: int = vx / CHUNK_SIZE
	var cz: int = vz / CHUNK_SIZE
	var chunk: VoxelChunk = _chunk_at(cx, cz)
	if not chunk: return result
	var lx: int = vx - cx * CHUNK_SIZE
	var lz: int = vz - cz * CHUNK_SIZE
	if lx < 0 or lx >= CHUNK_SIZE or vy < 0 or vy >= CHUNK_SIZE or lz < 0 or lz >= CHUNK_SIZE:
		return result
	result.voxel_type = chunk.get_voxel(lx, vy, lz)
	if result.voxel_type <= 0: return result
	var dmg: Dictionary = chunk.damage_voxel(lx, vy, lz, amount)
	result.sub_voxels_lost = dmg.get("sub_voxels_lost", 0)
	if dmg.get("destroyed", false):
		result.destroyed = true
		_spawn_debris(world_pos, result.voxel_type, result.sub_voxels_lost)
		chunk.rebuild()
	return result


func _spawn_debris(world_pos: Vector3, type_id: int, sub_voxels: int) -> void:
	var vt: VoxelType = get_type(type_id)
	if not vt: return
	var count: int = clampi(sub_voxels / 5, 1, 20)
	for _i in range(count):
		var debris: RigidBody3D = RigidBody3D.new()
		debris.name = "Debris"
		var sz: float = randf_range(0.01, 0.06)
		debris.position = world_pos + Vector3(randf_range(-0.1, 0.1), randf_range(0.05, 0.2), randf_range(-0.1, 0.1))
		debris.collision_layer = 2; debris.collision_mask = 1
		debris.mass = sz * 2.0; debris.gravity_scale = 1.5
		var mi: MeshInstance3D = MeshInstance3D.new()
		var box: BoxMesh = BoxMesh.new(); box.size = Vector3(sz, sz, sz)
		mi.mesh = box; mi.material_override = vt.material
		debris.add_child(mi)
		var col: CollisionShape3D = CollisionShape3D.new()
		var bs: BoxShape3D = BoxShape3D.new(); bs.size = Vector3(sz, sz, sz)
		col.shape = bs; debris.add_child(col)
		add_child(debris)
		debris.apply_central_impulse(Vector3(randf_range(-2, 2), randf_range(3, 6), randf_range(-2, 2)))
		debris.apply_torque_impulse(Vector3(randf_range(-5, 5), randf_range(-5, 5), randf_range(-5, 5)))
		var timer: Timer = Timer.new(); timer.wait_time = 4.0; timer.one_shot = true
		timer.timeout.connect(debris.queue_free)
		debris.add_child(timer); timer.start()


func _set_voxel(vx: int, vy: int, vz: int, type_id: int) -> void:
	var cx: int = vx / CHUNK_SIZE
	var cz: int = vz / CHUNK_SIZE
	var c: VoxelChunk = _chunk_at(cx, cz)
	if c:
		c.set_voxel(vx - cx * CHUNK_SIZE, vy, vz - cz * CHUNK_SIZE, type_id)


func _create_floor() -> void:
	var floor_node: StaticBody3D = get_node_or_null("FloorCollision")
	if not floor_node: return
	var cs: CollisionShape3D = floor_node.get_node_or_null("CollisionShape3D")
	if not cs: return
	var total_w: float = float(chunks_x * CHUNK_SIZE) * VOXEL_SIZE
	var total_d: float = float(chunks_z * CHUNK_SIZE) * VOXEL_SIZE
	var box: BoxShape3D = BoxShape3D.new()
	# Safety net — below all surface geometry, only catches player if they clip through
	box.size = Vector3(total_w, 0.2, total_d)
	cs.shape = box
	cs.position = Vector3(total_w / 2.0, -0.5, total_d / 2.0)
	floor_node.collision_layer = 1


func _wu(v: float) -> int: return int(v * float(VOXELS_PER_UNIT))


## ── World Building (in voxel coordinates) ──────────────

func _build_world() -> void:
	var bedrock: int = get_type_id("bedrock")
	for cx in range(chunks_x):
		for cz in range(chunks_z):
			var c: VoxelChunk = _chunk_at(cx, cz)
			if c: c.fill_rect(0, 0, 0, CHUNK_SIZE, 1, CHUNK_SIZE, bedrock)
	_build_forest()
	_build_plains()
	_build_ruins()
	_build_crystal_cavern()
	_build_desert()
	_build_volcanic()


func spawn_interactables() -> void:
	## Place interactable objects on world surface after terrain generation.
	
	for _i in range(4):
		_spawn_interactable(
			Vector3(randf_range(1, 14), 1.5, randf_range(2, 30)),
			"herb_cluster", Interactable.InteractType.COLLECT, "herb_cluster",
			{"type": "flora"}
		)
	for _i in range(3):
		_spawn_interactable(
			Vector3(randf_range(7.5, 11.5), 1.5, randf_range(7.5, 11.5)),
			"ancient_stone", Interactable.InteractType.EXAMINE, "ancient_stone",
			{"type": "ruins"}
		)
	for _i in range(3):
		_spawn_interactable(
			Vector3(randf_range(0.8, 2.4), 1.2, randf_range(7.6, 12.0)),
			"crystal_shard", Interactable.InteractType.EXAMINE, "crystal_shard",
			{"type": "mineral"}
		)
	for _i in range(2):
		_spawn_interactable(
			Vector3(randf_range(10.0, 12.4), 1.5, randf_range(1, 5)),
			"sand_tablet", Interactable.InteractType.ACTIVATE, "sand_tablet",
			{"type": "artifact"}
		)
	for _i in range(2):
		_spawn_interactable(
			Vector3(randf_range(6.8, 9.2), 1.5, randf_range(1, 5)),
			"ash_fragment", Interactable.InteractType.EXAMINE, "ash_fragment",
			{"type": "volcanic"}
		)
	print("VoxelWorld: spawned interactables")


func _spawn_interactable(pos: Vector3, id: String, itype: int, obs_id: String, props: Dictionary) -> void:
	var inter: Interactable = Interactable.new()
	inter.name = "Interactable_" + id
	inter.interactable_id = id
	inter.interact_type = itype as Interactable.InteractType
	inter.position = pos
	var col: CollisionShape3D = CollisionShape3D.new()
	var sphere: SphereShape3D = SphereShape3D.new()
	sphere.radius = 0.4
	col.shape = sphere
	inter.add_child(col)
	var obs: Node = Node.new()
	obs.set_script(load("res://scripts/components/observable.gd"))
	obs.observable_id = obs_id
	obs.properties = props
	inter.add_child(obs)
	add_child(inter)
	inter.add_to_group("interactable")


func _rebuild_all() -> void:
	for cx in range(chunks_x):
		for cz in range(chunks_z):
			var c: VoxelChunk = _chunk_at(cx, cz)
			if c: c.rebuild()


func _build_forest() -> void:
	var wood: int = get_type_id("wood")
	var leaves: int = get_type_id("leaves")
	var grass: int = get_type_id("grass")
	var dirt: int = get_type_id("dirt")
	# Forest: voxels 0-80 in X, 0-160 in Z (was 0-16, 0-32 world units)
	var fx0: int = _wu(0); var fx1: int = _wu(16)
	var fz0: int = _wu(0); var fz1: int = _wu(32)
	for vx in range(fx0, fx1):
		for vz in range(fz0, fz1):
			_set_voxel(vx, 1, vz, grass)
			_set_voxel(vx, 0, vz, dirt)
	# Trees
	var trees: Array = [[_wu(3),_wu(3)],[_wu(7),_wu(5)],[_wu(11),_wu(8)],[_wu(4),_wu(14)],[_wu(9),_wu(18)],[_wu(2),_wu(22)],[_wu(12),_wu(25)],[_wu(6),_wu(28)]]
	for tp in trees:
		var tx: int = tp[0]; var tz: int = tp[1]
		for ty in range(1, 6): _set_voxel(tx, ty, tz, wood)
		for dx in range(-2, 3):
			for dz in range(-2, 3):
				for dy in range(4, 7):
					if abs(dx) <= 1 or abs(dz) <= 1 or dy == 4:
						_set_voxel(tx + dx, dy, tz + dz, leaves)


func _build_plains() -> void:
	var grass: int = get_type_id("grass")
	var dirt: int = get_type_id("dirt")
	for vx in range(_wu(16), _wu(48)):
		for vz in range(_wu(0), _wu(32)):
			var h: float = sin(float(vx) * 0.025) * cos(float(vz) * 0.02) * 6.0 + sin(float(vx) * 0.06) * 3.0
			var top: int = 2 + int(round(h))
			top = clampi(top, 1, 8)
			for y in range(1, top):
				_set_voxel(vx, y, vz, dirt)
			_set_voxel(vx, top, vz, grass)


func _build_ruins() -> void:
	var brick: int = get_type_id("brick")
	var ruined: int = get_type_id("ruined_stone")
	var moss: int = get_type_id("moss")
	var rx0: int = _wu(35); var rx1: int = _wu(60)
	var rz0: int = _wu(35); var rz1: int = _wu(60)
	for vx in range(rx0, rx1):
		for vz in range(rz0, rz1):
			if (vx + vz) % 3 != 0:
				_set_voxel(vx, 1, vz, ruined)
	# Wall
	for vx in range(_wu(36), _wu(59)):
		_set_voxel(vx, 2, _wu(36), ruined)
		_set_voxel(vx, 3, _wu(36), ruined)
		if vx % 4 == 0: _set_voxel(vx, 4, _wu(36), brick)
	# Columns
	for i in range(4):
		var cx: int = _wu(38) + i * _wu(6)
		for cy in range(1, 8): _set_voxel(cx, cy, _wu(52), brick)
		for dx in range(-1, 2):
			for dz in range(-1, 2):
				_set_voxel(cx + dx, 8, _wu(52) + dz, brick)
	# Moss
	for _i in range(50):
		_set_voxel(randi_range(rx0, rx1 - 1), 2, randi_range(rz0, rz1 - 1), moss)


func _build_crystal_cavern() -> void:
	var crystal: int = get_type_id("crystal")
	var obsidian: int = get_type_id("obsidian")
	var stone: int = get_type_id("stone")
	for vx in range(_wu(2), _wu(14)):
		for vz in range(_wu(34), _wu(62)):
			_set_voxel(vx, 1, vz, obsidian)
			_set_voxel(vx, 0, vz, stone)
	# Hollow
	for vx in range(_wu(4), _wu(12)):
		for vz in range(_wu(38), _wu(58)):
			_set_voxel(vx, 1, vz, 0)
	# Crystal clusters
	for _i in range(30):
		var cx: int = randi_range(_wu(3), _wu(13))
		var cz: int = randi_range(_wu(35), _wu(61))
		for y in range(1, randi_range(2, 5)):
			_set_voxel(cx, y, cz, crystal)


func _build_desert() -> void:
	var sand: int = get_type_id("sand")
	var gravel: int = get_type_id("gravel")
	for vx in range(_wu(48), _wu(64)):
		for vz in range(_wu(0), _wu(32)):
			var h: float = abs(sin(float(vx) * 0.03) * cos(float(vz) * 0.04) * 6.0)
			var top: int = 2 + int(round(h))
			top = clampi(top, 1, 8)
			for y in range(1, top):
				_set_voxel(vx, y, vz, sand)
			_set_voxel(vx, top, vz, sand)
	for _i in range(80):
		_set_voxel(randi_range(_wu(48), _wu(63)), 1, randi_range(_wu(0), _wu(31)), gravel)


func _build_volcanic() -> void:
	var volcanic: int = get_type_id("volcanic")
	var obsidian: int = get_type_id("obsidian")
	var snow: int = get_type_id("snow")
	for vx in range(_wu(32), _wu(48)):
		for vz in range(_wu(0), _wu(32)):
			_set_voxel(vx, 1, vz, volcanic)
	# Columns
	for _i in range(12):
		var bx: int = randi_range(_wu(33), _wu(46))
		var bz: int = randi_range(_wu(2), _wu(29))
		var h: int = randi_range(4, 10)
		for y in range(1, h):
			_set_voxel(bx, y, bz, volcanic)
			if y <= 2:
				_set_voxel(bx + 1, y, bz, volcanic)
				_set_voxel(bx, y, bz + 1, volcanic)
		_set_voxel(bx, h, bz, snow)
	# Obsidian veins
	for _i in range(50):
		_set_voxel(randi_range(_wu(33), _wu(46)), 1, randi_range(_wu(2), _wu(29)), obsidian)
