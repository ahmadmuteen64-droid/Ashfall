# codex_graph_ui.gd — Simple graph display for Codex knowledge nodes
extends Control

var _codex: Node = null
var _node_labels: Array[Label] = []


func _ready() -> void:
	_codex = get_node_or_null("/root/Codex")
	if _codex:
		_codex.confidence_changed.connect(_on_confidence_changed)
		_codex.node_understood.connect(_on_node_understood)
	_refresh()


func _refresh() -> void:
	_clear_labels()
	if not _codex:
		return

	var discovered: Array = _codex.get_all_discovered()
	var y_offset: float = 10.0

	for id in discovered:
		var level: int = _codex.get_confidence(id)
		var level_name: String = _codex.get_confidence_name(id)
		var ntype: int = _codex.get_node_type(id)

		var label := Label.new()
		label.text = "  " + id + " [" + level_name + "]"
		label.position = Vector2(10, y_offset)
		label.add_theme_color_override("font_color", _color_for_level(level))
		label.add_theme_font_size_override("font_size", 14)
		add_child(label)
		_node_labels.append(label)
		y_offset += 22

	# Show edges
	var edges: Array = _codex.get_all_edges()
	if edges.size() > 0:
		var edge_label := Label.new()
		edge_label.text = "--- " + str(edges.size()) + " connections ---"
		edge_label.position = Vector2(10, y_offset + 10)
		edge_label.add_theme_font_size_override("font_size", 12)
		add_child(edge_label)
		_node_labels.append(edge_label)


func _clear_labels() -> void:
	for lbl in _node_labels:
		if is_instance_valid(lbl):
			lbl.queue_free()
	_node_labels.clear()


func _on_confidence_changed(id: String, _old: int, _new: int) -> void:
	_refresh()


func _on_node_understood(id: String) -> void:
	_refresh()


func _color_for_level(level: int) -> Color:
	match level:
		1: return Color(0.5, 0.5, 0.5)   # GLIMPSED — grey
		2: return Color(0.3, 0.5, 0.8)   # PARTIAL — blue
		3: return Color(0.3, 0.7, 0.3)   # WORKING — green
		4: return Color(0.9, 0.7, 0.1)   # VERIFIED — gold
		5: return Color(0.9, 0.3, 0.9)   # MASTERY — purple
	return Color(0.6, 0.6, 0.6)  # default grey
