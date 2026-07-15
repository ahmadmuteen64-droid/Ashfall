extends CanvasLayer
## Dev tool — material phase-change simulator.
## Press F3 to toggle. Select a voxel type, drag temperature,
## and see the predicted phase state in real time.

@onready var _panel: Panel = $Panel
@onready var _type_select: OptionButton = $Panel/VBoxContainer/TypeSelect
@onready var _phase_indicator: Label = $Panel/VBoxContainer/PhaseIndicator
@onready var _info_container: VBoxContainer = $Panel/VBoxContainer/InfoContainer
@onready var _temp_slider: HSlider = $Panel/VBoxContainer/TempSlider
@onready var _temp_label: Label = $Panel/VBoxContainer/TempLabel
@onready var _chain_label: Label = $Panel/VBoxContainer/ChainLabel
@onready var _preview_container: SubViewportContainer = $Panel/VBoxContainer/PreviewContainer
@onready var _preview_mesh: MeshInstance3D = $Panel/VBoxContainer/PreviewContainer/SubViewport/PreviewRoot/MeshInstance

var _visible: bool = false
var _engine: VoxelSimEngine = null
var _loaded_types: Array[VoxelType] = []
var _selected_type: VoxelType = null
var _rotation_tween: Tween = null


func _ready() -> void:
	_panel.visible = false
	_engine = VoxelSimEngine.new()
	_engine.name = "VoxelSimEngine"
	add_child(_engine)

	_load_types()
	_temp_slider.value_changed.connect(_on_temp_changed)
	_close_btn().pressed.connect(_toggle)

	if _type_select.item_count > 0:
		_on_type_selected(0)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dev_simulator"):
		_toggle()


func _toggle() -> void:
	_visible = not _visible
	_panel.visible = _visible
	if _visible:
		_update_display()
		_start_rotation()


# ── Loading ────────────────────────────────────────────────

func _load_types() -> void:
	var ids: Array[String] = _engine.get_all_type_ids()
	if ids.is_empty():
		_type_select.add_item("(no voxel types found)")
		return

	for type_id in ids:
		var vt: VoxelType = _engine.load_type(type_id)
		if vt:
			_loaded_types.append(vt)
			_type_select.add_item(vt.display_name + "  [" + vt.id + "]")

	_type_select.item_selected.connect(_on_type_selected)


# ── Signal handlers ────────────────────────────────────────

func _on_type_selected(index: int) -> void:
	if index >= 0 and index < _loaded_types.size():
		_selected_type = _loaded_types[index]
		# Snap temperature to the type's default
		_temp_slider.set_value_no_signal(_selected_type.default_temperature)
		_update_display()


func _on_temp_changed(value: float) -> void:
	_temp_label.text = "Temperature: %.0f °C" % value
	_update_display()


# ── Display refresh ────────────────────────────────────────

func _update_display() -> void:
	if not _selected_type:
		return
	_update_info()
	_update_phase()
	_update_chain()
	_update_preview()


func _update_info() -> void:
	for child in _info_container.get_children():
		child.queue_free()

	var vt := _selected_type

	_add_info_line("ID: %s" % vt.id)
	_add_info_line("Display: %s" % vt.display_name)
	_add_info_line("Natural state: %s" % _engine.get_phase_label(vt.phase_state))
	_add_info_line("Default temp: %.0f °C" % vt.default_temperature)
	_add_info_line("Density: %.1f" % vt.density)
	_add_info_line("Conductivity: %.2f" % vt.thermal_conductivity)

	if vt.melting_point > 0.0:
		_add_info_line("Melting point: %.0f °C → %s" % [vt.melting_point, vt.state_on_melt if not vt.state_on_melt.is_empty() else "(none)"])
	if vt.boiling_point > 0.0:
		_add_info_line("Boiling point: %.0f °C → %s" % [vt.boiling_point, vt.state_on_boil if not vt.state_on_boil.is_empty() else "(none)"])
	if vt.freezing_point > 0.0:
		_add_info_line("Freezing point: %.0f °C → %s" % [vt.freezing_point, vt.state_on_freeze if not vt.state_on_freeze.is_empty() else "(none)"])
	if vt.is_flammable:
		_add_info_line("FLAMMABLE — will catch fire")


func _update_phase() -> void:
	var temp := _temp_slider.value
	var phase := _engine.get_phase_at(_selected_type, temp)
	var label := _engine.get_phase_label(phase)
	var color := _engine.get_phase_color(phase)
	var emoji := ""
	match phase:
		VoxelType.PhaseState.SOLID:
			emoji = "[FROZEN]"
		VoxelType.PhaseState.LIQUID:
			emoji = "[FLUID]"
		VoxelType.PhaseState.GAS:
			emoji = "[VAPOR]"

	_phase_indicator.text = "%s  %s  at %.0f °C" % [emoji, label, temp]
	_phase_indicator.modulate = color


func _update_chain() -> void:
	var chain: Array[Dictionary] = _engine.get_transformation_chain(_selected_type)
	if chain.is_empty():
		_chain_label.text = "(no phase changes configured)"
		return

	var parts: Array[String] = []
	parts.append(_selected_type.display_name)

	for entry in chain:
		var arrow := " —heat→ " if entry.to_phase > entry.from_phase else " —cool→ "
		var target_name: String = entry.target_id
		if not target_name.is_empty():
			var target := _engine.load_type(target_name)
			if target:
				target_name = target.display_name
		parts.append("%s %.0f °C → %s" % [arrow, entry.threshold, target_name])

	_chain_label.text = "  ".join(parts)


func _update_preview() -> void:
	if not _preview_mesh:
		return

	var temp := _temp_slider.value
	var phase := _engine.get_phase_at(_selected_type, temp)

	# Try the selected type's material; fall back to phase-colored material
	var mat: Material = _selected_type.material
	if mat:
		_preview_mesh.material_override = mat.duplicate()
	else:
		var sm := StandardMaterial3D.new()
		sm.albedo_color = _engine.get_phase_color(phase)
		_preview_mesh.material_override = sm


# ── Helpers ────────────────────────────────────────────────

func _add_info_line(text: String) -> void:
	var label := Label.new()
	label.text = "  " + text
	label.add_theme_font_size_override("font_size", 12)
	_info_container.add_child(label)


func _close_btn() -> Button:
	return $Panel/VBoxContainer/CloseButton


func _start_rotation() -> void:
	if _rotation_tween and _rotation_tween.is_running():
		return
	var preview_root := _preview_mesh.get_parent()
	if not preview_root:
		return
	_rotation_tween = create_tween()
	_rotation_tween.set_loops(0)
	_rotation_tween.tween_property(preview_root, "rotation:y", preview_root.rotation.y + TAU, 12.0).from(preview_root.rotation.y)
