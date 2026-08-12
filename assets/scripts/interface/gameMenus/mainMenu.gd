extends Control

const CAMERA_MIN_DIST: float = 3
const CAMERA_SPEED: float = 150
const ZOOM_SPEED: float = 1

@export var game_interface: Control
@export var time_handler: TimeHandler
@export var pause_menu: PauseMenu
@export var blur_anim: AnimationPlayer

@onready var menu_camera: Camera2D = get_node("camera")
@onready var settings_panel: Panel = get_node("menu/settingsPanel")
@onready var help_panel: Panel = get_node("menu/helpPanel")
@onready var player_camera: Camera2D = G.player.get_node("camera")
@onready var load_manager: LoadManager = get_node("/root/main/loadManager")
@onready var load_button: Button = get_node("menu/Load")


func _ready() -> void:
	load_manager.file_exist_event.connect(_on_save_file_exist)
	menu_camera.make_current()
	G.player.movement_controller.may_move = false
	set_process(false)


func _process(delta: float) -> void:
	blur_anim.play("hide")
	
	if menu_camera.zoom.x < player_camera.zoom.x:
		menu_camera.zoom.x += ZOOM_SPEED * delta
		menu_camera.zoom.y += ZOOM_SPEED * delta
	
	if menu_camera.global_position.distance_to(player_camera.global_position) > CAMERA_MIN_DIST:
		var dir = menu_camera.global_position.direction_to(player_camera.global_position)
		menu_camera.translate(CAMERA_SPEED * dir * delta)
	else:
		pause_menu.may_pause = true
		player_camera.make_current()
		G.player.movement_controller.may_move = true
		game_interface.visible = true
		time_handler.set_process(true)
		queue_free()


func _on_save_file_exist() -> void:
	load_button.disabled = false


func _on_start_pressed() -> void:
	G.game_started.emit()
	visible = false
	set_process(true)


func _on_settings_pressed() -> void:
	help_panel.visible = false
	settings_panel.visible = !settings_panel.visible


func _on_help_pressed() -> void:
	settings_panel.visible = false
	help_panel.visible = !help_panel.visible


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_load_pressed() -> void:
	load_manager.load_data()
	menu_camera.zoom = player_camera.zoom
	menu_camera.global_position = player_camera.global_position
	player_camera.reset_smoothing()
	visible = false
	set_process(true)
