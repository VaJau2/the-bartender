extends Node

class_name GameManager

@export var knowed_recipes: Array[String]
@export var resume_menu: ResumeMenu

signal try_know_recipe(code: String)
signal know_recipe(code: String)


func _ready() -> void:
	add_to_group("save")
	G.statistics.reset()
	G.time.day_tick.connect(_on_day_tick)
	try_know_recipe.connect(_on_know_recipe)


func _on_day_tick() -> void:
	if M.debt > 0:
		if M.debt_days > 1:
			M.debt_days -= 1
			M.debt_updated.emit()
		else:
			resume_menu.show_resume()
			return
	
	var days_left = G.DAYS_GOAL - G.time.day
	if days_left == 0:
		resume_menu.show_resume()


func _on_know_recipe(code: String) -> void:
	if knowed_recipes.has(code): return
	knowed_recipes.append(code)
	know_recipe.emit(code)


func get_save_data() -> Dictionary:
	return {
		"recipes": var_to_str(knowed_recipes)
	}


func load_save_data(data: Dictionary) -> void:
	knowed_recipes = str_to_var(data.recipes)
