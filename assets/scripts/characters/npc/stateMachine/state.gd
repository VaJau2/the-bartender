extends Node

class_name State

const SLEEP_TIME = 21
const WAKE_TIME = 6
const SLEEP_CHANCE = 0.2

@export var default: bool
@export var movement_controller: NavigationMovementController

var state_machine: StateMachine


func _ready() -> void:
	set_process(false)


# кастомная функция вместо ready, 
# чтобы стейты загружались после state_machine, а не до него
func init() -> void:
	state_machine = get_parent()


func enable() -> void: 
	set_process(true)


func disable() -> void:
	set_process(false)
