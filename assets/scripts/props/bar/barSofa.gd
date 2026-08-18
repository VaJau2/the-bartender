extends StaticBody2D

@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var sleep_pos: Node2D = get_node("sleepPos")

var is_sleeping: bool


func _process(_delta: float) -> void:
	if is_sleeping and G.player.input_controller.is_moving:
		G.player.global_position = Vector2(sleep_pos.global_position.x, sleep_pos.global_position.y + 30)
		G.player.camera.position_smoothing_enabled = true
		set_sleeping(false)


func on_mouse_entered() -> void:
	if is_sleeping: return
	interaction_controller.show_hint.emit("sofa")


func on_mouse_exited() -> void:
	interaction_controller.hide_item_hint.emit()


func interact() -> void:
	if is_sleeping: return
	interaction_controller.hide_item_hint.emit()
	G.player.global_position = sleep_pos.global_position
	G.player.camera.position_smoothing_enabled = false
	set_sleeping(true)


func set_sleeping(value: bool):
	is_sleeping = value
	G.player.movement_controller.may_move = !is_sleeping
	G.player.movement_controller.load_state("sleep" if value else "walk")
	Engine.time_scale = 20 if is_sleeping else 1
	
	L.may_save = !value
	if !value: L.save_data()
