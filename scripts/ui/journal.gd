extends CanvasLayer

@onready var _panel: Panel = $Panel
@onready var _list: VBoxContainer = $Panel/VBoxContainer
@onready var _visible: bool = false


func _ready() -> void:
	_panel.visible = false
	var codex := get_node_or_null("/root/Codex")
	if codex:
		if codex.has_signal("observed"):
			codex.observed.connect(_on_observed)
		if codex.has_signal("pattern_ready"):
			codex.pattern_ready.connect(_on_pattern_ready)
		if codex.has_signal("node_understood"):
			codex.node_understood.connect(_on_understood)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("journal"):
		_visible = not _visible
		_panel.visible = _visible
		if _visible:
			_refresh()


func _on_observed(_id: String) -> void:
	if _visible:
		_refresh()


func _on_understood(_id: String) -> void:
	if _visible:
		_refresh()


func _on_pattern_ready(type_key: String) -> void:
	var label := Label.new()
	label.text = "Noticing a pattern in: " + type_key
	_list.add_child(label)


func _refresh() -> void:
	for child in _list.get_children():
		child.queue_free()

	var codex := get_node_or_null("/root/Codex")
	if not codex:
		return

	var heading := Label.new()
	heading.text = "== Knowledge =="
	_list.add_child(heading)

	if codex.has_method("get_all_nodes"):
		var all_nodes: Array = codex.get_all_nodes()
		for kn in all_nodes:
			var nid: String = kn.get("node_id")
			var dname: String = kn.get("display_name")
			var summary: String = kn.get("summary")
			var conf: int = kn.get("confidence")
			if codex.knows(nid):
				var prefix: String = "?"
				var col: Color = Color.GRAY
				if conf == 1:
					prefix = "~"
					col = Color.YELLOW
				elif conf == 2:
					prefix = "!"
					col = Color.GREEN
				var label := Label.new()
				label.text = "%s %s: %s" % [prefix, dname, summary]
				label.modulate = col
				_list.add_child(label)

	var obs_heading := Label.new()
	obs_heading.text = "== Observations =="
	_list.add_child(obs_heading)

	for obs_id in codex.observations:
		var label := Label.new()
		label.text = "%s (x%d)" % [obs_id, codex.observations[obs_id]]
		_list.add_child(label)
