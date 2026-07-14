extends Node3D
class_name VoxelCharacter
## Micro-voxel character builder — human body parts, rigged.
## Micro-voxel = 0.02 units (10x finer than regular 0.2 voxels)

const UV: float = 0.02  # micro-voxel unit
const CHUNK: int = 5    # micro-voxels per body unit

var _parts: Dictionary = {}
var _skeleton: Skeleton3D
var _anim: AnimationPlayer


func _ready() -> void:
	_build_body()
	_rig_body()
	print("VOXEL_CHARACTER_OK")


func _build_body() -> void:
	# Create a humanoid body from micro-voxel cubes
	var skin_mat := _make_mat(Color(0.82, 0.62, 0.45))  # skin tone
	var dark_mat := _make_mat(Color(0.25, 0.2, 0.15))   # hair/shoes
	
	# Head (sphere-like): 8x8x7 micro-voxels = 0.16 x 0.16 x 0.14 units
	_build_part("head", Vector3(0, 1.5, 0), Vector3(8, 7, 8), "sphere", skin_mat)
	
	# Hair cap on top of head
	_build_part("hair", Vector3(0, 1.68, 0), Vector3(9, 3, 9), "sphere", dark_mat)
	
	# Torso: 10x12x6 = 0.2 x 0.24 x 0.12 units
	_build_part("torso", Vector3(0, 1.1, 0), Vector3(10, 12, 6), "box", skin_mat)
	
	# Upper arms (left/right)
	_build_part("upper_arm_l", Vector3(-0.12, 1.35, 0), Vector3(4, 8, 4), "box", skin_mat)
	_build_part("upper_arm_r", Vector3(0.12, 1.35, 0), Vector3(4, 8, 4), "box", skin_mat)
	
	# Lower arms
	_build_part("lower_arm_l", Vector3(-0.12, 1.05, 0), Vector3(3, 8, 3), "box", skin_mat)
	_build_part("lower_arm_r", Vector3(0.12, 1.05, 0), Vector3(3, 8, 3), "box", skin_mat)
	
	# Upper legs
	_build_part("upper_leg_l", Vector3(-0.04, 0.6, 0), Vector3(4, 10, 4), "box", skin_mat)
	_build_part("upper_leg_r", Vector3(0.04, 0.6, 0), Vector3(4, 10, 4), "box", skin_mat)
	
	# Lower legs
	_build_part("lower_leg_l", Vector3(-0.04, 0.22, 0), Vector3(4, 10, 4), "box", skin_mat)
	_build_part("lower_leg_r", Vector3(0.04, 0.22, 0), Vector3(4, 10, 4), "box", skin_mat)
	
	# Shoes
	_build_part("shoe_l", Vector3(-0.04, 0.02, 0.02), Vector3(5, 3, 6), "box", dark_mat)
	_build_part("shoe_r", Vector3(0.04, 0.02, 0.02), Vector3(5, 3, 6), "box", dark_mat)


func _build_part(part_name: String, pos: Vector3, size: Vector3, shape: String, mat: Material) -> void:
	var mmi := MultiMeshInstance3D.new()
	mmi.name = part_name
	mmi.material_override = mat
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.mesh = BoxMesh.new()
	mm.mesh.size = Vector3(UV, UV, UV)
	
	var transforms: Array = []
	var sx: int = int(size.x); var sy: int = int(size.y); var sz: int = int(size.z)
	var cx: float = float(sx) / 2.0; var cy: float = float(sy) / 2.0; var cz: float = float(sz) / 2.0
	
	for x in range(sx):
		for y in range(sy):
			for z in range(sz):
				if shape == "sphere":
					var dx: float = (float(x) - cx + 0.5) / cx
					var dy: float = (float(y) - cy + 0.5) / cy
					var dz: float = (float(z) - cz + 0.5) / cz
					if dx*dx + dy*dy + dz*dz > 1.1: continue
				var t := Transform3D(Basis(), pos + Vector3(float(x-cx)*UV, float(y-cy)*UV, float(z-cz)*UV))
				transforms.append(t)
	
	mm.instance_count = transforms.size()
	for i in range(transforms.size()):
		mm.set_instance_transform(i, transforms[i])
	mmi.multimesh = mm
	add_child(mmi)
	_parts[name] = mmi


