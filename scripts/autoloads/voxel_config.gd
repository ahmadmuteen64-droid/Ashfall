extends Node
## VoxelConfig — global pixel-perfect rendering constants.
## Standing Rule: 1 sub-voxel = 1 pixel. External sub-voxel detail.

const VIEWPORT_WIDTH: int = 640
const VIEWPORT_HEIGHT: int = 360

# Voxel: the visible cube. Sub-voxel: internal division for destruction detail.
const VOXEL_SIZE: float = 0.2
const SUB_VOXELS_PER_AXIS: int = 100
const SUB_VOXEL_SIZE: float = VOXEL_SIZE / float(SUB_VOXELS_PER_AXIS)
const SUB_VOXEL_HEALTH: int = SUB_VOXELS_PER_AXIS
const HALF_VOXEL: float = VOXEL_SIZE / 2.0

const ORTHO_SIZE: float = float(VIEWPORT_HEIGHT) / 2.0
const DEFAULT_CAMERA_PITCH: float = -45.0
const DEFAULT_CAMERA_DISTANCE: float = 12.0


func _ready() -> void:
	print("VOXEL_CONFIG_OK  res:%dx%d  voxel:%.2f  sub_voxel:%.4f  ortho_size:%.0f" % [
		VIEWPORT_WIDTH, VIEWPORT_HEIGHT, VOXEL_SIZE, SUB_VOXEL_SIZE, ORTHO_SIZE
	])


static func ortho_size_for_zoom(zoom: float) -> float:
	return ORTHO_SIZE / zoom


static func px_to_units(px: int) -> float:
	return float(px) * VOXEL_SIZE


static func units_to_px(units: float) -> int:
	return int(units / VOXEL_SIZE)


static func snap_to_grid(pos: Vector3, grid_size: float = VOXEL_SIZE) -> Vector3:
	return Vector3(
		round(pos.x / grid_size) * grid_size,
		round(pos.y / grid_size) * grid_size,
		round(pos.z / grid_size) * grid_size
	)
