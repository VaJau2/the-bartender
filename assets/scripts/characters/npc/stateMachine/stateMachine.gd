extends Node

class_name StateMachine

const DELAY: float = 0.5

@onready var npc: NPC = get_parent()

var current_state: State


func _ready() -> void:
	# задержка для успевания прогрузки навигации
	await get_tree().create_timer(DELAY).timeout
	
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
