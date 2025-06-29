extends Node

class_name DrunkHandler

@onready var parent = get_parent()

@export var movement_controller: MovementController

var drunk_timer: float


func _ready() -> void:
	set_process(false)


func _process(delta: float) -> void:
	if drunk_timer > 0:
		drunk_timer -= delta
	else:
		if parent.get("walk_state"):
			parent.walk_state = "walk"
		if movement_controller.current_state.name == "drunk":
			movement_controller.load_state("walk")
		set_process(false)


func add_drunk_time(time: float) -> void:
	drunk_timer += time
	if parent.get("walk_state"):
		parent.walk_state = "drunk"
	movement_controller.load_state("drunk")
	set_process(true)
