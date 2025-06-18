extends StaticBody2D

class_name Item

@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var sprite: Sprite2D = get_node("sprite")
@onready var moving: ItemMoving = get_node("moving")

@export var code: String
var type: Enums.ItemType
var category: String


func _ready() -> void:
	var json_data = JsonParse.read("res://assets/json/data/items.json")
	var item_data = json_data[code]
	category = item_data.category
	type = Enums.ItemType.get(item_data.type)
	_load_icon(item_data)


func on_mouse_entered() -> void:
	if interaction_controller.holding_item != null: return
	interaction_controller.show_item_hint.emit(code)


func on_mouse_exited() -> void:
	interaction_controller.hide_item_hint.emit()


func interact() -> void:
	if interaction_controller.holding_item != null:
		return
	moving.set_velocity(Vector2.ZERO)
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	interaction_controller.update_holding_item(self)


func _load_icon(item_data: Dictionary) -> void:
	var texture_path = item_data.texture
	if !texture_path: return
	var texture = load("res://" + texture_path)
	if !texture: return
	sprite.texture = texture
