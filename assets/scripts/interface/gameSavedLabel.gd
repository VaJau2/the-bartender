extends Panel

@onready var timer: Timer = get_node("timer")
@onready var label: Label = get_node("label")


func _ready() -> void:
	visible = false
	L.game_saved.connect(_on_game_saved)
	G.lang_changed.connect(_update_label)
	_update_label()


func _on_game_saved() -> void:
	visible = true
	timer.start()
	await timer.timeout
	visible = false


func _update_label() -> void:
	label.text = Loc.trans("interface.game_saved")
