class_name VoxelWorld
extends Node3D
## Sky Island world generator — 5 floating biomes, caves, giant trees, bridges, waterfalls.

const CHUNK_SIZE: int = 32
const VOXEL_SIZE: float = 0.2
const VOXELS_PER_UNIT: int = 5
const TYPE_DIR: String = "res://data/voxel/types/"
const DAMAGE_PER_HIT: int = 25

var type_ids: Dictionary = {}
var type_table: Array = []
var _chunks: Array = []
var _interactables_spawned: bool = false

@export var chunks_x: int = 8
@export var chunks_y: int = 8
@export var chunks_z: int = 8


func _ready() -> void:
	_load_voxel_types()
	_spawn_all_chunks()
	_build_sky_islands()
	_carve_caves()
	_build_giant_trees()
	_paint_surface()
	_build_bridges()
	_build_waterfalls()
	_create_floor()
	_rebuild_all()
	set_process(true)
	print("VOXEL_WORLD_READY")


func _process(_delta: float) -> void:
	if not _interactables_spawned:
		_interactables_spawned = true
		spawn_interactables()
		set_process(false)


func _load_voxel_types() -> void:
	type_table.clear(); type_table.append(null); type_ids.clear()
	var names: Array = ["stone","dirt","grass","wood","leaves","brick","crystal","obsidian","sand","gravel","moss","ice","ruined_stone","volcanic","snow","bedrock"]
	for nm in names:
		var vt: VoxelType = load(TYPE_DIR + nm + ".tres") as VoxelType
		if vt: type_ids[nm] = type_table.size(); type_table.append(vt)


func get_type_id(nm: String) -> int: return type_ids.get(nm, 0)
func get_type(id: int) -> VoxelType:
	if id > 0 and id < type_table.size(): return type_table[id]
	return null


func _spawn_all_chunks() -> void:
	_chunks.clear()
	var scene: PackedScene = load("res://scenes/world/voxel_chunk.tscn")
	var wu: float = float(CHUNK_SIZE) * VOXEL_SIZE
	for cx in range(chunks_x):
		_chunks.append([])
		for cy in range(chunks_y):
			_chunks[cx].append([])
			for cz in range(chunks_z):
				var chunk: VoxelChunk = scene.instantiate()
				chunk._skip_rebuild = true
				chunk._init_empty()
				chunk.name = "Chunk_%d_%d_%d" % [cx, cy, cz]
				chunk.position = Vector3(float(cx) * wu, float(cy) * wu, float(cz) * wu)
				chunk.register_types(type_table)
				add_child(chunk)
				_chunks[cx][cy].append(chunk)
	print("VoxelWorld: %d chunks" % (chunks_x * chunks_y * chunks_z))


func _chunk_at(cx: int, cy: int, cz: int) -> VoxelChunk:
	if cx >= 0 and cx < _chunks.size() and cy >= 0 and cy < _chunks[cx].size() and cz >= 0 and cz < _chunks[cx][cy].size():
		return _chunks[cx][cy][cz]
	return null


func get_chunk_at(wx: float, wy: float, wz: float) -> VoxelChunk:
	var cx: int = int(floor(wx / (float(CHUNK_SIZE) * VOXEL_SIZE)))
	var cy: int = int(floor(wy / (float(CHUNK_SIZE) * VOXEL_SIZE)))
	var cz: int = int(floor(wz / (float(CHUNK_SIZE) * VOXEL_SIZE)))
	return _chunk_at(cx, cy, cz)


