extends CanvasLayer

@onready var _panel: Panel = $Panel
@onready var _list: VBoxContainer = $Panel/VBoxContainer


func _ready() -> void:
	_panel.visible = false
	var inv := get_node_or_null("/root/Inventory")
	if inv and inv.has_signal("changed"):
		inv.changed.connect(_refresh)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("journal"):
		_panel.visible = not _panel.visible
		if _panel.visible:
			_refresh()


func _refresh() -> void:
	for child in _list.get_children():
		child.queue_free()
	var inv := get_node_or_null("/root/Inventory")
	if not inv:
		return
	var items: Dictionary = inv.get_all()
	if items.is_empty():
		var label := Label.new()
		label.text = "(empty)"
		_list.add_child(label)
	else:
		for id in items:
			var label := Label.new()
			label.text = "%s (×%d)" % [id, items[id]]
			_list.add_child(label)
