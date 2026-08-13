extends Area2D

class_name CraftingBase

@onready var interaction_controller: InteractionController = G.player.interaction_controller

@export var code: String
@export var result_velocity: Vector2 = Vector2(42, 5)

var may_interact: bool = true

var ingredient: Item = null
var glass: Item = null
var result_code: String


func get_glass() -> void:
	if interaction_controller.holding_item != null: return
	interaction_controller.update_holding_item(glass)
	glass = null


func get_ingredient() -> void:
	if interaction_controller.holding_item != null: return
	interaction_controller.update_holding_item(ingredient)
	ingredient = null


func start() -> void:
	pass


func interact() -> void:
	pass


func interact_alt() -> void:
	pass


func get_save_data() -> Dictionary:
	var ingredient_id = -1
	if ingredient: ingredient_id = ingredient.save_id
	
	var glass_id = -1
	if glass: glass_id = glass.save_id
	
	return {
		"ingredient_id": ingredient_id,
		"glass_id": glass_id,
		"result": result_code
	}


func load_save_data(data: Dictionary) -> void:
	if data.ingredient_id != -1:
		ingredient = L.created_objects[data.ingredient_id]
	if data.glass_id != -1:
		glass = L.created_objects[data.glass_id]
	result_code = data.result
