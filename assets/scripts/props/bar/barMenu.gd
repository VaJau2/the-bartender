extends Area2D

class_name BarMenu

@onready var interaction_controller: InteractionController = G.player.interaction_controller


func on_mouse_entered() -> void:
	interaction_controller.show_hint.emit("menu")


func on_mouse_exited() -> void:
	interaction_controller.hide_item_hint.emit()


func interact() -> void:
	interaction_controller.hide_item_hint.emit()
	interaction_controller.open_bar_menu.emit(self)