func damage_voxel_at(world_pos: Vector3, amount: int) -> Dictionary:
	var result: Dictionary = {"destroyed": false, "sub_voxels_lost": 0, "debris_pos": world_pos, "voxel_type": 0}
	var vx: int = int(world_pos.x / VOXEL_SIZE)
	var vy: int = int(world_pos.y / VOXEL_SIZE)
	var vz: int = int(world_pos.z / VOXEL_SIZE)
	var cx: int = vx / CHUNK_SIZE
	var cy: int = vy / CHUNK_SIZE
	var cz: int = vz / CHUNK_SIZE
	var chunk: VoxelChunk = _chunk_at(cx, cy, cz)
	if not chunk: return result
	var lx: int = vx - cx * CHUNK_SIZE
	var ly: int = vy - cy * CHUNK_SIZE
	var lz: int = vz - cz * CHUNK_SIZE
	if not chunk.is_in_bounds(lx, ly, lz): return result
	result.voxel_type = chunk.get_voxel(lx, ly, lz)
	if result.voxel_type <= 0: return result
	var dmg: Dictionary = chunk.damage_voxel(lx, ly, lz, amount)
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
	var cy: int = vy / CHUNK_SIZE
	var cz: int = vz / CHUNK_SIZE
	var c: VoxelChunk = _chunk_at(cx, cy, cz)
	if c: c.set_voxel(vx - cx * CHUNK_SIZE, vy - cy * CHUNK_SIZE, vz - cz * CHUNK_SIZE, type_id)


func _create_floor() -> void:
	var floor_node: StaticBody3D = get_node_or_null("FloorCollision")
	if not floor_node: return
	var cs: CollisionShape3D = floor_node.get_node_or_null("CollisionShape3D")
	if not cs: return
	var total_w: float = float(chunks_x * CHUNK_SIZE) * VOXEL_SIZE
	var total_d: float = float(chunks_z * CHUNK_SIZE) * VOXEL_SIZE
	var box: BoxShape3D = BoxShape3D.new()
	box.size = Vector3(total_w, 0.2, total_d)
	cs.shape = box
	cs.position = Vector3(total_w / 2.0, -2.0, total_d / 2.0)
	floor_node.collision_layer = 1


func _rebuild_all() -> void:
	for cx in range(chunks_x):
		for cy in range(chunks_y):
			for cz in range(chunks_z):
				var c: VoxelChunk = _chunk_at(cx, cy, cz)
				if c and c.grid.count(0) < c.grid.size():
					c.rebuild()


func _get_voxel_raw(vx: int, vy: int, vz: int) -> int:
	var cx: int = vx / CHUNK_SIZE; var cy: int = vy / CHUNK_SIZE; var cz: int = vz / CHUNK_SIZE
	var c: VoxelChunk = _chunk_at(cx, cy, cz)
	if c: return c.get_voxel(vx - cx * CHUNK_SIZE, vy - cy * CHUNK_SIZE, vz - cz * CHUNK_SIZE)
	return 0


## ═══════════════ Sky Islands ═══════════════

func _build_sky_islands() -> void:
	_build_island(40, 160, 40, 28, 10, "volcanic", ["obsidian","volcanic","stone"])
	_build_island(120, 100, 120, 36, 14, "forest", ["stone","dirt","stone"])
	_build_island(80, 72, 160, 24, 8, "crystal", ["stone","obsidian","crystal"])
	_build_island(160, 48, 80, 24, 8, "ruins", ["ruined_stone","brick","stone"])
	_build_island(200, 28, 200, 20, 6, "desert", ["sand","gravel","sand"])


func _build_island(cx: int, base_y: int, cz: int, radius: int, height: int, _biome: String, layers: Array) -> void:
	var r2: float = float(radius * radius)
	for dx in range(-radius, radius + 1):
		for dz in range(-radius, radius + 1):
			var dist2: float = float(dx * dx + dz * dz)
			if dist2 > r2: continue
			var edge_factor: float = dist2 / r2
			var max_h: int = int(float(height) * (1.0 - edge_factor * 0.6))
			if max_h < 2: max_h = 2
			max_h += int(round(sin(float(dx) * 0.3) * cos(float(dz) * 0.4) * 2.0 + sin(float(dx + dz) * 0.15) * 3.0))
			if max_h < 1: max_h = 1
			for dy in range(0, max_h):
				var vy: int = base_y + dy
				if vy < 0: continue
				var mat: String = layers[1]
				if dy == 0: mat = layers[0]
				elif dy == max_h - 1: mat = layers[2]
				_set_voxel(cx + dx, vy, cz + dz, get_type_id(mat))
			if edge_factor > 0.5 and max_h < height - 1:
				for udy in range(-3, 0):
					var uvy: int = base_y + udy
					if uvy >= 0 and randf() < 0.3:
						_set_voxel(cx + dx, uvy, cz + dz, get_type_id(layers[0]))


