extends Area2D

class_name Storage

@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var audi: AudioStreamPlayer2D = get_node("audi")

@export var open_sound: AudioStream
@export var close_sound: AudioStream

@export var code: String

var items: Array[Item]


func on_mouse_entered() -> void:
	interaction_controller.show_item_hint.emit(code)


func on_mouse_exited() -> void:
	interaction_controller.hide_item_hint.emit()


func interact() -> void:
	interaction_controller.hide_item_hint.emit()
	var item = interaction_controller.holding_item
	
	if item == null:
		audi.stream = open_sound
		audi.play()
		interaction_controller.open_storage_menu.emit(self)
		return
	
	items.append(item)
	interaction_controller.holding_item = null
	interaction_controller.clear_item.emit()


func close() -> void:
	audi.stream = close_sound
	audi.play()


func get_item(item: Item) -> void:
	items.erase(item)
	interaction_controller.update_holding_item(item)
