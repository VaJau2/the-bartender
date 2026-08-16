extends Control

@export var green_color: Color
@export var yellow_color: Color
@export var red_color: Color

@onready var thirst_icon: Control = get_node("thirst")
@onready var hunger_icon: Control = get_node("hunger")
@onready var fatigue_icon: Control = get_node("fatigue")


func _ready() -> void:
	G.player.needs_controller.need_stage_updated.connect(_on_stage_updated)


func _on_stage_updated(need: NeedsController.NeedEnum, stage: NeedsController.NeedStageEnum) -> void:
	var icon = _get_stage_icon(need)
	if !icon: return
	
	if stage == NeedsController.NeedStageEnum.none:
		icon.visible = false
		return
	
	icon.visible = true
	var sprite: Sprite2D = icon.get_node("sprite")
	sprite.modulate = _get_stage_color(stage)


func _get_stage_icon(need: NeedsController.NeedEnum) -> Control:
	match need:
		NeedsController.NeedEnum.thirst: return thirst_icon
		NeedsController.NeedEnum.hunger: return hunger_icon
		NeedsController.NeedEnum.fatigue: return fatigue_icon
	
	return null


func _get_stage_color(stage: NeedsController.NeedStageEnum) -> Color:
	match stage:
		NeedsController.NeedStageEnum.green: return green_color
		NeedsController.NeedStageEnum.yellow: return yellow_color
		NeedsController.NeedStageEnum.red: return red_color
	
	return Color.WHITE
