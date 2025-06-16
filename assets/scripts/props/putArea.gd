extends Area2D

@onready var interaction_handler: InteractionHandler = G.player.interaction_handler
@onready var main: Node2D = get_node("/root/main")
var may_interact: bool


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	
		if event is InputEventMouseButton and !event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			interaction_handler.put_item(main.get_global_mouse_position(), self)


func _on_mouse_entered() -> void:
	may_interact = G.player.global_position.distance_to(global_position) <= InteractionHandler.INTERACTION_DISTANCE
	if may_interact:
		interaction_handler.mouse_entered_put_area()


func _on_mouse_exited() -> void:
	interaction_handler.mouse_exited_put_area()
	may_interact = false
