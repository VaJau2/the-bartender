extends Area2D

@export var drunk_handler: DrunkHandler
@export var interaction_controller: InteractionController
@onready var audi: AudioStreamPlayer2D = get_node("audi")


func _ready() -> void:
	var handler: InteractionHandler = get_node("interactionHandler")
	handler.interaction_controller = interaction_controller


func interact() -> void:
	if !may_interact():return
	
	var item = interaction_controller.holding_item
	audi.play()
	
	if item.booze_time > 0:
		drunk_handler.add_drunk_time(item.booze_time)
	
	item.queue_free()
	interaction_controller.update_holding_item(null)


func may_interact() -> bool:
	var item = interaction_controller.holding_item
	if item == null:
		return false
	
	if item.name == "empty-glass" or item.type != Enums.ItemType.glass:
		return false
	return true
