extends Area2D

class_name PutArea

@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var main: Node2D = get_node("/root/main")
var may_interact: bool


func on_mouse_entered() -> void:
	if interaction_controller.holding_item == null: return
	interaction_controller.show_put_hint.emit()


func on_mouse_exited() -> void:
	interaction_controller.hide_put_hint.emit()


func interact() -> void:
	var item_to_put = interaction_controller.holding_item
	if item_to_put == null: 
		return
	var temp_scale = item_to_put.global_scale
	item_to_put.get_parent().remove_child(item_to_put)
	get_parent().add_child(item_to_put)
	item_to_put.global_scale = temp_scale
	item_to_put.process_mode = Node.PROCESS_MODE_INHERIT
	item_to_put.visible = true
	item_to_put.global_position = main.get_global_mouse_position()
	interaction_controller.update_holding_item(null)
