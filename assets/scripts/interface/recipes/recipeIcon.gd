extends TextureRect

class_name RecipeIcon

var item_code: String
var holding_item_code: String
var category: String

var menu: RecipesMenu


func set_item_code(value: String) -> void:
	item_code = value
	var json_data = JsonParse.read("res://assets/json/data/items.json")
	var item_data = json_data[value]
	texture = load("res://" + item_data.texture)


func _on_mouse_entered() -> void:
	menu.show_hint.emit(item_code)


func _on_mouse_exited() -> void:
	menu.hide_hint.emit()
