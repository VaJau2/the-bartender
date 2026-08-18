extends Node

@onready var sprite: Sprite2D = get_parent()

@export var default_sprite: Texture2D
@export var serious_sprite: Texture2D
@export var tired_sprite: Texture2D

@export var need_controller: NeedsController

var is_tired: bool


func _ready() -> void:
	need_controller.need_stage_updated.connect(_on_stage_updated)


func _on_stage_updated(need: NeedsController.NeedEnum, stage: NeedsController.NeedStageEnum) -> void:
	if need == NeedsController.NeedEnum.fatigue:
		if stage == NeedsController.NeedStageEnum.red:
			sprite.texture = tired_sprite
			is_tired = true
			return
		else:
			is_tired = false
	
	if is_tired: return
	
	if [NeedsController.NeedStageEnum.yellow, NeedsController.NeedStageEnum.red].has(stage):
		sprite.texture = serious_sprite
		return
	
	for temp_stage in need_controller.need_stages.values():
		if [NeedsController.NeedStageEnum.yellow, NeedsController.NeedStageEnum.red].has(temp_stage):
			return
	
	sprite.texture = default_sprite
