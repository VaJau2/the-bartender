extends Node

class_name StateMachine

@onready var npc: NPC = get_parent()

var current_state: State


func _ready() -> void:
	await get_tree().create_timer(0.2).timeout
	
	for state: State in get_children():
		state.init()
		
		if state.default:
			state.enable()
			current_state = state


func set_state(state_name: String) -> void:
	for state: State in get_children():
		if state.name == state_name:
			current_state.disable()
			state.enable()
			current_state = state
