class_name RecepiesHandler


static func get_crafting_result(machine: String, ingredient: String) -> String:
	var json_data = JsonParse.read("res://assets/json/data/recipes.json")
	var recipes = json_data[machine]
	if recipes.has(ingredient):
		return recipes[ingredient]
	return ""


static func get_tool_result(item: String, holding_item: String) -> String:
	var json_data = JsonParse.read("res://assets/json/data/recipes.json")
	var recipes = json_data.tool
	for recipe in recipes:
		if recipe.item == item and recipe.holding_item == holding_item:
			return recipe.result
	return ""
