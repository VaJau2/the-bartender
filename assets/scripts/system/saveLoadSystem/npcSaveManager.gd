extends BaseCharacterSaveManager

class_name NpcSaveManager

@export var state_machine: StateMachine


func get_save_data() -> Dictionary:
	var data = super()
	data.state = state_machine.current_state.name
	return data


func load_save_data(data: Dictionary) -> void:
	super(data)
	state_machine.set_state(data.state)
