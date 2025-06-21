extends CharacterBody2D

@export var code: String
@export var move_point: Node2D

@onready var sprite = get_node("sprite")
@onready var movement_controller: NavigationMovementController = get_node("movementController")


func _ready() -> void:
	sprite.texture = load("res://assets/sprites/characters/" + code + ".png")
	await get_tree().create_timer(1).timeout
	if move_point:
		movement_controller.set_target(move_point.global_position)
	movement_controller.came_to_point.connect(_on_came_to_point)


func _on_came_to_point() -> void:
	if move_point is MarketStand:
		move_point.start_trading(self)
