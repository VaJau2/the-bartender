extends AudioStreamPlayer2D

const CHANGE_SPEED: float = 0.1

@export var hour_on: int
@export var hour_off: int

var is_on: bool


func _ready() -> void:
	G.time.hour_tick.connect(_on_hour_tick)
	_set_start_volume()
	set_process(false)


func _process(delta: float) -> void:
	if is_on:
		if volume_linear == 0:
			play()
		
		if volume_linear < 1:
			volume_linear += CHANGE_SPEED * delta
		else:
			set_process(false)
	else:
		if volume_linear > 0.1:
			volume_linear -= CHANGE_SPEED * delta
		else:
			stop()
			volume_linear = 0
			set_process(false)


func _on_hour_tick() -> void:
	if G.time.hour == hour_on:
		is_on = true
		set_process(true)
	
	if G.time.hour == hour_off:
		is_on = false
		set_process(true)


func _set_start_volume() -> void:
	if hour_on < hour_off:
		if G.time.hour < hour_on or G.time.hour >= hour_off:
			volume_linear = 0
			stop()
	else:
		if G.time.hour < hour_on and G.time.hour >= hour_off:
			volume_linear = 0
			stop()


func get_save_data() -> Dictionary:
	return {
		"is_on": var_to_str(is_on),
		"volume": var_to_str(volume_linear)
	}


func load_save_data(data: Dictionary) -> void:
	is_on = str_to_var(data.is_on)
	volume_linear = str_to_var(data.volume)
	if volume_linear > 0: play()
	if is_on: set_process(true)
