extends PointLight2D

const NIGHT_HALF_ON_HOUR = 21
const NIGHT_ON_HOUR = 22
const MORNING_OFF_HOUR = 5


func _ready() -> void:
	G.time.hour_tick.connect(_on_hour_tick)
	_on_hour_tick()


func _on_hour_tick() -> void:
	if G.time.hour >= NIGHT_HALF_ON_HOUR or G.time.hour < MORNING_OFF_HOUR:
		enabled = true
		if G.time.hour >= NIGHT_ON_HOUR:
			energy = 1
		else:
			energy = 0.5
	else:
		enabled = false
