extends PointLight2D

const NIGHT_ON_HOUR = 22
const MORNING_OFF_HOUR = 7


func _ready() -> void:
	G.time.hour_tick.connect(_on_hour_tick)


func _on_hour_tick() -> void:
	if G.time.hour == NIGHT_ON_HOUR:
		enabled = true
	
	if G.time.hour == MORNING_OFF_HOUR:
		enabled = false
