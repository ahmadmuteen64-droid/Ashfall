class_name VoxelWorld
extends Node3D
## World manager: loads voxel types, spawns chunks, handles destruction with physics debris.
##
## Standing Rule: Every voxel has physics (via chunk trimesh). All voxels destructible
## except ground-plane (VoxelType.is_ground). Destruction spawns RigidBody3D debris.

const CHUNK_SIZE: int = 16
const TYPE_DIR: String = "res://data/voxel/types/"

## All voxel type IDs mapped to their resource paths
var type_ids: Dictionary = {}       ## "stone" -> 1, "dirt" -> 2, etc.
var type_table: Array = []          ## Index -> VoxelType (0=null/air)
var _chunks: Array = []             ## All spawned VoxelChunks
var _debris_scene: PackedScene      ## Preloaded debris scene

@export var world_size_x: int = 4   ## Chunks in X
@export var world_size_z: int = 4   ## Chunks in Z
@export var ground_y: int = 0       ## Y level of ground plane


func _ready() -> void:
	_load_voxel_types()
	_generate_world()
	print("VOXEL_WORLD_OK  types:%d  chunks:%d" % [type_table.size() - 1, _chunks.size()])


func _load_voxel_types() -> void:
	type_table.clear()
	type_table.append(null)  ## Index 0 = air
	type_ids.clear()

	var type_files: Array = [
		"stone","dirt","grass","wood","leaves","brick","crystal","obsidian",
		"sand","gravel","moss","ice","ruined_stone","volcanic","snow","bedrock"
	]
	for i in range(type_files.size()):
		var name: String = type_files[i]
		var path: String = TYPE_DIR + name + ".tres"
		var vt: VoxelType = load(path) as VoxelType
		if vt:
			type_ids[name] = type_table.size()
			type_table.append(vt)
		else:
			print("WARN: failed to load voxel type: " + path)

	print("VoxelWorld: loaded %d voxel types" % type_table.size())


func get_type_id(name: String) -> int:
	return type_ids.get(name, 0)


func get_type(id: int) -> VoxelType:
	if id > 0 and id < type_table.size():
		return type_table[id]
	return null


func _generate_world() -> void:
	_create_ground_plane()
	_build_plains()
	_build_forest()
	_build_ruins()
	_build_crystal_cavern()
	_build_desert()
	_build_volcanic_columns()
	_rebuild_all_chunks()


func _create_ground_plane() -> void:
	## One flat layer of bedrock under the entire world
	var bedrock_id: int = get_type_id("bedrock")
	var chunk_count_x: int = world_size_x
	var chunk_count_z: int = world_size_z
	for cx in range(chunk_count_x):
		for cz in range(chunk_count_z):
			var chunk: VoxelChunk = _spawn_chunk(cx * CHUNK_SIZE, 0, cz * CHUNK_SIZE)
			chunk.register_types(type_table)
			chunk.fill_rect(0, ground_y, 0, CHUNK_SIZE, 1, CHUNK_SIZE, bedrock_id)


func _spawn_chunk(world_x: int, world_y: int, world_z: int) -> VoxelChunk:
	var scene: PackedScene = load("res://scenes/world/voxel_chunk.tscn")
	var chunk: VoxelChunk = scene.instantiate()
	chunk.name = "Chunk_%d_%d_%d" % [world_x, world_y, world_z]
	chunk.position = Vector3(float(world_x), float(world_y), float(world_z))
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


func damage_voxel_at(world_pos: Vector3, amount: float, tool: String = "") -> Dictionary:
	## Returns {destroyed: bool, debris_pos: Vector3, voxel_type: int}
	var result: Dictionary = {"destroyed": false, "debris_pos": world_pos, "voxel_type": 0}
	var chunk: VoxelChunk = get_chunk_at(world_pos.x, world_pos.y, world_pos.z)
	if not chunk:
		return result
	var lx: int = int(world_pos.x) % CHUNK_SIZE
	var ly: int = int(world_pos.y) % CHUNK_SIZE
	var lz: int = int(world_pos.z) % CHUNK_SIZE
	if lx < 0: lx += CHUNK_SIZE
	if lz < 0: lz += CHUNK_SIZE
	if ly < 0: ly += CHUNK_SIZE
	var type_id: int = chunk.get_voxel(lx, ly, lz)
	result.voxel_type = type_id
	if type_id <= 0:
		return result
	if chunk.damage_voxel(lx, ly, lz, amount, tool):
		result.destroyed = true
		_spawn_debris(world_pos, type_id)
		chunk.rebuild()
	return result


