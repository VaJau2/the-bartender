extends State


func enable() -> void:
	super()
	movement_controller.stop_navigation()
