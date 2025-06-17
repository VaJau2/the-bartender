extends StaticBody2D

class_name Item

@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var sprite: Sprite2D = get_node("sprite")

@export var code: String
var type: Enums.ItemType


func _ready() -> void:
	var json_data = JsonParse.read("res://assets/json/data/items.json")
	var item_data = json_data[code]
	type = Enums.ItemType.get(item_data["type"])
	var texture_path = item_data["texture"]
	sprite.texture = load("res://" + texture_path)


func on_mouse_entered() -> void:
	if interaction_controller.holding_item != null: return
	interaction_controller.show_item_hint.emit(code)


func on_mouse_exited() -> void:
	interaction_controller.hide_item_hint.emit()


func interact() -> void:
	if interaction_controller.holding_item != null:
		return
	interaction_controller.holding_item = self
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	interaction_controller.pickup_item.emit(self)
