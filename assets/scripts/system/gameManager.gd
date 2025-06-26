extends Node

class_name GameManager

@export var knowed_recipes: Array[String]

signal try_know_recipe(code: String)
signal know_recipe(code: String)


func _ready() -> void:
	G.statistics.reset()
	G.time.day_tick.connect(_on_day_tick)
	try_know_recipe.connect(_on_know_recipe)


func _on_day_tick() -> void:
	var days_left = G.DAYS_GOAL - G.time.day
	if days_left == 0:
		if M.money >= G.MONEY_GOAL:
			S.goto_scene("Win")
		else:
			S.goto_scene("Lost")


func _on_know_recipe(code: String) -> void:
	if knowed_recipes.has(code): return
	knowed_recipes.append(code)
	know_recipe.emit(code)
