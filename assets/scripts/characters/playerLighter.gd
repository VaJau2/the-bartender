extends PointLight2D

const NIGHT_ON_HOUR = 22
const MORNING_OFF_HOUR = 7

@export var sprite: Sprite2D
@export var pos_l: Node2D
@export var pos_r: Node2D


func _ready() -> void:
	G.time.hour_tick.connect(_update_light)
	_update_light()


func _process(_delta: float) -> void:
	if !enabled: return
	
	if sprite.flip_h:
		position = pos_l.position
	else:
		position = pos_r.position


func _update_light() -> void:
	if G.time.hour >= NIGHT_ON_HOUR or G.time.hour < MORNING_OFF_HOUR:
		enabled = true
