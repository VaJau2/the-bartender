extends Node

const INTERACTION_DISTANCE: float = 100

@export var movement_controller: MovementController
@export var input_ray: RayCast2D
var input_handler: InputHandler
var is_key_moving: bool = false


func _ready() -> void:
	input_handler = get_node("/root/main/menu/inputHandler")
	input_handler.click.connect(_on_click)
	input_handler.key_running.connect(_on_running)


func _on_click(pos: Vector2) -> void:
	var interactable = get_interactable(pos)
	if interactable != null:
		interactable.interact(get_parent())
		return
	movement_controller.set_target(pos)


func get_interactable(pos: Vector2) -> Node: 
	if get_parent().global_position.distance_to(pos) > INTERACTION_DISTANCE:
		return null
	input_ray.target_position = pos - get_parent().global_position
	input_ray.force_raycast_update()
	var collider_body = input_ray.get_collider()
	if collider_body != null && collider_body.has_method("interact"):
		return collider_body
	return null


func _on_running() -> void:
	var state = movement_controller.current_state.name
	movement_controller.load_state("run" if state != "run" else "walk")


func _physics_process(_delta: float) -> void:
	if input_handler.get_dir().length() > 0:
		is_key_moving = true
		movement_controller.set_velocity(input_handler.get_dir() * movement_controller.current_state.speed)
	elif is_key_moving:
		is_key_moving = false
		movement_controller.set_velocity(Vector2.ZERO)
