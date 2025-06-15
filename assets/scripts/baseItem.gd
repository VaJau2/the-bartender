extends Node2D

class_name Item

const INTERACTION_DISTANCE: float = 200

@onready var hint: ItemHint = get_tree().get_first_node_in_group("item_hint")
@onready var sprite: Sprite2D = get_node("sprite")

@export var item_code: String

var item_data: Dictionary


func _ready() -> void:
	var json_data = JsonParse.read("res://assets/json/data/items.json")
	item_data = json_data[item_code]
	var texture_path = item_data["texture"]
	sprite.texture = load("res://" + texture_path)


func _on_mouse_entered() -> void:
	if G.player.global_position.distance_to(global_position) > INTERACTION_DISTANCE:
		return
	hint.show_item_hint(item_code)


func _on_mouse_exited() -> void:
	hint.hide_item_hint()


func interact() -> void:
	pass
