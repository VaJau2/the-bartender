extends Label

func _ready() -> void:
	G.lang_changed.connect(_on_day_tick)
	G.time.day_tick.connect(_on_day_tick)
	_on_day_tick()


func _on_day_tick() -> void:
	text = Loc.trans("interface.money.days_left") + " " + str(G.DAYS_GOAL - G.time.day)
