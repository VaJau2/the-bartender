extends StaticBody2D

class_name Item

@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var sprite: Sprite2D = get_node("sprite")
@onready var moving: ItemMoving = get_node("moving")

@export var code: String

var item_data: Dictionary

var type: Enums.ItemType
var category: String
var limit: int
var weight: float
var needs_fridge: bool
var booze_time: float

signal taken(item: Item)


func _ready() -> void:
	var json_data = JsonParse.read("res://assets/json/data/items.json")
	item_data = json_data[code]
	category = item_data.category
	if item_data.has("limit"):
		limit = item_data.limit
	if item_data.has("weight"):
		weight = item_data.weight
	if item_data.has("need_fridge"):
		needs_fridge = item_data.need_fridge
	if item_data.has("booze_time"):
		booze_time = item_data.booze_time
	type = Enums.ItemType.get(item_data.type)
	_load_icon()


func enable() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	visible = true


func disable() -> void:
	moving.set_velocity(Vector2.ZERO)
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED


func on_mouse_entered() -> void:
	if interaction_controller.holding_item != null: 
		if _may_show_craft_hint(interaction_controller.holding_item):
			interaction_controller.show_craft_hint.emit()
	else:
		interaction_controller.show_item_hint.emit(self)


func on_mouse_exited() -> void:
	interaction_controller.hide_item_hint.emit()
	interaction_controller.hide_craft_hint.emit()


func get_limit_percent() -> String:
	return str(int(limit / item_data.limit * 100)) + "%"


func interact() -> void:
	interaction_controller.hide_craft_hint.emit()
	
	if interaction_controller.try_get_item(self):
		interaction_controller.hide_item_hint.emit()
		return
	
	if interaction_controller.holding_item != null:
		var holding_item = interaction_controller.holding_item
		var craft_result = _try_craft_item(self, holding_item)
		if !craft_result:
			_try_craft_item(holding_item, self)


func _try_craft_item(item1: Item, item2: Item) -> bool:
	var result = RecepiesHandler.get_tool_result(item1.code, item2.code)
	if result == "": return false
	item1.code = result
	G.game_manager.try_know_recipe.emit(result)
	item1._ready()
	if item1 == interaction_controller.holding_item:
		interaction_controller.update_holding_item(item1)
		
	if item2.limit == -1: return true
	if item2.limit > 1:
		item2.limit -= 1
	else:
		if item2 == interaction_controller.holding_item:
			interaction_controller.update_holding_item(null)
			
		item2.queue_free()
	
	return true


func _may_show_craft_hint(holding_item: Item) -> bool:
	if RecepiesHandler.get_tool_result(code, holding_item.code) != "":
		return true
	if RecepiesHandler.get_tool_result(holding_item.code, code) != "":
		return true
	return false


func _load_icon() -> void:
	var texture_path = item_data.texture
	if !texture_path: return
	var texture = load("res://" + texture_path)
	if !texture: return
	sprite.texture = texture
