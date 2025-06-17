extends Area2D

@onready var interaction_controller: InteractionController = G.player.interaction_controller

func on_mouse_entered() -> void:
	var item = interaction_controller.holding_item
	if item == null: return
	interaction_controller.show_put_hint.emit()


func on_mouse_exited() -> void:
	interaction_controller.hide_put_hint.emit()


func interact() -> void:
	var item = interaction_controller.holding_item
	if item == null: return
	
	item.queue_free()
	interaction_controller.clear_item.emit()
