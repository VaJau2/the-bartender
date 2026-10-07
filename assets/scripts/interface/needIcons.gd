extends Control

@export var green_color: Color
@export var yellow_color: Color
@export var red_color: Color

@onready var thirst_icon: Control = get_node("thirst")
@onready var hunger_icon: Control = get_node("hunger")
@onready var fatigue_icon: Control = get_node("fatigue")

@onready var interaction_controller: InteractionController = G.player.interaction_controller


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


func _on_need_mouse_entered(need_name: String) -> void:
	var need_icon = get_node(need_name)
	if !need_icon.visible: return
	var color_name = _get_icon_color_name(need_icon)
	var need_trans_code = "interface.needs_hints." + need_name + "." + color_name 
	interaction_controller.show_hint_text.emit(Loc.trans(need_trans_code))


func _on_need_mouse_exited() -> void:
	interaction_controller.hide_item_hint.emit()


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


func _get_icon_color_name(icon: Control) -> String:
	var sprite: Sprite2D = icon.get_node("sprite")
	
	match sprite.modulate:
		green_color: return 'green'
		yellow_color: return 'yellow'
		red_color: return 'red'
	
	return 'none'
