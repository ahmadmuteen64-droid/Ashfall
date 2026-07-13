extends CanvasLayer
## Combine station UI — material selection + condition toggles + run.
## Conditions are read from the activating station node's metadata,
## making them a per-station game mechanic rather than a hardcoded constant.

@onready var _panel: Panel = $Panel
var _engine: Node = null
var _selected: Array[String] = []
var _active_conditions: Dictionary = {}   ## condition_name → bool
var _station_node: Node = null            ## which station activated us
var _visible: bool = false


func _ready() -> void:
	_panel.visible = false
	_engine = ExperimentEngine.new()
	_engine.name = "ExperimentEngine"
	add_child(_engine)


func open(station_node: Node = null) -> void:
	_visible = true
	_panel.visible = true
	_selected.clear()
	_active_conditions.clear()
	_station_node = station_node

	# Read available conditions from the station's metadata.
	# Stations define which conditions they can provide via:
	#   set_meta("station_conditions", ["heat", "pressure"])
	if _station_node and _station_node.has_meta("station_conditions"):
		var available: Array = _station_node.get_meta("station_conditions")
		for cond in available:
			_active_conditions[str(cond)] = false

	_refresh()


func close() -> void:
	_visible = false
	_panel.visible = false


func _input(event: InputEvent) -> void:
	if _visible and event.is_action_pressed("journal"):
		close()


func _refresh() -> void:
	var list: VBoxContainer = $Panel/VBoxContainer
	for child in list.get_children():
		child.queue_free()

	# ── Materials section ──────────────────────────────────────
	var mat_label := Label.new()
	mat_label.text = "— Materials —"
	list.add_child(mat_label)

	var inv := get_node_or_null("/root/Inventory")
	if inv:
		var items: Dictionary = inv.get_all()
		if items.is_empty():
			var empty := Label.new()
			empty.text = "(inventory empty)"
			list.add_child(empty)
		for id in items:
			var btn := Button.new()
			var mark := " [SELECTED]" if id in _selected else ""
			btn.text = "%s (×%d)%s" % [id, items[id], mark]
			btn.pressed.connect(_on_select.bind(id))
			list.add_child(btn)

	# ── Conditions section ─────────────────────────────────────
	var spacer1 := HSeparator.new()
	list.add_child(spacer1)

	var cond_label := Label.new()
	cond_label.text = "— Conditions —"
	list.add_child(cond_label)

	if _active_conditions.is_empty():
		var none := Label.new()
		none.text = "(no conditions available at this station)"
		list.add_child(none)
	else:
		for cond in _active_conditions:
			var btn := Button.new()
			var state := "ON" if _active_conditions[cond] else "OFF"
			btn.text = "%s: %s" % [cond.capitalize(), state]
			btn.pressed.connect(_on_toggle_condition.bind(cond))
			list.add_child(btn)

	# ── Actions ────────────────────────────────────────────────
	var spacer2 := HSeparator.new()
	list.add_child(spacer2)

	var run_btn := Button.new()
	run_btn.text = "RUN EXPERIMENT"
	run_btn.pressed.connect(_on_run)
	list.add_child(run_btn)

	var close_btn := Button.new()
	close_btn.text = "CLOSE"
	close_btn.pressed.connect(close)
	list.add_child(close_btn)


func _on_select(id: String) -> void:
	if id in _selected:
		_selected.erase(id)
	else:
		_selected.append(id)
	_refresh()


func _on_toggle_condition(cond: String) -> void:
	_active_conditions[cond] = not _active_conditions[cond]
	_refresh()


func _on_run() -> void:
	if _selected.is_empty():
		var label := Label.new()
		label.text = "Select at least one material."
		$Panel/VBoxContainer.add_child(label)
		return

	# Build the conditions dict — only pass conditions the player toggled ON
	var cond_dict: Dictionary = {}
	for cond in _active_conditions:
		if _active_conditions[cond]:
			cond_dict[cond] = "available"

	var result: Dictionary = _engine.run(_selected.duplicate(), cond_dict)

	var result_label := Label.new()
	if result.success:
		result_label.text = "DISCOVER: " + result.discovered
		var codex := get_node_or_null("/root/Codex")
		if codex and result.discovered != "":
			codex.discover(result.discovered)
		for bp in result.byproducts:
			var inv2 := get_node_or_null("/root/Inventory")
			if inv2:
				inv2.add(bp)
	else:
		result_label.text = result.message
	$Panel/VBoxContainer.add_child(result_label)
