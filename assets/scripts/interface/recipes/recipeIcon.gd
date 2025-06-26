extends TextureRect

class_name RecipeIcon

var recipe_data: RecipeData
var menu: RecipesMenu
var is_opened: bool


func check_opened() -> void:
	is_opened = G.game_manager.knowed_recipes.has(recipe_data.result)
	if is_opened:
		modulate = Color.WHITE
	else:
		modulate = Color.BLACK


func set_item_data(value: RecipeData) -> void:
	recipe_data = value
	var json_data = JsonParse.read("res://assets/json/data/items.json")
	var item_data = json_data[value.result]
	texture = load("res://" + item_data.texture)


func _on_mouse_entered() -> void:
	if !is_opened: return
	menu.show_hint.emit(recipe_data)


func _on_mouse_exited() -> void:
	menu.hide_hint.emit()
