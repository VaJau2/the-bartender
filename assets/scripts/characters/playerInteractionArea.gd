extends Area2D

class_name PlayerInteraction

@export var drunk_handler: DrunkHandler
@export var interaction_controller: InteractionController
@export var drinking_sound: AudioStream
@export var eating_sounds: Array[AudioStream]
@onready var audi: AudioStreamPlayer2D = get_node("audi")

signal eating(item: Item)


func _ready() -> void:
	var handler: InteractionHandler = get_node("interactionHandler")
	handler.interaction_controller = interaction_controller


func interact() -> void:
	if !may_interact(): return
	
	var item = interaction_controller.holding_item
	
	if item.type == Enums.ItemType.glass:
		audi.stream = drinking_sound
	else:
		audi.stream = eating_sounds.pick_random()
	audi.play()
	
	if item.booze_time > 0:
		drunk_handler.add_drunk_time(item.booze_time)
		
	eating.emit(item)
	
	item.queue_free()
	interaction_controller.update_holding_item(null)


func may_interact() -> bool:
	var item = interaction_controller.holding_item
	if item == null:
		return false
		
	if ["vegetable", "berry", "fruit"].has(item.category):
		return true
	
	if item.code != "empty-glass" && item.type == Enums.ItemType.glass:
		return true
	
	return true
