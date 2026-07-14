extends Node
## VoxelConfig — global singleton holding pixel-perfect rendering constants.
##
## Standing Rule: Everything in the game world is Voxels per pixel size.
## One voxel = one world unit = one screen pixel at the target internal resolution.
##
## This autoload is the single source of truth. All world geometry, the camera,
## and the display settings derive their pixel-perfect parameters from here.

# ── Target internal resolution ─────────────────────────────────────
const VIEWPORT_WIDTH: int = 640
const VIEWPORT_HEIGHT: int = 360

# ── Voxel constants ─────────────────────────────────────────────────
const VOXEL_SIZE: float = 1.0
const HALF_VOXEL: float = 0.5
const PLAYER_VOXEL_HEIGHT: int = 16
const PLAYER_VOXEL_RADIUS: int = 6

# ── Camera constants ────────────────────────────────────────────────
const ORTHO_SIZE: float = float(VIEWPORT_HEIGHT) / 2.0
const DEFAULT_CAMERA_PITCH: float = -45.0
const DEFAULT_CAMERA_DISTANCE: float = 40.0
const CAMERA_ZOOM_MIN: float = 10.0
const CAMERA_ZOOM_MAX: float = 80.0


func _ready() -> void:
	print("VOXEL_CONFIG_OK  res:%dx%d  voxel:%.1f  ortho_size:%.0f" % [
		VIEWPORT_WIDTH, VIEWPORT_HEIGHT, VOXEL_SIZE, ORTHO_SIZE
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
