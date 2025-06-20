extends Area2D

class_name StorageArea

@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var audi: AudioStreamPlayer2D = get_node("audi")
@onready var storage: StorageHandler = get_node("storageHandler")

@export var open_sound: AudioStream
@export var close_sound: AudioStream


func on_mouse_entered() -> void:
	interaction_controller.show_hint.emit(storage.code)


func on_mouse_exited() -> void:
	interaction_controller.hide_item_hint.emit()


func interact() -> void:
	interaction_controller.hide_item_hint.emit()
	
	if interaction_controller.holding_item == null:
		audi.stream = open_sound
		audi.play()
		interaction_controller.open_storage_menu.emit(storage)
		return
	
	storage.put_holding_item()


func close() -> void:
	audi.stream = close_sound
	audi.play()


func get_item(item: Item) -> void:
	storage.get_item(item)
