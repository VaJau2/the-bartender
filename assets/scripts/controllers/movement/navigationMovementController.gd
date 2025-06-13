extends MovementController

class_name NavigationMovementController

#----------------------------------------------
# Отвечает за передвижение персонажа через навигацию
#-----------------------------------------------

@export var nav_agent: NavigationAgent2D

var target: Vector2


func _physics_process(_delta):
	if !nav_agent.is_target_reachable() or nav_agent.is_navigation_finished():
		set_velocity(Vector2.ZERO)
		set_physics_process(false)
		return
	
	var current_pos: Vector2 = parent.global_position
	dir = nav_agent.get_next_path_position()
	
	parent._physics_process(_delta)


func set_target(new_target: Vector2) -> void:
	nav_agent.target_position = new_target
	set_physics_process(true)


func is_navigating() -> bool:
	return is_physics_processing()


func stop_navigation() -> void:
	set_physics_process(false)
	stop.emit()
