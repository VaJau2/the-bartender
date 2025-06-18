extends Area2D

@onready var interaction_controller: InteractionController = G.player.interaction_controller


func on_mouse_entered() -> void:
	var item = interaction_controller.holding_item
	if item != null: return
	interaction_controller.show_item_hint.emit("glass-locker")


func on_mouse_exited() -> void:
	interaction_controller.hide_item_hint.emit()

func interact() -> void:
	var item = interaction_controller.holding_item
	if item != null: return
	if G.glasses_count >= G.GLASS_MAX_COUNT: return
	
	var glass = ItemSpawner.spawn_item("empty-glass", global_position, get_parent())
	glass.visible = false
	glass.process_mode = Node.PROCESS_MODE_DISABLED
	interaction_controller.update_holding_item(glass)
	G.glasses_count += 1
