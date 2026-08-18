extends BaseCharacterSaveManager

class_name NpcSaveManager

@export var state_machine: StateMachine


func get_save_data() -> Dictionary:
	var data = super()
	data.state = state_machine.current_state.name
	if state_machine.current_state.has_method("get_save_data"):
		data.state_data = state_machine.current_state.get_save_data()
	data.movement_state = movement_controller.current_state.name
	return data


func load_save_data(data: Dictionary) -> void:
	super(data)
	var state_to_load = state_machine.get_node(data.state)
	if state_to_load.has_method("load_save_data"):
		state_to_load.load_save_data(data.state_data)
	state_machine.set_state(data.state)
	movement_controller.load_state(data.movement_state)
