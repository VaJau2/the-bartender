extends Node

class_name ItemMoving

@export var velocity: Vector2


func set_velocity(new_velocity: Vector2):
	velocity = new_velocity
	set_process(true)


func _process(delta: float) -> void:
	if velocity.length() == 0: set_process(false)
	get_parent().translate(velocity * delta)
	velocity = velocity.lerp(Vector2.ZERO, 5 * delta)
