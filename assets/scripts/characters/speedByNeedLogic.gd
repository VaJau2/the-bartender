extends Node

@export var needs_controller: NeedsController
@export var movement_controller: MovementController


func _ready() -> void:
	needs_controller.need_stage_updated.connect(_on_state_updated)


func get_speed(default_speed: int) -> int:
	var all_stages_none = true
	
	for stage in needs_controller.need_stages.values():
		if stage != NeedsController.NeedStageEnum.none:
			all_stages_none = false
		
		if stage == NeedsController.NeedStageEnum.red || stage == NeedsController.NeedStageEnum.yellow:
			return int(float(default_speed) / 1.25)
	
	if all_stages_none:
		return int(float(default_speed) * 1.25)
	
	return default_speed


func may_run() -> bool:
	for stage in needs_controller.need_stages.values():
		if stage == NeedsController.NeedStageEnum.red:
			return false
	
	return true


func _on_state_updated(_need, _stage) -> void:
	if movement_controller.current_state.name == "run" && !may_run():
		movement_controller.load_state("walk")
