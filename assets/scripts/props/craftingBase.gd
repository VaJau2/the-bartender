extends Area2D

class_name CraftingBase

@onready var interaction_controller: InteractionController = G.player.interaction_controller

@export var code: String

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
