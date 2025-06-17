extends Area2D

@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var audi: AudioStreamPlayer2D = get_node("audi")

@export var fill_sound: AudioStream
@export var splat_sound: AudioStream

var base_item_path: String = "res://objects/props/items/base-item.tscn"

func on_mouse_entered() -> void:
	var item = interaction_controller.holding_item
	if item == null or item.type != Enums.ItemType.glass: return
	interaction_controller.show_put_hint.emit()


func on_mouse_exited() -> void:
	interaction_controller.hide_put_hint.emit()


func interact() -> void:
	var item = interaction_controller.holding_item
	if item == null or item.type != Enums.ItemType.glass: return
	
	if item.code == "empty-glass":
		audi.stream = fill_sound
		item.code = "glass-water"
	else:
		audi.stream = splat_sound
		item.code = "empty-glass"
	
	audi.play()
	item._ready()
	interaction_controller.pickup_item.emit(item)
