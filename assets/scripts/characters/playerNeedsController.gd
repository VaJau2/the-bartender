extends Node

class_name NeedsController

const NEED_STAGES = {
	NeedEnum.thirst: {
		NeedStageEnum.none: 200,
		NeedStageEnum.green: 400,
		NeedStageEnum.yellow: 800,
		NeedStageEnum.red: 1000,
	},
	NeedEnum.hunger: {
		NeedStageEnum.none: 300,
		NeedStageEnum.green: 800,
		NeedStageEnum.yellow: 1700,
		NeedStageEnum.red: 2500,
	},
	NeedEnum.fatigue: {
		NeedStageEnum.none: 300,
		NeedStageEnum.green: 800,
		NeedStageEnum.yellow: 1600,
		NeedStageEnum.red: 2000,
	},
}

enum NeedEnum {
	thirst,
	hunger,
	fatigue
}

enum NeedStageEnum {
	none,
	green,
	yellow,
	red
}

@export var movement_controller: MovementController
@export var bag: StorageHandler

var need_values: Dictionary[NeedEnum, int] = {
	NeedEnum.thirst: 0,
	NeedEnum.hunger: 0,
	NeedEnum.fatigue: 0,
}

var need_stages: Dictionary[NeedEnum, NeedStageEnum] = {
	NeedEnum.thirst: NeedStageEnum.none,
	NeedEnum.hunger: NeedStageEnum.none,
	NeedEnum.fatigue: NeedStageEnum.none,
}

signal need_stage_updated(need: NeedEnum, stage: NeedStageEnum)


func _ready() -> void:
	G.time.minute_tick.connect(_on_minute_tick)


func _on_minute_tick() -> void:
	update_need_value(NeedEnum.thirst, _get_need_delta(NeedEnum.thirst))
	update_need_value(NeedEnum.hunger, _get_need_delta(NeedEnum.hunger))
	update_need_value(NeedEnum.fatigue, _get_need_delta(NeedEnum.fatigue))


func update_need_value(need: NeedEnum, delta_value: int) -> void:
	if delta_value == 0: return
	var old_value = need_values[need]
	var max_value = NEED_STAGES[need][NeedStageEnum.red]
	var new_value = clamp(old_value + delta_value, 0, max_value)
	need_values[need] = new_value
	_check_need_stage(need)


func _get_need_delta(need: NeedEnum) -> int:
	var state = movement_controller.current_state.name
	var need_delta = 0
	
	match state:
		"sleep": 
			match need:
				NeedEnum.thirst: need_delta = 1
				NeedEnum.hunger: need_delta = 1
				NeedEnum.fatigue: need_delta = -10
		"walk":
			match need:
				NeedEnum.thirst: need_delta = 3
				NeedEnum.hunger: need_delta = 2
				NeedEnum.fatigue: need_delta = 1
		"run":
			match need:
				NeedEnum.thirst: need_delta = 6
				NeedEnum.hunger: need_delta = 5
				NeedEnum.fatigue: need_delta = 4
		"drunk":
			match need:
				NeedEnum.thirst: need_delta = 10
				NeedEnum.hunger: need_delta = 2
				NeedEnum.fatigue: need_delta = 1
	
	if need_delta > 0:
		var bag_weight = bag.get_items_weight()
		need_delta += bag_weight
	
	return need_delta


func _check_need_stage(need: NeedEnum) -> void:
	var all_need_stages = NEED_STAGES[need]
	var old_stage = need_stages[need]
	var new_stage = null
	
	for need_stage in all_need_stages.keys():
		var need_stage_value = all_need_stages[need_stage]
		if need_values[need] <= need_stage_value:
			new_stage = need_stage
			break
	
	if new_stage != old_stage:
		need_stages[need] = new_stage
		need_stage_updated.emit(need, new_stage)


func get_save_data() -> Dictionary:
	return {
		"values": var_to_str(need_values),
		"stages": var_to_str(need_stages)
	}


func load_save_data(data: Dictionary) -> void:
	need_values = str_to_var(data.values)
	need_stages = str_to_var(data.stages)
	for need in need_stages.keys():
		need_stage_updated.emit(need, need_stages[need])
