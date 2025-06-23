extends Area2D

@onready var interaction_controller: InteractionController = G.player.interaction_controller

@export var sprite: Sprite2D
@export var open_texture: Texture
@export var closed_texture: Texture

@export var bar_menu: BarMenu

signal on_change_open(value: bool)


func _ready() -> void:
	bar_menu.menu_changed.connect(_on_menu_changed)
	bar_menu.open_changed.connect(_on_open_changed)


func on_mouse_entered() -> void:
	interaction_controller.show_hint.emit("open-sign")


func on_mouse_exited() -> void:
	interaction_controller.hide_item_hint.emit()



func interact() -> void:
	if !bar_menu.is_open and bar_menu.items.is_empty():
		interaction_controller.show_hint_text.emit(Loc.trans("interface.bar_menu.is_empty"))
		return
	
	interaction_controller.hide_item_hint.emit()
	bar_menu.set_is_open(!bar_menu.is_open)


func _on_open_changed(value: bool) -> void:
	sprite.texture = open_texture if value else closed_texture


func _on_menu_changed() -> void:
	if bar_menu.items.is_empty():
		bar_menu.set_is_open(false)
