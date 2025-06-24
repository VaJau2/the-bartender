extends Node2D

class_name NpcDialogue

@onready var bubble: Sprite2D = get_node("bubble")
@onready var icon: Sprite2D = get_node("icon")

@export var thinking_texture: Texture
@export var thanks_textures: Array[Texture]
@export var wrong_texture: Texture


func show_thinking_icon() -> void:
	icon.texture = thinking_texture
	visible = true


func show_wrong_icon() -> void:
	icon.texture = wrong_texture
	visible = true


func show_thanks_icon() -> void:
	icon.texture = thanks_textures[randi() % len(thanks_textures) - 1]
	visible = true


func show_item_icon(code: String) -> void:
	var json_data = JsonParse.read("res://assets/json/data/items.json")
	for item_code in json_data:
		if item_code == code:
			var texture_path = json_data[item_code].texture
			icon.texture = load("res://" + texture_path)
			visible = true
			return


func set_transparency(value: float) -> void:
	bubble.modulate.a = value
	icon.modulate.a = value


func hide_icon() -> void:
	visible = false
