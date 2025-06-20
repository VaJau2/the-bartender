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
	if interaction_controller.holding_item != null: return
	interaction_controller.show_item_hint.emit(self)


func on_mouse_exited() -> void:
	interaction_controller.hide_item_hint.emit()


func get_limit_percent() -> String:
	return str(int(limit / item_data.limit * 100)) + "%"


func interact() -> void:
	if G.player.using_storage:
		if G.player.storage_handler.can_put_item(self):
			disable()
			G.player.storage_handler.put_item(self)
			return
	
	if interaction_controller.holding_item == null:
		disable()
		interaction_controller.update_holding_item(self)
		taken.emit(self)
	else:
		var holding_item = interaction_controller.holding_item
		var result = RecepiesHandler.get_tool_result(code, holding_item.code)
		if result == "": return
		code = result
		_ready()
		
		if holding_item.limit == -1: return
		if holding_item.limit > 1:
			holding_item.limit -= 1
		else:
			holding_item.queue_free()
			interaction_controller.update_holding_item(null)


func _load_icon() -> void:
	var texture_path = item_data.texture
	if !texture_path: return
	var texture = load("res://" + texture_path)
	if !texture: return
	sprite.texture = texture
