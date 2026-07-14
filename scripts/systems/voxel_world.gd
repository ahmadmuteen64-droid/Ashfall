class_name VoxelWorld
extends Node3D
## One giant island, one biome at a time. Portals switch biomes.

const CHUNK_SIZE: int = 32
const VOXEL_SIZE: float = 1.0
const VOXELS_PER_UNIT: int = 1
const TYPE_DIR: String = "res://data/voxel/types/"
const DAMAGE_PER_HIT: int = 25

var type_ids: Dictionary = {}
var type_table: Array = []
var _chunks: Array = []
var _dirty: Dictionary = {}
var _current_biome: String = "forest"
var _portal_nodes: Array = []

@export var chunks_x: int = 8
@export var chunks_y: int = 6
@export var chunks_z: int = 8


var _rebuild_keys: Array = []
var _rebuild_idx: int = 0
var _is_switching: bool = false
var _target_biome: String = ""
var _loading_screen: Node = null


func _ready() -> void:
	_load_voxel_types()
	_spawn_all_chunks()
	generate_biome("forest")
	_rebuild_dirty()




func _process(_delta: float) -> void:
	if not _is_switching: return
	var end := mini(_rebuild_idx + 8, _rebuild_keys.size())
	while _rebuild_idx < end:
		var k: String = _rebuild_keys[_rebuild_idx]
		var p: PackedStringArray = k.split(",")
		var c: VoxelChunk = _chunk_at(int(p[0]), int(p[1]), int(p[2]))
		if c: c.rebuild()
		_rebuild_idx += 1
	if _loading_screen and _loading_screen.has_method("set_progress"):
		_loading_screen.set_progress(float(_rebuild_idx) / float(_rebuild_keys.size()))
	if _rebuild_idx >= _rebuild_keys.size():
		_is_switching = false
		if _loading_screen and _loading_screen.has_method("hide_loading"):
			_loading_screen.hide_loading()
		var player := get_node_or_null("../Player")
		if player: player.set_physics_process(true)
		set_process(false)
		print("BIOME_READY: " + _current_biome)
	_load_voxel_types()
	_spawn_all_chunks()
	generate_biome("forest")


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
	var cx: int = vx / CHUNK_SIZE; var cy: int = vy / CHUNK_SIZE; var cz: int = vz / CHUNK_SIZE
	var chunk: VoxelChunk = _chunk_at(cx, cy, cz)
	if not chunk: return result
	var lx: int = vx - cx * CHUNK_SIZE; var ly: int = vy - cy * CHUNK_SIZE; var lz: int = vz - cz * CHUNK_SIZE
	if not chunk.is_in_bounds(lx, ly, lz): return result
	result.voxel_type = chunk.get_voxel(lx, ly, lz)
	if result.voxel_type <= 0: return result
	var dmg: Dictionary = chunk.damage_voxel(lx, ly, lz, amount)
	result.sub_voxels_lost = dmg.get("sub_voxels_lost", 0)
	if dmg.get("destroyed", false): result.destroyed = true
	_spawn_debris(world_pos, result.voxel_type, result.sub_voxels_lost)
	chunk.rebuild()
	return result


func _spawn_debris(world_pos: Vector3, type_id: int, sub_voxels: int) -> void:
	var vt: VoxelType = get_type(type_id)
	if not vt: return
	for _i in range(clampi(sub_voxels / 5, 1, 20)):
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
	var cx: int = vx / CHUNK_SIZE; var cy: int = vy / CHUNK_SIZE; var cz: int = vz / CHUNK_SIZE
	var c: VoxelChunk = _chunk_at(cx, cy, cz)
	if c:
		c.set_voxel(vx - cx * CHUNK_SIZE, vy - cy * CHUNK_SIZE, vz - cz * CHUNK_SIZE, type_id)
		_dirty[str(cx) + "," + str(cy) + "," + str(cz)] = true


func _rebuild_dirty() -> void:
	for k in _dirty:
		var p: PackedStringArray = k.split(",")
		var c: VoxelChunk = _chunk_at(int(p[0]), int(p[1]), int(p[2]))
		if c: c.rebuild()


