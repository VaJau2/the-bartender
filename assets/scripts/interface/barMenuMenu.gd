extends Panel

class_name BarMenuMenu

@onready var movement_controller: MovementController = G.player.movement_controller
@onready var interaction_controller: InteractionController = G.player.interaction_controller

var temp_menu: BarMenu


func _ready() -> void:
	interaction_controller.open_bar_menu.connect(_on_open_menu)
	interaction_controller.close_menu.connect(_on_close_pressed)


func _process(_delta: float) -> void:
	if !visible: return
	if Input.is_action_just_pressed("ui_cancel"):
		_on_close_pressed()


func _on_open_menu(menu: BarMenu) -> void:
	visible = true
	movement_controller.may_move = false
	temp_menu = menu


func _on_close_pressed() -> void:
	visible = false
	movement_controller.may_move = true
