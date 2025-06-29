extends PointLight2D

const NIGHT_HALF_ON_HOUR = 21
const NIGHT_ON_HOUR = 22
const MORNING_OFF_HOUR = 5


func _ready() -> void:
	G.time.hour_tick.connect(_on_hour_tick)
	_set_start_light()


func _on_hour_tick() -> void:
	if G.time.hour == NIGHT_HALF_ON_HOUR:
		enabled = true
		energy = 0.5
	
	if G.time.hour == NIGHT_ON_HOUR:
		enabled = true
		energy = 1
	
	if G.time.hour == MORNING_OFF_HOUR:
		enabled = false


func _set_start_light() -> void:
	if G.time.hour >= NIGHT_ON_HOUR or G.time.hour < MORNING_OFF_HOUR:
		enabled = true