func _get_voxel_raw(vx: int, vy: int, vz: int) -> int:
	var cx: int = vx / CHUNK_SIZE; var cy: int = vy / CHUNK_SIZE; var cz: int = vz / CHUNK_SIZE
	var c: VoxelChunk = _chunk_at(cx, cy, cz)
	if c: return c.get_voxel(vx - cx * CHUNK_SIZE, vy - cy * CHUNK_SIZE, vz - cz * CHUNK_SIZE)
	return 0


## ═══════════════ Biome Generation ═══════════════

func generate_biome(biome: String) -> void:
	_clear_portals()
	_clear_voxels()
	_current_biome = biome
	
	var cx: int = 25; var cz: int = 25; var base_y: int = 10
	match biome:
		"forest":
			_build_island(cx, base_y, cz, 25, 10, ["stone","dirt","stone"])
			_build_trees(cx, base_y, cz, 24, 10)
			_paint_grass(cx - 24, cz - 24, cx + 24, cz + 24, base_y, base_y + 12)
		"volcanic":
			_build_island(cx, base_y, cz, 25, 9, ["obsidian","volcanic","stone"])
			_build_volcanic_columns(cx, base_y, cz, 22, 15)
		"crystal":
			_build_island(cx, base_y, cz, 25, 8, ["stone","obsidian","crystal"])
			_carve_hollow(cx, base_y + 8, cz, 15)
			_build_crystal_spikes(cx, base_y, cz, 22, 30)
		"ruins":
			_build_island(cx, base_y, cz, 25, 9, ["ruined_stone","brick","stone"])
			_build_ruins(cx, base_y, cz, 22)
		"desert":
			_build_island(cx, base_y, cz, 25, 7, ["sand","gravel","sand"])
			_build_dunes(cx, base_y, cz, 24)
		"lake":
			_build_island(cx, base_y, cz, 25, 6, ["stone","gravel","ice"])
			_build_lake_surface(cx, base_y + 2, cz, 16)
	
	_spawn_portals(cx, base_y, cz)
	print("BIOME_GEN: " + biome + " dirty:" + str(_dirty.size()))


func switch_biome(target_biome: String) -> void:
	generate_biome(target_biome)


## ═══════════════ Island Builder ═══════════════

func _build_island(cx: int, base_y: int, cz: int, radius: int, height: int, layers: Array) -> void:
	var r2: float = float(radius * radius)
	for dx in range(-radius, radius + 1):
		for dz in range(-radius, radius + 1):
			var dist2: float = float(dx * dx + dz * dz)
			if dist2 > r2: continue
			var edge_factor: float = dist2 / r2
			var max_h: int = int(float(height) * (1.0 - edge_factor * 0.5))
			if max_h < 2: max_h = 2
			max_h += int(round(sin(float(dx) * 0.15) * cos(float(dz) * 0.2) * 3.0 + sin(float(dx + dz) * 0.08) * 4.0))
			if max_h < 1: max_h = 1
			for dy in range(0, max_h):
				var vy: int = base_y + dy
				var mat: String = layers[1]
				if dy == 0: mat = layers[0]
				elif dy == max_h - 1: mat = layers[2]
				_set_voxel(cx + dx, vy, cz + dz, get_type_id(mat))


## ═══════════════ Biome Features ═══════════════

func _build_trees(cx: int, base_y: int, cz: int, radius: int, count: int) -> void:
	var wood: int = get_type_id("wood"); var leaves: int = get_type_id("leaves")
	for _i in range(count):
		var tx: int = cx + randi_range(-radius + 10, radius - 10)
		var tz: int = cz + randi_range(-radius + 10, radius - 10)
		var ty: int = base_y
		for sy in range(ty + 30, ty, -1):
			if _get_voxel_raw(tx, sy, tz) > 0: ty = sy + 1; break
		var trunk_h: int = randi_range(15, 25)
		for h in range(trunk_h):
			for tdx in range(-2, 3):
				for tdz in range(-2, 3):
					if abs(tdx) <= 1 and abs(tdz) <= 1:
						_set_voxel(tx + tdx, ty + h, tz + tdz, wood)
		var canopy_y: int = ty + trunk_h
		for ldx in range(-6, 7):
			for ldy in range(-3, 6):
				for ldz in range(-6, 7):
					if float(ldx*ldx + ldy*ldy*0.6 + ldz*ldz) <= 36.0 and randf() > 0.2:
						_set_voxel(tx + ldx, canopy_y + ldy, tz + ldz, leaves)


