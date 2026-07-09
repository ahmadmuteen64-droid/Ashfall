# Aperture — Modular Kit Standards

*The build spec for every kit piece. All pieces must conform to this document.*

---

## Grid Unit

**2 meters.** Every kit piece snaps to a 2m×2m grid in XZ. Height (Y) is free within the piece but piece-to-piece vertical seams align to 2m increments.

## Pivot Convention

**Bottom-center.** Pivot at Y=0 (floor level), centered in XZ on the grid cell(s) the piece occupies. This ensures pieces snap correctly when placed at integer grid coordinates.

## Naming Convention

`kit_<category>_<descriptor>[_variant]`

| Prefix | Category |
|--------|----------|
| `kit_ground_` | Walkable floor/ground tiles |
| `kit_wall_` | Vertical barriers, cliffs, walls |
| `kit_ramp_` | Sloped traversal surfaces |
| `kit_platform_` | Elevated walkable surfaces |
| `kit_path_` | Path segments (straight, corner, T) |
| `kit_step_` | Small elevation changes (0.5-1m) |
| `kit_edge_` | Cap pieces for exposed edges |
| `kit_barrier_` | Gates, doors, conditional blockers |

Examples: `kit_ground_2x2`, `kit_wall_cliff_4m`, `kit_ramp_20deg`, `kit_path_straight`, `kit_path_corner`, `kit_step_1m`, `kit_edge_cap`

## Material

All kit pieces share one material: `res://kit/kit_grey.tres` — a neutral grey StandardMaterial3D. Pieces are distinguishable by silhouette, not color. Color/texture comes in later dressing phases.

## Mesh + Collision

Every kit piece must contain:
- A **MeshInstance3D** (or CSG equivalent for blockout) for visuals
- A **StaticBody3D** child with **CollisionShape3D** for physics

Both must be grid-aligned. No gaps between adjacent pieces.

## Grid Alignment Rule

When a piece occupies N×M grid cells, its XZ bounds must be exactly (N×2m)×(M×2m), centered on the pivot. Adjacent pieces of the same category must produce a seamless surface with zero visible gap or z-fighting.
