extends State

var bar_wait_point: Node2D


func init() -> void:
	super()
	movement_controller.came_to_point.connect(_on_came)


func enable() -> void:
	movement_controller.set_target(bar_wait_point.global_position)
	super()


func _on_came() -> void:
	if !is_processing(): return
	pass