func _carve_caves() -> void:
	_carve_hollow(80, 80, 160, 10)
	_carve_tunnel(25, 170, 25, 55, 170, 55, 6)
	_carve_tunnel(150, 55, 70, 170, 55, 90, 5)


func _carve_hollow(center_x: int, center_y: int, center_z: int, radius: int) -> void:
	var r2: float = float(radius * radius)
	for dx in range(-radius, radius + 1):
		for dy in range(-radius, radius + 1):
			for dz in range(-radius, radius + 1):
				if float(dx*dx + dy*dy + dz*dz) <= r2:
					_set_voxel(center_x + dx, center_y + dy, center_z + dz, 0)


func _carve_tunnel(x1: int, y1: int, z1: int, x2: int, y2: int, z2: int, radius: int) -> void:
	var steps: int = 40; var r2: float = float(radius * radius)
	for i in range(steps):
		var t: float = float(i) / float(steps - 1)
		var px: float = lerpf(float(x1), float(x2), t) + sin(t * 12.0) * 6.0
		var py: float = lerpf(float(y1), float(y2), t) + cos(t * 8.0) * 3.0
		var pz: float = lerpf(float(z1), float(z2), t) + cos(t * 10.0) * 5.0
		for dx in range(-radius, radius + 1):
			for dy in range(-radius, radius + 1):
				for dz in range(-radius, radius + 1):
					if float(dx*dx + dy*dy + dz*dz) <= r2:
						_set_voxel(int(px) + dx, int(py) + dy, int(pz) + dz, 0)


func _build_giant_trees() -> void:
	var wood: int = get_type_id("wood"); var leaves: int = get_type_id("leaves")
	var trees: Array = [[105,100,105],[135,100,105],[120,100,120],[110,100,135],[130,100,130],[120,100,100]]
	for tp in trees:
		var tx: int = tp[0]; var ty: int = tp[1]; var tz: int = tp[2]
		for sy in range(ty + 30, ty, -1):
			if _get_voxel_raw(tx, sy, tz) > 0: ty = sy + 1; break
		var trunk_h: int = randi_range(10, 15)
		for h in range(trunk_h):
			for tdx in range(-2, 3):
				for tdz in range(-2, 3):
					if abs(tdx) <= 1 and abs(tdz) <= 1:
						_set_voxel(tx + tdx, ty + h, tz + tdz, wood)
		var canopy_y: int = ty + trunk_h
		for ldx in range(-5, 6):
			for ldy in range(-3, 5):
				for ldz in range(-5, 6):
					if float(ldx*ldx + ldy*ldy*0.7 + ldz*ldz) <= 25.0 and randf() > 0.15:
						_set_voxel(tx + ldx, canopy_y + ldy, tz + ldz, leaves)
		for rdx in range(-2, 3):
			for rdz in range(-2, 3):
				if abs(rdx) + abs(rdz) <= 3:
					_set_voxel(tx + rdx, ty - 1, tz + rdz, wood)


func _paint_surface() -> void:
	var grass: int = get_type_id("grass"); var dirt: int = get_type_id("dirt"); var stone: int = get_type_id("stone")
	for vx in range(90, 150):
		for vz in range(90, 150):
			for vy in range(50, 140):
				var tid: int = _get_voxel_raw(vx, vy, vz)
				if tid == dirt or tid == stone:
					if _get_voxel_raw(vx, vy + 1, vz) == 0:
						_set_voxel(vx, vy, vz, grass)


func _build_bridges() -> void:
	_build_bridge_arch(70, 168, 50, 100, 108, 100, "brick")
	_build_bridge_arch(100, 108, 150, 70, 80, 160, "wood")
	_build_bridge_arch(155, 55, 100, 140, 102, 110, "brick")
	_build_bridge_arch(90, 80, 170, 195, 35, 190, "wood")


