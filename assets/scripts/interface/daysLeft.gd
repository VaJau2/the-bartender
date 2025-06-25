extends Label


func _ready() -> void:
	G.time.day_tick.connect(_on_day_tick)
	_on_day_tick()


func _on_day_tick() -> void:
	text = str(G.DAYS_GOAL - G.time.day)
