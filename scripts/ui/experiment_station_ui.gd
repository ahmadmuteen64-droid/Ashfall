extends CanvasLayer

@onready var _panel: Panel = $Panel
var _engine: Node = null
var _selected: Array[String] = []
var _visible: bool = false


func _ready() -> void:
	_panel.visible = false
	_engine = ExperimentEngine.new()
	_engine.name = "ExperimentEngine"
	add_child(_engine)


func open() -> void:
	_visible = true
	_panel.visible = true
	_selected.clear()
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

	var inv := get_node_or_null("/root/Inventory")
	if not inv:
		return
	var items: Dictionary = inv.get_all()
	for id in items:
		var btn := Button.new()
		btn.text = "%s (×%d) %s" % [id, items[id], "[SELECTED]" if id in _selected else ""]
		btn.pressed.connect(_on_select.bind(id))
		list.add_child(btn)

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


func _on_run() -> void:
	if _selected.is_empty():
		return
	var result: Dictionary = _engine.run(_selected.duplicate(), {})
	var result_label := Label.new()
	if result.success:
		result_label.text = "DISCOVER:" + result.discovered
		var codex := get_node_or_null("/root/Codex")
		if codex and result.discovered != "":
			codex.discover(result.discovered)
		for bp in result.byproducts:
			var inv := get_node_or_null("/root/Inventory")
			if inv:
				inv.add(bp)
	else:
		result_label.text = result.message
	$Panel/VBoxContainer.add_child(result_label)
