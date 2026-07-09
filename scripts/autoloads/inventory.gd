extends Node

signal changed

var _items: Dictionary = {}  # material_id -> int (count)


func add(material_id: String, amount: int = 1) -> void:
	if not _items.has(material_id):
		_items[material_id] = 0
	_items[material_id] += amount
	changed.emit()


func remove(material_id: String, amount: int = 1) -> bool:
	if count(material_id) < amount:
		return false
	_items[material_id] -= amount
	if _items[material_id] <= 0:
		_items.erase(material_id)
	changed.emit()
	return true


func count(material_id: String) -> int:
	return _items.get(material_id, 0)


func has(material_id: String, amount: int = 1) -> bool:
	return count(material_id) >= amount


func get_all() -> Dictionary:
	return _items.duplicate()
