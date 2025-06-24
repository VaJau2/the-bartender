extends DirectionalLight2D

@export var lights_data: Array[TimeLightData]

var temp_color: Color
var temp_speed: float


func _ready() -> void:
	G.time.hour_tick.connect(_on_hour_tick)
	_set_start_light()


func _process(delta: float) -> void:
	if color != temp_color:
		color.r = move_toward(color.r, temp_color.r, temp_speed * delta)
		color.g = move_toward(color.g, temp_color.g, temp_speed * delta)
		color.b = move_toward(color.b, temp_color.b, temp_speed * delta)
		color.a = move_toward(color.a, temp_color.a, temp_speed * delta)


func _on_hour_tick() -> void:
	for light_item in lights_data:
		if light_item.hour == G.time.hour:
			temp_color = light_item.color
			temp_speed = light_item.speed
			return


func _set_start_light() -> void:
	var temp_start_light: TimeLightData = null
	
	for light_item in lights_data:
		if light_item.hour <= G.time.hour:
			temp_start_light = light_item
		if light_item.hour > G.time.hour:
			break
	
	if temp_start_light:
		color = temp_start_light.color