func _spawn_debris(world_pos: Vector3, type_id: int) -> void:
	## Spawn 1-3 small RigidBody3D cubes as debris with physics
	var vt: VoxelType = get_type(type_id)
	if not vt:
		return
	var count: int = randi_range(1, 3)
	for i in range(count):
		var debris: RigidBody3D = RigidBody3D.new()
		debris.name = "Debris_%d" % i
		debris.position = world_pos + Vector3(randf_range(-0.3, 0.3), randf_range(0.1, 0.5), randf_range(-0.3, 0.3))
		debris.collision_layer = 2
		debris.collision_mask = 1
		debris.mass = 0.5
		debris.gravity_scale = 1.5
		# Mesh
		var mesh_inst: MeshInstance3D = MeshInstance3D.new()
		var box: BoxMesh = BoxMesh.new()
		box.size = Vector3(0.4, 0.4, 0.4)
		mesh_inst.mesh = box
		mesh_inst.material_override = vt.material
		debris.add_child(mesh_inst)
		# Collision
		var col: CollisionShape3D = CollisionShape3D.new()
		var box_shape: BoxShape3D = BoxShape3D.new()
		box_shape.size = Vector3(0.4, 0.4, 0.4)
		col.shape = box_shape
		debris.add_child(col)
		add_child(debris)
		# Random impulse
		debris.apply_central_impulse(Vector3(randf_range(-2, 2), randf_range(3, 6), randf_range(-2, 2)))
		debris.apply_torque_impulse(Vector3(randf_range(-5, 5), randf_range(-5, 5), randf_range(-5, 5)))
		# Auto-despawn after 5 seconds
		var timer: Timer = Timer.new()
		timer.wait_time = 5.0
		timer.one_shot = true
		timer.timeout.connect(debris.queue_free)
		debris.add_child(timer)
		timer.start()


func _rebuild_all_chunks() -> void:
	for c in _chunks:
		c.rebuild()


## ── World Building Functions ──────────────────────────────────
## Each function populates chunks at absolute world coordinates.
## Chunk position = (0,0,0) so world coords are local to each chunk.
## A voxel at world (x,y,z) maps to chunk at floor(x/16)*16, y, floor(z/16)*16.


func _set_world_voxel(wx: int, wy: int, wz: int, type_id: int) -> void:
	var cx: int = int(floor(float(wx) / CHUNK_SIZE)) * CHUNK_SIZE
	var cz: int = int(floor(float(wz) / CHUNK_SIZE)) * CHUNK_SIZE
	var lx: int = wx - cx
	var lz: int = wz - cz
	for c in _chunks:
		if int(c.position.x) == cx and int(c.position.z) == cz:
			c.set_voxel(lx, wy, lz, type_id)
			return


func _build_plains() -> void:
	## Rolling green plains in the center — grass on top, dirt below
	var grass_id: int = get_type_id("grass")
	var dirt_id: int = get_type_id("dirt")
	# Zone: world X 16-47, Z 0-31
	for x in range(16, 48):
		for z in range(0, 32):
			var h: int = ground_y + 1 + int(sin(float(x) * 0.2) * cos(float(z) * 0.15) * 2.0)
			_set_world_voxel(x, h, z, grass_id)
			_set_world_voxel(x, h - 1, z, dirt_id)


func _build_forest() -> void:
	## Dense forest with wood trunks and leaf canopies
	var wood_id: int = get_type_id("wood")
	var leaves_id: int = get_type_id("leaves")
	var grass_id: int = get_type_id("grass")
	var dirt_id: int = get_type_id("dirt")
	# Zone: world X 0-15, Z 0-31
	for x in range(0, 16):
		for z in range(0, 32):
			_set_world_voxel(x, ground_y + 1, z, grass_id)
			_set_world_voxel(x, ground_y, z, dirt_id)
	# Trees: trunk + canopy
	var tree_positions: Array = [
		[3,3],[7,5],[11,8],[4,14],[9,18],[2,22],[12,25],[6,28],
		[14,3],[8,12],[13,20],[5,26]
	]
	for tp in tree_positions:
		var tx: int = tp[0]
		var tz: int = tp[1]
		# Trunk
		for ty in range(ground_y + 1, ground_y + 6):
			_set_world_voxel(tx, ty, tz, wood_id)
		# Canopy
		for dx in range(-2, 3):
			for dz in range(-2, 3):
				for dy in range(4, 7):
					var canopy_x: int = tx + dx
					var canopy_z: int = tz + dz
					if abs(dx) <= 1 or abs(dz) <= 1 or dy == 4:
						_set_world_voxel(canopy_x, ground_y + dy, canopy_z, leaves_id)


