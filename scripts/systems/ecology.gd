# ecology.gd — W3: Harvest, regen, succession
extends Node

var _harvested: Dictionary = {}   # species_id → cycles_until_regen
var _population: Dictionary = {}  # species_id → int (current count)
var _dependents: Dictionary = {} # species_id → Array[String] (species that depend on it)

const REGEN_CYCLES: int = 5  # day cycles to regrow
const MAX_POPULATION: int = 10


func _ready() -> void:
	_init_populations()


func _init_populations() -> void:
	# Load all material defs as species
	var dir := DirAccess.open("res://data/materials/")
	if not dir:
		return
	dir.list_dir_begin()
	var fn := dir.get_next()
	while fn != "":
		if fn.ends_with(".tres"):
			var mid := fn.replace(".tres", "")
			_population[mid] = MAX_POPULATION
		fn = dir.get_next()


func _process(_delta: float) -> void:
	var tm := get_node_or_null("/root/TimeManager")
	if not tm:
		return
	# Regenerate each day cycle
	var phase: String = tm.get_phase()
	if phase == "dawn":
		for species in _harvested:
			_harvested[species] -= 1
			if _harvested[species] <= 0:
				_harvested.erase(species)
				_population[species] = mini(_population.get(species, 0) + 3, MAX_POPULATION)
				print("ECOLOGY_REGEN:" + species)


func harvest(species_id: String, amount: int = 1) -> bool:
	var current: int = _population.get(species_id, 0)
	if current < amount:
		return false
	_population[species_id] = current - amount
	if not _harvested.has(species_id):
		_harvested[species_id] = REGEN_CYCLES

	# Over-harvest: dependents decline
	var deps: Array = _dependents.get(species_id, [])
	for dep in deps:
		_population[dep] = max(0, _population.get(dep, 0) - 1)
		print("ECOLOGY_DECLINE:" + dep + " (" + species_id + " over-harvested)")

	return true


func get_population(species_id: String) -> int:
	return _population.get(species_id, 0)


func register_dependency(species_id: String, dependent_id: String) -> void:
	if not _dependents.has(species_id):
		_dependents[species_id] = []
	_dependents[species_id].append(dependent_id)
