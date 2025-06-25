extends CharacterBody2D

class_name Player

@onready var input_controller: InputController = get_node("inputController")
@onready var interaction_controller: InteractionController = get_node("interactionController")
@onready var movement_controller: MovementController = get_node("movementController")
@onready var storage_handler: StorageHandler = get_node("storageHandler")

@export var using_storage: bool
@export var has_storage: bool = false

signal update_using_storage(value: bool)
signal move_items_from_bag


func set_using_storage(value: bool): 
	using_storage = value
	update_using_storage.emit(value)
	if !value: move_items_from_bag.emit()
