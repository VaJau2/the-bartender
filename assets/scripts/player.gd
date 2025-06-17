extends CharacterBody2D

class_name Player

@onready var interaction_controller: InteractionController = get_node("interactionController")
@onready var movement_controller: MovementController = get_node("movementController")
