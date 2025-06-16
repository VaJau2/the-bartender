extends StaticBody2D

class_name Item

@onready var interaction_handler: InteractionHandler = G.player.interaction_handler
@onready var sprite: Sprite2D = get_node("sprite")

@export var code: String
var may_interact: bool


func _ready() -> void:
	var json_data = JsonParse.read("res://assets/json/data/items.json")
	var item_data = json_data[code]
	var texture_path = item_data["texture"]
	sprite.texture = load("res://" + texture_path)


func _on_mouse_entered() -> void:
	may_interact = G.player.global_position.distance_to(global_position) <= InteractionHandler.INTERACTION_DISTANCE
	if may_interact:
		interaction_handler.mouse_entered_item(self)


func _on_mouse_exited() -> void:
	interaction_handler.mouse_exited_item()
	may_interact = false


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and !event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if may_interact:
			interaction_handler.interact(self)
