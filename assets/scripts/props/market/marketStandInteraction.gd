extends Area2D

class_name MarketStandInteraction

@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var stand: MarketStand = get_node("../")

@export var open_sign: Sprite2D
@export var stand_point: Node2D
@export var open_texture: Texture
@export var closed_texture: Texture


func get_stand_pos() -> Vector2:
	return stand_point.global_position


func set_open(value: bool) -> void:
	open_sign.texture = open_texture if value else closed_texture


func on_mouse_entered() -> void:
	if !stand.is_open: return
	interaction_controller.show_hint.emit(stand.code)


func on_mouse_exited() -> void:
	interaction_controller.hide_item_hint.emit()


func interact() -> void:
	if !stand.is_open: return
	interaction_controller.hide_item_hint.emit()
	interaction_controller.open_shop_menu.emit(stand)
