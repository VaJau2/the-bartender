extends Camera2D

@export var change_speed: float = 2.0
@export var min_zoom: float = 1.25
@export var max_zoom: float = 3.25

var temp_zoom: float
var target_zoom: float


func _ready() -> void:
	temp_zoom = zoom.x
	target_zoom = zoom.x


func _process(delta: float) -> void:
	update_temp_zoom(delta)
	update_target_zoom()


func update_temp_zoom(delta: float) -> void:
	if abs(temp_zoom - target_zoom) > 0.01:
		temp_zoom = lerp(temp_zoom, target_zoom, change_speed * delta)
		zoom = Vector2(temp_zoom, temp_zoom)


func update_target_zoom() -> void:
	if Input.is_action_just_pressed("ui_scroll_up"):
		target_zoom += 0.1
	elif Input.is_action_just_pressed("ui_scroll_down"):
		target_zoom -= 0.1
	
	target_zoom = clamp(target_zoom, min_zoom, max_zoom)