func _build_bridge_arch(x1: int, y1: int, z1: int, x2: int, y2: int, z2: int, mat: String) -> void:
	var mid: int = get_type_id(mat)
	var steps: int = maxi(abs(x2-x1) + abs(z2-z1), 1)
	for i in range(steps + 1):
		var t: float = float(i) / float(steps)
		var bx: int = int(lerpf(float(x1), float(x2), t))
		var bz: int = int(lerpf(float(z1), float(z2), t))
		var by: int = int(lerpf(float(y1), float(y2), t)) + int(sin(t * PI) * 6.0)
		for wdx in range(-2, 3):
			for wdz in range(-2, 3):
				if abs(wdx) + abs(wdz) <= 2:
					_set_voxel(bx + wdx, by, bz + wdz, mid)
				if abs(wdx) <= 1 and abs(wdz) <= 1:
					_set_voxel(bx + wdx, by - 1, bz + wdz, mid)


func _build_waterfalls() -> void:
	var ice: int = get_type_id("ice")
	var falls: Array = [[30,168,35,12],[55,168,30,14],[130,102,150,10],[100,102,140,12],[70,78,170,8],[95,78,165,10],[165,50,85,9],[175,50,75,7]]
	for fp in falls:
		for dy in range(fp[3]):
			for w in range(-1, 2):
				_set_voxel(fp[0] + w, fp[1] - dy, fp[2] + w, ice)
				_set_voxel(fp[0] + w, fp[1] - dy, fp[2], ice)


func spawn_interactables() -> void:
	_spawn_in_region(25,170,25,15,"ash_fragment",Interactable.InteractType.EXAMINE,{"type":"volcanic"},5)
	_spawn_in_region(35,175,35,10,"volcanic_core",Interactable.InteractType.ACTIVATE,{"type":"volcanic"},2)
	_spawn_in_region(105,110,105,20,"herb_cluster",Interactable.InteractType.COLLECT,{"type":"flora"},6)
	_spawn_in_region(115,108,115,15,"ancient_bark",Interactable.InteractType.EXAMINE,{"type":"flora"},3)
	_spawn_in_region(120,112,120,12,"glowing_mushroom",Interactable.InteractType.EXAMINE,{"type":"fungus"},2)
	_spawn_in_region(70,80,150,12,"crystal_shard",Interactable.InteractType.EXAMINE,{"type":"mineral"},5)
	_spawn_in_region(80,76,160,8,"geode",Interactable.InteractType.ACTIVATE,{"type":"mineral"},2)
	_spawn_in_region(78,84,158,6,"glowing_fungus",Interactable.InteractType.COLLECT,{"type":"fungus"},4)
	_spawn_in_region(150,56,70,12,"ancient_stone",Interactable.InteractType.EXAMINE,{"type":"ruins"},4)
	_spawn_in_region(160,54,80,10,"moss_sample",Interactable.InteractType.COLLECT,{"type":"flora"},3)
	_spawn_in_region(155,52,75,8,"broken_tablet",Interactable.InteractType.EXAMINE,{"type":"ruins"},2)
	_spawn_in_region(165,54,80,5,"ore_deposit",Interactable.InteractType.EXAMINE,{"type":"mineral"},3)
	_spawn_in_region(195,36,195,8,"sand_tablet",Interactable.InteractType.ACTIVATE,{"type":"artifact"},3)
	_spawn_in_region(200,34,200,6,"sunken_relic",Interactable.InteractType.EXAMINE,{"type":"artifact"},2)


func _spawn_in_region(cx: int, cy: int, cz: int, r: int, id: String, itype: int, props: Dictionary, count: int) -> void:
	for _i in range(count):
		_spawn_one(Vector3((cx+randf_range(-r,r))*VOXEL_SIZE,(cy+randf_range(-2,3))*VOXEL_SIZE,(cz+randf_range(-r,r))*VOXEL_SIZE),id,itype,id,props)


func _spawn_one(pos: Vector3, id: String, itype: int, obs_id: String, props: Dictionary) -> void:
	var inter: Interactable = Interactable.new()
	inter.interactable_id = id
	inter.interact_type = itype as Interactable.InteractType
	inter.position = pos
	var col: CollisionShape3D = CollisionShape3D.new()
	var sphere: SphereShape3D = SphereShape3D.new(); sphere.radius = 0.4
	col.shape = sphere; inter.add_child(col)
	var obs: Node = Node.new()
	obs.set_script(load("res://scripts/components/observable.gd"))
	obs.observable_id = obs_id; obs.properties = props
	inter.add_child(obs)
	add_child(inter)
	inter.add_to_group("interactable")
