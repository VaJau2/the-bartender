extends Node

@export var sprite: Sprite2D
@export var anim: AnimationPlayer
@export var movement_controller: MovementController
@onready var parent: CharacterBody2D = get_parent()

var watch_velocity: bool = false


func _ready() -> void:
	movement_controller.move.connect(on_move)
	movement_controller.stop.connect(on_stop)
	movement_controller.state_changed.connect(on_state_changed)
	on_stop()


func on_stop() -> void:
	anim.play(movement_controller.current_state.idle_anim)
	watch_velocity = false


func on_move() -> void:
	anim.play(movement_controller.current_state.anim)
	watch_velocity = true


func on_state_changed(_state) -> void:
	if !watch_velocity: on_stop()


func _process(_delta) -> void:
	if watch_velocity and parent.velocity.x != 0:
		sprite.flip_h = parent.velocity.x < 0
