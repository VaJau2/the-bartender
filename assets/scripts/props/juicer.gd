extends CraftingBase

@onready var audi: AudioStreamPlayer2D = get_node("audi")

var base_item_path: String = "res://objects/props/items/base-item.tscn"


func on_mouse_entered() -> void:
	interaction_controller.show_item_hint.emit(code)


func on_mouse_exited() -> void:
	interaction_controller.hide_item_hint.emit()


func interact() -> void:
	interaction_controller.hide_item_hint.emit()
	var item = interaction_controller.holding_item
	
	if item == null:
		interaction_controller.open_crafting_menu.emit(self)
	
	elif item.code == "empty-glass" and glass == null:
		glass = item
		interaction_controller.holding_item = null
		interaction_controller.clear_item.emit()
	
	elif item.type == Enums.ItemType.ingredient and ingredient == null:
		var result = RecepiesHandler.get_juicer_result(item.code)
		if result == "": return
		ingredient = item
		result_code = result
		interaction_controller.holding_item = null
		interaction_controller.clear_item.emit()
