extends Node

class_name MovementController

#----------------------------------------------
# Отвечает за передвижение персонажа
#-----------------------------------------------

@onready var parent: CharacterBody2D = get_parent()
@export var movement_speed = 100

var may_move: bool = true
var dir: Vector2
var current_state: MovementState

signal move
signal stop
signal state_changed(state: String)


func _ready() -> void:
	set_physics_process(false)
	load_state('default')


func _physics_process(_delta):
	set_velocity(dir * current_state.speed)


func load_state(state_name: String = 'default') -> void:
	if current_state != null and state_name == current_state.name: return
	
	if state_name == 'default':
		for state in get_children():
			if state is MovementState and state.default:
				set_current_state(state)
	else:
		set_current_state(get_node(state_name))


func set_current_state(new_state: MovementState) -> void:
	current_state = new_state
	state_changed.emit(new_state.name)


func set_velocity(new_velocity: Vector2) -> void:
	parent.velocity = new_velocity
	
	if new_velocity.length() > 0 and may_move:
		move.emit()
		parent.move_and_slide()
	else:
		stop.emit()
