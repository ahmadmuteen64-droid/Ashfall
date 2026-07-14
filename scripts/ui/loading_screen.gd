extends CanvasLayer
## Portal loading screen with British humor jokes

var _jokes: Array[String] = [
	"Calibrating the ley lines... they're on strike again.",
	"Polishing the portal crystals. Union requires tea breaks.",
	"Negotiating with the void. It wants better hours.",
	"Right, the pixies are on lunch. Give it a tick.",
	"Loading. It's not rubbish, it's 'character building'.",
	"The gnomes have misplaced the biome key. Again.",
	"One moment — goblin resources are fully booked.",
	"Charging the portal via a very long extension lead.",
	"Brewing fresh tea for the dimension hoppers.",
	"Apologies — the wizard's commute is absolutely dreadful.",
	"Recalibrating because Dave sneezed on the controls.",
	"The runes need re-inking. Fountain pen only, I'm afraid.",
	"Portal's having a bit of a wobble. Classic Monday.",
	"Just waiting on a spell approval from the council.",
	"Biome transfer delayed by 47 minutes. Very sorry.",
	"Doing the needful. Also the biscuits.",
	"The portal's Wi-Fi is dreadful. Using carrier pigeon.",
	"Banging the crystals together until something sparks.",
	"Portal technician is having a cuppa. Won't be long.",
	"Dimensional customs are checking your luggage.",
	"A goblin unplugged the portal to charge his phone.",
	"Sending a strongly worded raven. No ETA.",
	"The magic smoke has escaped. Re-capturing it now.",
	"Inspecting each voxel personally. Painfully British about it.",
]
var _joke_idx: int = 0
var _joke_timer: float = 0.0

@onready var _panel: Panel = $Panel
@onready var _joke_label: Label = $Panel/VBox/JokeLabel
@onready var _progress: ProgressBar = $Panel/VBox/Progress
@onready var _spinner: Label = $Panel/VBox/Spinner


func _ready() -> void:
	_panel.visible = false
	set_process(false)


func show_loading() -> void:
	_panel.visible = true
	_joke_idx = randi() % _jokes.size()
	_joke_label.text = _jokes[_joke_idx]
	_joke_timer = 0.0
	_progress.value = 0
	set_process(true)


func hide_loading() -> void:
	_panel.visible = false
	set_process(false)


func _process(delta: float) -> void:
	_joke_timer += delta
	if _joke_timer > 3.0:
		_joke_timer = 0.0
		_joke_idx = (_joke_idx + 1) % _jokes.size()
		_joke_label.text = _jokes[_joke_idx]
	var frames := ["|", "/", "-", "\\"]
	var fi: int = int(Time.get_ticks_msec() / 200) % 4
	_spinner.text = frames[fi] + " " + frames[fi] + " " + frames[fi]


func set_progress(ratio: float) -> void:
	_progress.value = ratio * 100
