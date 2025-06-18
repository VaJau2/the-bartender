extends Node

class_name InteractionHandler

@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var parent: CollisionObject2D = get_parent()
var may_interact: bool


func _ready() -> void:
	parent.mouse_entered.connect(_on_mouse_entered)
	parent.mouse_exited.connect(_on_mouse_exited)
	parent.input_event.connect(_on_input_event)


func _on_mouse_entered() -> void:
	_check_may_interact()
	if may_interact:
		interaction_controller.mouse_entered_item(parent)


func _on_mouse_exited() -> void:
	interaction_controller.mouse_exited_item(parent)
	may_interact = false


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and !event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		_check_may_interact()
		if may_interact:
			interaction_controller.interact(parent)


func _check_may_interact() -> void:
	may_interact = G.player.global_position.distance_to(parent.global_position) <= InteractionController.INTERACTION_DISTANCE