func _make_mat(color: Color) -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.8
	return mat


func _rig_body() -> void:
	# Create skeleton
	_skeleton = Skeleton3D.new()
	_skeleton.name = "Skeleton"
	add_child(_skeleton)
	
	# Bone hierarchy
	var bones := {
		"root": -1,
		"spine": 0, "chest": 1, "neck": 2, "head": 3,
		"upper_arm_l": 2, "lower_arm_l": 5, "hand_l": 6,
		"upper_arm_r": 2, "lower_arm_r": 8, "hand_r": 9,
		"upper_leg_l": 0, "lower_leg_l": 11, "foot_l": 12,
		"upper_leg_r": 0, "lower_leg_r": 14, "foot_r": 15,
	}
	
	var positions := {
		0: Vector3(0, 0.9, 0),   # root (hips)
		1: Vector3(0, 1.1, 0),   # spine
		2: Vector3(0, 1.3, 0),   # chest
		3: Vector3(0, 1.5, 0),   # neck
		4: Vector3(0, 1.6, 0),   # head
		5: Vector3(-0.12, 0.0, 0),  # upper_arm_l
		6: Vector3(0, -0.16, 0),    # lower_arm_l
		7: Vector3(0, -0.16, 0),    # hand_l
		8: Vector3(0.12, 0.0, 0),   # upper_arm_r
		9: Vector3(0, -0.16, 0),    # lower_arm_r
		10: Vector3(0, -0.16, 0),   # hand_r
		11: Vector3(-0.04, -0.2, 0),  # upper_leg_l
		12: Vector3(0, -0.2, 0),      # lower_leg_l
		13: Vector3(0, -0.2, 0),      # foot_l
		14: Vector3(0.04, -0.2, 0),   # upper_leg_r
		15: Vector3(0, -0.2, 0),      # lower_leg_r
		16: Vector3(0, -0.2, 0),      # foot_r
	}
	
	for i in range(17):
		_skeleton.add_bone(str(i))
		var parent := -1
		for bn in bones:
			if bones[bn] == i - 1:
				parent = _skeleton.find_bone(str(bones[bn]))
				break
		if parent >= 0:
			_skeleton.set_bone_parent(i, parent)
		var rest := Transform3D(Basis(), positions.get(i, Vector3.ZERO))
		_skeleton.set_bone_rest(i, rest)
		_skeleton.set_bone_pose_position(i, positions.get(i, Vector3.ZERO))
	
	# Animation player
	_anim = AnimationPlayer.new()
	_anim.name = "AnimationPlayer"
	add_child(_anim)
	_build_idle_anim()


func _build_idle_anim() -> void:
	var anim := _anim.get_animation("idle")
	if not anim:
		anim = Animation.new()
		anim.length = 2.0
		anim.loop_mode = Animation.LOOP_LINEAR
		_anim.add_animation("idle", anim)
	
	# Gentle breathing sway on spine
	var t := _anim.get_animation("idle")
	var track := t.add_track(Animation.TYPE_POSITION_3D)
	t.track_set_path(track, "Skeleton:1")  # spine bone
	t.track_insert_key(track, 0.0, Vector3(0, 1.1, 0))
	t.track_insert_key(track, 1.0, Vector3(0, 1.105, 0.02))
	t.track_insert_key(track, 2.0, Vector3(0, 1.1, 0))
	
	# Arm sway
	var arm_track := t.add_track(Animation.TYPE_ROTATION_3D)
	t.track_set_path(arm_track, "Skeleton:5")  # upper_arm_l
	t.track_insert_key(arm_track, 0.0, Vector3(0, 0, 0))
	t.track_insert_key(arm_track, 1.0, Vector3(0.1, 0, 0.05))
	t.track_insert_key(arm_track, 2.0, Vector3(0, 0, 0))
	
	_anim.play("idle")
