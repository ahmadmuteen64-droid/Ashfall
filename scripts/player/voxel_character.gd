extends Node3D
class_name VoxelCharacter
## Micro-voxel humanoid — properly rigged with BoneAttachment3D.
## UV = 0.02 units per micro-voxel (10x finer than regular 0.2 voxels)

const UV: float = 0.02

var _skeleton: Skeleton3D
var _anim: AnimationPlayer


func _ready() -> void:
	_build_skeleton()
	_build_body()
	_build_animations()
	print("VOXEL_CHARACTER_OK")


func _build_skeleton() -> void:
	_skeleton = Skeleton3D.new()
	_skeleton.name = "Skeleton"
	add_child(_skeleton)
	
	# Bone chain: root(0)->spine(1)->chest(2)->neck(3)->head(4)
	# Arms branch from chest(2): upper_arm(5)->lower_arm(6)
	# Legs branch from root(0): upper_leg(7)->lower_leg(8)->foot(9)
	# Mirror for right side
	var rest_pos := [
		Vector3(0, 0.85, 0),   # 0: root (hips)
		Vector3(0, 0.20, 0),   # 1: spine
		Vector3(0, 0.20, 0),   # 2: chest
		Vector3(0, 0.14, 0),   # 3: neck
		Vector3(0, 0.12, 0),   # 4: head
		Vector3(-0.12, 0.05, 0),  # 5: upper_arm_l
		Vector3(0, -0.18, 0),     # 6: lower_arm_l
		Vector3(0.12, 0.05, 0),   # 7: upper_arm_r
		Vector3(0, -0.18, 0),     # 8: lower_arm_r
		Vector3(-0.05, -0.22, 0), # 9: upper_leg_l
		Vector3(0, -0.22, 0),     # 10: lower_leg_l
		Vector3(0, -0.06, 0.03),  # 11: foot_l
		Vector3(0.05, -0.22, 0),  # 12: upper_leg_r
		Vector3(0, -0.22, 0),     # 13: lower_leg_r
		Vector3(0, -0.06, 0.03),  # 14: foot_r
	]
	var parents := [-1, 0, 1, 2, 3, 2, 5, 2, 7, 0, 9, 10, 0, 12, 13]
	
	for i in range(15):
		_skeleton.add_bone(str(i))
		if parents[i] >= 0:
			_skeleton.set_bone_parent(i, parents[i])
		_skeleton.set_bone_rest(i, Transform3D(Basis(), rest_pos[i]))
		_skeleton.set_bone_pose_position(i, rest_pos[i])


func _build_body() -> void:
	var skin := _make_mat(Color(0.82, 0.62, 0.45))
	var dark := _make_mat(Color(0.22, 0.18, 0.12))
	var shirt := _make_mat(Color(0.15, 0.25, 0.35))
	var pants := _make_mat(Color(0.25, 0.22, 0.18))
	
	# Head (bone 4)
	_attach_voxels("head", 4, Vector3(0, -0.04, 0), Vector3(5, 5, 5), "sphere", skin)
	# Hair
	_attach_voxels("hair", 4, Vector3(0, 0.06, 0), Vector3(6, 3, 6), "sphere", dark)
	
	# Torso (bone 2 - chest)
	_attach_voxels("torso", 2, Vector3(0, -0.02, 0), Vector3(8, 10, 5), "box", shirt)
	_attach_voxels("waist", 1, Vector3(0, 0, 0), Vector3(7, 7, 4), "box", pants)
	
	# Upper arms (bone 5/7)
	_attach_voxels("up_arm_l", 5, Vector3(0, -0.06, 0), Vector3(3, 7, 3), "box", skin)
	_attach_voxels("up_arm_r", 7, Vector3(0, -0.06, 0), Vector3(3, 7, 3), "box", skin)
	
	# Lower arms (bone 6/8)
	_attach_voxels("lo_arm_l", 6, Vector3(0, -0.06, 0), Vector3(3, 7, 3), "box", skin)
	_attach_voxels("lo_arm_r", 8, Vector3(0, -0.06, 0), Vector3(3, 7, 3), "box", skin)
	
	# Upper legs (bone 9/12)
	_attach_voxels("up_leg_l", 9, Vector3(0, -0.08, 0), Vector3(4, 9, 4), "box", pants)
	_attach_voxels("up_leg_r", 12, Vector3(0, -0.08, 0), Vector3(4, 9, 4), "box", pants)
	
	# Lower legs (bone 10/13)
	_attach_voxels("lo_leg_l", 10, Vector3(0, -0.08, 0), Vector3(4, 9, 4), "box", pants)
	_attach_voxels("lo_leg_r", 13, Vector3(0, -0.08, 0), Vector3(4, 9, 4), "box", pants)
	
	# Feet (bone 11/14)
	_attach_voxels("foot_l", 11, Vector3(0, 0, 0.04), Vector3(4, 3, 6), "box", dark)
	_attach_voxels("foot_r", 14, Vector3(0, 0, 0.04), Vector3(4, 3, 6), "box", dark)