func _build_ruins() -> void:
	## Ancient ruined structure with columns, broken walls, and arches
	var brick_id: int = get_type_id("brick")
	var ruined_id: int = get_type_id("ruined_stone")
	var moss_id: int = get_type_id("moss")
	# Zone: world X 32-63, Z 32-63
	# Temple floor
	for x in range(35, 60):
		for z in range(35, 60):
			if (x + z) % 3 != 0:  # Broken checker pattern
				_set_world_voxel(x, ground_y + 1, z, ruined_id)
	# Broken walls
	for x in range(36, 59):
		_set_world_voxel(x, ground_y + 2, 36, ruined_id)
		_set_world_voxel(x, ground_y + 3, 36, ruined_id)
		if x % 4 == 0:
			_set_world_voxel(x, ground_y + 4, 36, brick_id)
		# Gap (broken wall)
		if x >= 44 and x <= 48:
			_set_world_voxel(x, ground_y + 2, 36, 0)
			_set_world_voxel(x, ground_y + 3, 36, 0)
	# Columns
	for i in range(4):
		var cx: int = 38 + i * 6
		var cz: int = 52
		for cy in range(ground_y + 1, ground_y + 8):
			_set_world_voxel(cx, cy, cz, brick_id)
		# Column capital
		for dx in range(-1, 2):
			for dz in range(-1, 2):
				_set_world_voxel(cx + dx, ground_y + 8, cz + dz, brick_id)
	# Arch between columns
	for i in range(3):
		var ax: int = 41 + i * 6
		for ay in range(ground_y + 5, ground_y + 8):
			_set_world_voxel(ax, ay, 52, brick_id)
	# Moss patches
	for _i in range(20):
		var mx: int = randi_range(36, 58)
		var mz: int = randi_range(37, 59)
		_set_world_voxel(mx, ground_y + 2, mz, moss_id)


func _build_crystal_cavern() -> void:
	## Underground crystal formation with obsidian walls
	var crystal_id: int = get_type_id("crystal")
	var obsidian_id: int = get_type_id("obsidian")
	var stone_id: int = get_type_id("stone")
	# Zone: world X 0-15, Z 32-63
	# Obsidian shell / cave
	for x in range(2, 14):
		for z in range(34, 62):
			_set_world_voxel(x, ground_y + 1, z, obsidian_id)
			_set_world_voxel(x, ground_y, z, stone_id)
	# Hollow out center
	for x in range(4, 12):
		for z in range(38, 58):
			_set_world_voxel(x, ground_y + 1, z, 0)
	# Crystal clusters
	for _i in range(15):
		var cx: int = randi_range(3, 13)
		var cz: int = randi_range(35, 61)
		var h: int = randi_range(2, 5)
		for y in range(ground_y + 1, ground_y + h):
			_set_world_voxel(cx, y, cz, crystal_id)
		# Smaller crystal spikes
		for _j in range(randi_range(0, 3)):
			var sx: int = cx + randi_range(-1, 1)
			var sz: int = cz + randi_range(-1, 1)
			_set_world_voxel(sx, ground_y + 1, sz, crystal_id)


func _build_desert() -> void:
	## Sandy dunes region with scattered gravel
	var sand_id: int = get_type_id("sand")
	var gravel_id: int = get_type_id("gravel")
	# Zone: world X 48-63, Z 0-31
	for x in range(48, 64):
		for z in range(0, 32):
			var h: int = ground_y + 1 + int(abs(sin(float(x) * 0.15) * cos(float(z) * 0.2) * 3.0))
			_set_world_voxel(x, h, z, sand_id)
			_set_world_voxel(x, h - 1, z, sand_id)
		# Dune peaks
		var dune_h: int = ground_y + 1 + int(abs(sin(float(x) * 0.3)) * 5.0)
		for z in range(8, 24):
			_set_world_voxel(x, dune_h, z, sand_id)
	# Gravel patches
	for _i in range(30):
		var gx: int = randi_range(48, 63)
		var gz: int = randi_range(0, 31)
		_set_world_voxel(gx, ground_y + 1, gz, gravel_id)


func _build_volcanic_columns() -> void:
	## Basalt columns rising from dark ground with snow caps
	var volcanic_id: int = get_type_id("volcanic")
	var obsidian_id: int = get_type_id("obsidian")
	var snow_id: int = get_type_id("snow")
	# Zone: world X 32-63, Z 0-31 (shared with plains edge)
	# Volcanic ground
	for x in range(32, 48):
		for z in range(0, 32):
			_set_world_voxel(x, ground_y + 1, z, volcanic_id)
	# Basalt columns
	for _i in range(12):
		var bx: int = randi_range(33, 46)
		var bz: int = randi_range(2, 29)
		var h: int = randi_range(4, 10)
		for y in range(ground_y + 1, ground_y + h):
			_set_world_voxel(bx, y, bz, volcanic_id)
			# Column wider at base
			if y <= ground_y + 2:
				_set_world_voxel(bx + 1, y, bz, volcanic_id)
				_set_world_voxel(bx, y, bz + 1, volcanic_id)
		# Snow cap
		_set_world_voxel(bx, ground_y + h, bz, snow_id)
	# Obsidian veins
	for _i in range(20):
		var ox: int = randi_range(33, 46)
		var oz: int = randi_range(2, 29)
		_set_world_voxel(ox, ground_y + 1, oz, obsidian_id)
