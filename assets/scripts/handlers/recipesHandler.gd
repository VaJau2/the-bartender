class_name RecepiesHandler


static func get_juicer_result(ingredient: String) -> String:
	var json_data = JsonParse.read("res://assets/json/data/recipes.json")
	var juicer_recepies = json_data.juicer
	if juicer_recepies.has(ingredient):
		return juicer_recepies[ingredient]
	return ""