func _build_volcanic_columns(cx: int, base_y: int, cz: int, radius: int, count: int) -> void:
	var vol: int = get_type_id("volcanic"); var snow: int = get_type_id("snow")
	for _i in range(count):
		var bx: int = cx + randi_range(-radius + 5, radius - 5)
		var bz: int = cz + randi_range(-radius + 5, radius - 5)
		var h: int = randi_range(6, 14)
		for y in range(h):
			for dx in range(-2, 3):
				for dz in range(-2, 3):
					if abs(dx) + abs(dz) <= 2:
						_set_voxel(bx + dx, base_y + 1 + y, bz + dz, vol)
			_set_voxel(bx, base_y + 1 + h, bz, snow)


func _build_crystal_spikes(cx: int, base_y: int, cz: int, radius: int, count: int) -> void:
	var crystal: int = get_type_id("crystal")
	for _i in range(count):
		var px: int = cx + randi_range(-radius + 5, radius - 5)
		var pz: int = cz + randi_range(-radius + 5, radius - 5)
		var h: int = randi_range(3, 8)
		for y in range(h):
			_set_voxel(px, base_y + 1 + y, pz, crystal)
			if y < h - 2:
				_set_voxel(px + 1, base_y + 1 + y, pz, crystal)


func _build_ruins(cx: int, base_y: int, cz: int, radius: int) -> void:
	var brick: int = get_type_id("brick"); var moss: int = get_type_id("moss")
	# Scattered walls
	for _i in range(8):
		var rx: int = cx + randi_range(-radius + 10, radius - 10)
		var rz: int = cz + randi_range(-radius + 10, radius - 10)
		for h in range(randi_range(2, 6)):
			for w in range(randi_range(3, 8)):
				_set_voxel(rx + w, base_y + 1 + h, rz, brick)
				if h == 0:
					_set_voxel(rx + w, base_y + 1 + h, rz + 1, moss)


func _build_dunes(cx: int, base_y: int, cz: int, radius: int) -> void:
	var sand: int = get_type_id("sand"); var gravel: int = get_type_id("gravel")
	for _i in range(40):
		var dx: int = randi_range(-radius + 3, radius - 3)
		var dz: int = randi_range(-radius + 3, radius - 3)
		var h: int = randi_range(1, 3)
		for dy in range(h):
			_set_voxel(cx + dx, base_y + 1 + dy, cz + dz, sand)
		_set_voxel(cx + dx, base_y, cz + dz, gravel)


func _build_lake_surface(cx: int, surface_y: int, cz: int, radius: int) -> void:
	var ice: int = get_type_id("ice"); var stone: int = get_type_id("stone")
	for dx in range(-radius, radius + 1):
		for dz in range(-radius, radius + 1):
			if float(dx*dx + dz*dz) <= float(radius * radius) * 0.9:
				for dy in range(-3, 1):
					_set_voxel(cx + dx, surface_y + dy, cz + dz, ice)
				_set_voxel(cx + dx, surface_y - 3, cz + dz, stone)


func _paint_grass(x0: int, z0: int, x1: int, z1: int, y_min: int, y_max: int) -> void:
	var grass: int = get_type_id("grass"); var dirt: int = get_type_id("dirt"); var stone: int = get_type_id("stone")
	for vx in range(x0, x1, 2):
		for vz in range(z0, z1, 2):
			for vy in range(y_min, y_max):
				var tid: int = _get_voxel_raw(vx, vy, vz)
				if tid == dirt or tid == stone:
					if _get_voxel_raw(vx, vy + 1, vz) == 0:
						_set_voxel(vx, vy, vz, grass)
					break


func _carve_hollow(center_x: int, center_y: int, center_z: int, radius: int) -> void:
	var r2: float = float(radius * radius)
	for dx in range(-radius, radius + 1):
		for dy in range(-radius, radius + 1):
			for dz in range(-radius, radius + 1):
				if float(dx*dx + dy*dy + dz*dz) <= r2:
					_set_voxel(center_x + dx, center_y + dy, center_z + dz, 0)


