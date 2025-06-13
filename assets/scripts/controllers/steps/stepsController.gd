extends AudioStreamPlayer2D

class_name StepsController

const WALK_COOLDOWN = 0.4
const RUN_COOLDOWN = 0.6

@export var movement_controller: MovementController
@export var steps_data: Array[StepData]
@export var default_material: Enums.Materials

var current_material: Enums.Materials
var curent_sound_array: Array[AudioStream]
var current_state: String
var sound_index: int = 0
var timer: float = 0


func _ready() -> void:
	current_material = default_material
	movement_controller.move.connect(on_move)
	movement_controller.stop.connect(on_stop)
	on_stop()


func on_move() -> void:
	set_process(true)


func on_stop() -> void:
	set_process(false)


func on_change_material(new_material: Enums.Materials) -> void:
	current_material = new_material
	build_sound_array()


func _process(delta: float) -> void:
	if current_state != get_movement_state() or sound_index >= len(curent_sound_array):
		build_sound_array()
	
	if timer > 0:
		timer -= delta
	else:
		stream = curent_sound_array[sound_index]
		play()
		sound_index += 1
		timer = WALK_COOLDOWN if current_state == "walk" else RUN_COOLDOWN


func build_sound_array() -> void:
	current_state = get_movement_state()
	
	for step_data in steps_data:
		if step_data.material_name == current_material:
			curent_sound_array = step_data.run_sounds \
				if current_state == "run" \
				else step_data.walk_sounds
			curent_sound_array.shuffle()
			sound_index = 0


func get_movement_state() -> String:
	return movement_controller.current_state.name