func _attach_voxels(p_name: String, bone_idx: int, offset: Vector3, size: Vector3, shape: String, mat: Material) -> void:
	var bone_name := str(bone_idx)
	var att := BoneAttachment3D.new()
	att.name = "Att_" + p_name
	att.bone_name = bone_name
	att.position = offset
	_skeleton.add_child(att)
	
	var mmi := MultiMeshInstance3D.new()
	mmi.name = p_name
	mmi.material_override = mat
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.mesh = BoxMesh.new()
	mm.mesh.size = Vector3(UV, UV, UV)
	
	var transforms: Array = []
	var sx: int = int(size.x); var sy: int = int(size.y); var sz: int = int(size.z)
	var hx: float = float(sx) / 2.0; var hy: float = float(sy) / 2.0; var hz: float = float(sz) / 2.0
	
	for x in range(sx):
		for y in range(sy):
			for z in range(sz):
				var add := true
				if shape == "sphere":
					var dx: float = (float(x) - hx + 0.5) / hx
					var dy: float = (float(y) - hy + 0.5) / hy
					var dz: float = (float(z) - hz + 0.5) / hz
					if dx*dx + dy*dy + dz*dz > 1.1:
						add = false
				if add:
					transforms.append(Transform3D(Basis(), Vector3(float(x-hx)*UV, float(y-hy)*UV, float(z-hz)*UV)))
	
	mm.instance_count = transforms.size()
	for i in range(transforms.size()):
		mm.set_instance_transform(i, transforms[i])
	mmi.multimesh = mm
	att.add_child(mmi)


func _build_animations() -> void:
	_anim = AnimationPlayer.new()
	_anim.name = "AnimationPlayer"
	add_child(_anim)
	
	# Idle: gentle breathing + subtle arm sway
	var idle := Animation.new()
	idle.length = 2.0
	idle.loop_mode = Animation.LOOP_LINEAR
	
	_anim_key_pos(idle, 1, 0.0, Vector3(0, 0.20, 0))
	_anim_key_pos(idle, 1, 1.0, Vector3(0, 0.205, 0.01))
	_anim_key_pos(idle, 1, 2.0, Vector3(0, 0.20, 0))
	_anim_key_rot(idle, 5, 0.0, Vector3.ZERO)  # upper_arm_l
	_anim_key_rot(idle, 5, 1.0, Vector3(0.08, 0, 0.03))
	_anim_key_rot(idle, 5, 2.0, Vector3.ZERO)
	_anim_key_rot(idle, 7, 0.0, Vector3.ZERO)  # upper_arm_r
	_anim_key_rot(idle, 7, 1.0, Vector3(-0.08, 0, -0.03))
	_anim_key_rot(idle, 7, 2.0, Vector3.ZERO)
	_anim.add_animation("idle", idle)
	
	# Walk: legs + arms swing
	var walk := Animation.new()
	walk.length = 1.0
	walk.loop_mode = Animation.LOOP_LINEAR
	
	_anim_key_rot(walk, 9, 0.0, Vector3(0.5, 0, 0))    # upper_leg_l forward
	_anim_key_rot(walk, 9, 0.5, Vector3(-0.5, 0, 0))   # upper_leg_l back
	_anim_key_rot(walk, 9, 1.0, Vector3(0.5, 0, 0))
	_anim_key_rot(walk, 12, 0.0, Vector3(-0.5, 0, 0))  # upper_leg_r back
	_anim_key_rot(walk, 12, 0.5, Vector3(0.5, 0, 0))   # upper_leg_r forward
	_anim_key_rot(walk, 12, 1.0, Vector3(-0.5, 0, 0))
	
	_anim_key_rot(walk, 5, 0.0, Vector3(-0.4, 0, 0))   # upper_arm_l back
	_anim_key_rot(walk, 5, 0.5, Vector3(0.4, 0, 0))    # upper_arm_l forward
	_anim_key_rot(walk, 5, 1.0, Vector3(-0.4, 0, 0))
	_anim_key_rot(walk, 7, 0.0, Vector3(0.4, 0, 0))    # upper_arm_r forward
	_anim_key_rot(walk, 7, 0.5, Vector3(-0.4, 0, 0))   # upper_arm_r back
	_anim_key_rot(walk, 7, 1.0, Vector3(0.4, 0, 0))
	
	_anim_key_pos(walk, 0, 0.0, Vector3(0, 0.85, 0))    # root bob
	_anim_key_pos(walk, 0, 0.25, Vector3(0, 0.82, 0))
	_anim_key_pos(walk, 0, 0.5, Vector3(0, 0.85, 0))
	_anim_key_pos(walk, 0, 0.75, Vector3(0, 0.82, 0))
	_anim_key_pos(walk, 0, 1.0, Vector3(0, 0.85, 0))
	_anim.add_animation("walk", walk)
	
	_anim.play("idle")


func _anim_key_pos(anim: Animation, bone: int, time: float, pos: Vector3) -> void:
	var idx := anim.find_track("Skeleton:" + str(bone), Animation.TYPE_POSITION_3D)
	if idx < 0:
		idx = anim.add_track(Animation.TYPE_POSITION_3D)
		anim.track_set_path(idx, "Skeleton:" + str(bone))
	anim.track_insert_key(idx, time, pos)


func _anim_key_rot(anim: Animation, bone: int, time: float, rot: Vector3) -> void:
	var idx := anim.find_track("Skeleton:" + str(bone), Animation.TYPE_ROTATION_3D)
	if idx < 0:
		idx = anim.add_track(Animation.TYPE_ROTATION_3D)
		anim.track_set_path(idx, "Skeleton:" + str(bone))
	anim.track_insert_key(idx, time, rot)


func _make_mat(color: Color) -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.75
	return mat


func play_walk() -> void:
	if _anim and _anim.has_animation("walk"):
		_anim.play("walk", 0.2)


func play_idle() -> void:
	if _anim and _anim.has_animation("idle"):
		_anim.play("idle", 0.2)
