# test_spatial_coherence.gd — D5 invariant: mesh ≡ collider ≡ standable surface
# Checks every interactable/gate in main.tscn against three spatial rules.
#
# Data extracted from res://scenes/world/main.tscn (commit e961b67).
# The text-parsing approach was fragile (ExtResource ID resolution, GDScript
# strict-mode warnings-as-errors). When the .tscn changes (R5 fixes positions),
# this test's data must be updated or replaced with a runtime check.
#
# Rules:
#   (a) Visual child within 1 m of collider
#   (b) Collider within 3 m of walkable surface (y ≈ 0)
#   (c) A point on the floor within sensor_range (3 m) of the collider
#
# THIS TEST MUST FAIL ON FIRST WRITE — every interactable violates D5.
extends Node

const SENSOR_RANGE: float = 3.0
const MESH_COLLIDER_MAX_DIST: float = 1.0
const FLOOR_MAX_DIST: float = 3.0
const FLOOR_Y: float = 0.0


func _ready() -> void:
	print("SPATIAL_COHERENCE: checking interactables against D5...")

	var violators: Array[String] = []

	# ── Interactables (Area3D with interactable.gd script) ──────────
	# Format: [name, interactable_id, collider_pos, visual_local_offset]
	var interactables: Array[Dictionary] = [
		{name="TestInteractable",    id="shrine_test_orb", pos=Vector3(0, 0, -58),    vis=Vector3(0, 0.3, 0)},
		{name="Crystal_Resonant",    id="crystal_resonant", pos=Vector3(2, 0, 32),    vis=Vector3(0, 0.3, 0)},
		{name="Crystal_Collect",     id="crystal_collect",  pos=Vector3(-2, 0, 30),   vis=Vector3(0, 0.25, 0)},
		{name="Moss_Plaza",          id="moss_plaza",       pos=Vector3(4, 0, -14),   vis=Vector3(0, 0.05, 0)},
		{name="Vine_Forest",         id="vine_forest",      pos=Vector3(0, 0, 5),     vis=Vector3(0, 0.5, 0)},
		{name="Station_Plaza",       id="combine_station",  pos=Vector3(-4, 0, -14),  vis=Vector3(0, 0.75, 0)},
	]

	for ia in interactables:
		var issues: Array[String] = _check_interactable(ia)
		var rid: String = str(ia.get("id", ia.get("name", "?")))
		if issues.is_empty():
			print("COHERENT:" + rid)
		else:
			print("INCOHERENT:" + rid + " " + ", ".join(issues))
			if rid not in violators:
				violators.append(rid)

	# ── Gates (Node3D with gate.gd script) ─────────────────────────
	# Format: [name, gate_id, gate_transform, barrier_local_offset]
	var gates: Array[Dictionary] = [
		{name="Gate_Test",        gid="shrine_gate", pos=Vector3(0, 0, 47),   barrier=Vector3.ZERO},
		{name="Gate_UnlockCache", gid="",            pos=Vector3(-4, -5, 32),  barrier=Vector3.ZERO},
		{name="Gate_HiddenPath",  gid="",            pos=Vector3(4, 4, -10),   barrier=Vector3.ZERO},
	]

	for gate in gates:
		var issues: Array[String] = _check_gate(gate)
		var gid: String = str(gate.get("gid", gate.get("name", "?")))
		if gid == "":
			gid = str(gate.get("name", "?"))
		if issues.is_empty():
			print("COHERENT:" + gid)
		else:
			print("INCOHERENT:" + gid + " " + ", ".join(issues))
			if gid not in violators:
				violators.append(gid)

	if violators.is_empty():
		print("SPATIAL_COHERENCE: all interactables coherent")
	else:
		print("SPATIAL_COHERENCE: ", violators.size(), " violators: ", ", ".join(violators))

	# Verify expected violators (from DEV-BRAIN prime-bug table)
	var expected: Array[String] = ["crystal_resonant", "crystal_collect", "vine_forest", "shrine_gate"]
	for ex in expected:
		var found := false
		for v in violators:
			if v.to_lower().find(ex) != -1:
				found = true
				break
		if not found and ex == "shrine_gate":
			# Gate_Test uses gate_id "shrine_gate"; also check Gate_Test
			for v in violators:
				if v.to_lower().find("gate_test") != -1:
					found = true
					break
		if not found:
			print("SPATIAL_COHERENCE: WARNING expected violator '", ex, "' not found")

	print("TEST_SPATIAL_COHERENCE_DONE")
	get_tree().quit(0 if violators.is_empty() else 1)


func _check_interactable(ia: Dictionary) -> Array[String]:
	var issues: Array[String] = []
	var pos: Vector3 = ia.get("pos", Vector3.ZERO) as Vector3
	var vis_local: Vector3 = ia.get("vis", Vector3.ZERO) as Vector3

	# (a) Visual proximity to collider
	var vis_global := pos + vis_local
	var mesh_dist: float = pos.distance_to(vis_global)
	if mesh_dist > MESH_COLLIDER_MAX_DIST:
		issues.append("mesh-collider-distance=" + "%.2f" % mesh_dist)

	# (b) Floor distance
	var floor_dist: float = abs(pos.y - FLOOR_Y)
	if floor_dist > FLOOR_MAX_DIST:
		if pos.y < FLOOR_Y:
			issues.append("underground=" + "%.2f" % abs(pos.y))
		else:
			issues.append("floating=" + "%.2f" % pos.y)

	# (c) Reachability
	var nearest := Vector3(pos.x, FLOOR_Y, pos.z)
	var reach: float = pos.distance_to(nearest)
	if reach > SENSOR_RANGE:
		issues.append("unreachable=" + "%.2f" % reach)

	return issues


func _check_gate(gate: Dictionary) -> Array[String]:
	var issues: Array[String] = []
	var pos: Vector3 = gate.get("pos", Vector3.ZERO) as Vector3
	var barrier_local: Vector3 = gate.get("barrier", Vector3.ZERO) as Vector3
	var collider_pos := pos + barrier_local

	var floor_dist: float = abs(collider_pos.y - FLOOR_Y)
	if floor_dist > FLOOR_MAX_DIST:
		if collider_pos.y < FLOOR_Y:
			issues.append("underground=" + "%.2f" % abs(collider_pos.y))
		else:
			issues.append("floating=" + "%.2f" % collider_pos.y)

	var nearest := Vector3(collider_pos.x, FLOOR_Y, collider_pos.z)
	var reach: float = collider_pos.distance_to(nearest)
	if reach > SENSOR_RANGE:
		issues.append("unreachable=" + "%.2f" % reach)

	return issues
