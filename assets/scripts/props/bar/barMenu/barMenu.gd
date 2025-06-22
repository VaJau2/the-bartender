extends Area2D

class_name BarMenu

@onready var interaction_controller: InteractionController = G.player.interaction_controller

var items: Array[BarMenuItem]


func on_mouse_entered() -> void:
	interaction_controller.show_hint.emit("menu")


func on_mouse_exited() -> void:
	interaction_controller.hide_item_hint.emit()


func interact() -> void:
	interaction_controller.hide_item_hint.emit()
	interaction_controller.open_bar_menu.emit(self)


func add_item_to_menu(code: String) -> BarMenuItem:
	var menu_item = BarMenuItem.new()
	menu_item.code = code
	menu_item.price = 0
	
	items.append(menu_item)
	return menu_item


func has_item(code: String) -> bool:
	for item in items:
		if item.code == code:
			return true
	return false


func get_receipt_items() -> Array[String]:
	var json_data = JsonParse.read("res://assets/json/data/items.json")
	var result: Array[String] = []
	
	for item_code in json_data:
		var item_data = json_data[item_code]
		var item_type = Enums.ItemType.get(item_data.type)
		if item_type == Enums.ItemType.glass:
			if item_data.has("empty"): continue
			result.append(item_code)
	
	return result