func _clear_voxels() -> void:
	for k in _dirty:
		var p: PackedStringArray = k.split(",")
		var c: VoxelChunk = _chunk_at(int(p[0]), int(p[1]), int(p[2]))
		if c:
			for x in range(CHUNK_SIZE):
				for y in range(CHUNK_SIZE):
					for z in range(CHUNK_SIZE):
						c.set_voxel(x, y, z, 0)
		c.rebuild()
	_dirty.clear()


## ═══════════════ Portals ═══════════════

func _spawn_portals(cx: int, base_y: int, cz: int) -> void:
	var biomes := ["volcanic", "crystal", "ruins", "desert", "lake", "forest"]
	var idx := 0
	for b in biomes:
		if b == _current_biome: continue
		var angle: float = float(idx) * TAU / float(biomes.size() - 1)
		var px: float = (float(cx) + cos(angle) * 14.0) * VOXEL_SIZE
		var pz: float = (float(cz) + sin(angle) * 14.0) * VOXEL_SIZE
		var py: float = (float(base_y) + 5.0) * VOXEL_SIZE
		_spawn_portal(Vector3(px, py, pz), b)
		idx += 1


func _spawn_portal(pos: Vector3, target_biome: String) -> void:
	var inter: Interactable = Interactable.new()
	inter.name = "Portal_" + target_biome
	inter.interactable_id = "portal_" + target_biome
	inter.interact_type = Interactable.InteractType.ACTIVATE
	inter.position = pos
	var col: CollisionShape3D = CollisionShape3D.new()
	var sphere: SphereShape3D = SphereShape3D.new(); sphere.radius = 1.0
	col.shape = sphere; inter.add_child(col)
	# Portal glow effect — use crystal material
	var vis: MeshInstance3D = MeshInstance3D.new()
	var ring: CylinderMesh = CylinderMesh.new()
	ring.top_radius = 1.0; ring.bottom_radius = 1.0; ring.height = 2.5
	vis.mesh = ring
	vis.material_override = _get_portal_mat(target_biome)
	inter.add_child(vis)
	# Label
	var lbl: Label3D = Label3D.new()
	lbl.text = target_biome.to_upper()
	lbl.position = Vector3(0, 1.8, 0)
	lbl.font_size = 32
	lbl.modulate = Color.WHITE
	inter.add_child(lbl)
	# Connect to biome switch
	inter.interacted.connect(_on_portal_used.bind(target_biome))
	add_child(inter)
	_portal_nodes.append(inter)


func _get_portal_mat(biome: String) -> Material:
	var mat := StandardMaterial3D.new()
	mat.emission_enabled = true
	match biome:
		"volcanic": mat.albedo_color = Color(1.0, 0.3, 0.1); mat.emission = Color(1.0, 0.2, 0.05)
		"crystal": mat.albedo_color = Color(0.3, 0.6, 1.0); mat.emission = Color(0.1, 0.3, 0.8)
		"ruins": mat.albedo_color = Color(0.6, 0.5, 0.3); mat.emission = Color(0.3, 0.25, 0.1)
		"desert": mat.albedo_color = Color(1.0, 0.8, 0.3); mat.emission = Color(0.4, 0.3, 0.05)
		"lake": mat.albedo_color = Color(0.3, 0.7, 1.0); mat.emission = Color(0.1, 0.2, 0.5)
		_: mat.albedo_color = Color(0.3, 1.0, 0.3); mat.emission = Color(0.1, 0.4, 0.1)
	mat.emission_energy_multiplier = 2.0
	return mat


func _on_portal_used(_id: String, _type: int, target_biome: String) -> void:
	print("PORTAL: " + target_biome)
	var player := get_node_or_null("../Player")
	if player:
		player.position = Vector3(25 * VOXEL_SIZE, 14 * VOXEL_SIZE, 25 * VOXEL_SIZE)
		player.set_physics_process(false)
	_loading_screen = get_node_or_null("../LoadingScreen")
	if _loading_screen and _loading_screen.has_method("show_loading"):
		_loading_screen.show_loading()
	generate_biome(target_biome)
	_rebuild_keys = _dirty.keys()
	_rebuild_idx = 0
	_is_switching = true
	set_process(true)
func _clear_portals() -> void:
	for p in _portal_nodes:
		p.queue_free()
	_portal_nodes.clear()
