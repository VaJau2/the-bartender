extends Node

@export var movement_controller: MovementController
var input_handler: InputHandler
var is_moving: bool = false
var temp_interactable: Node


func _ready() -> void:
	input_handler = get_node("/root/main/menu/inputHandler")
	input_handler.key_running.connect(_on_running)


func _on_running() -> void:
	var state = movement_controller.current_state.name
	movement_controller.load_state("run" if state != "run" else "walk")


func _physics_process(_delta: float) -> void:
	if input_handler.get_dir().length() > 0:
		is_moving = true
		movement_controller.set_velocity(input_handler.get_dir() * movement_controller.current_state.speed)
	elif is_moving:
		is_moving = false
		movement_controller.set_velocity(Vector2.ZERO)
