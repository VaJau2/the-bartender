extends Node2D

const SPAWN_COOLDOWN = 0.15

@export var prefab: PackedScene
@export var steps_controller: StepsController
@export var movement_controller: MovementController

var timer: float 


func _ready() -> void:
	movement_controller.move.connect(on_move)
	movement_controller.stop.connect(on_stop)
	on_stop()


func on_move() -> void:
	set_process(true)


func on_stop() -> void:
	set_process(false)


func _process(delta: float) -> void:
	if steps_controller.current_material != Enums.Materials.Water:
		return
	
	if timer > 0:
		timer -= delta
	else:
		var step = prefab.instantiate()
		var parent = steps_controller.get_node("../../")
		parent.add_child(step)
		step.global_position = global_position
		
		timer = SPAWN_COOLDOWN
