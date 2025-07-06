extends Panel

class_name RadioMenu

signal changed_volume

@onready var movement_controller: MovementController = G.player.movement_controller
@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var pause_menu: PauseMenu = get_tree().get_first_node_in_group("pause_menu")
@onready var name_label: Label = get_node("name")

func _ready() -> void:
	get_node("volume").value = G.settings.music_volume
	interaction_controller.show_radio_menu.connect(_on_open_menu)

func _process(_delta: float) -> void:
	if !visible: return
	if Input.is_action_just_pressed("ui_cancel"):
		_on_cancel_pressed()

func _on_open_menu() -> void:
	visible = true
	pause_menu.may_pause = false
	movement_controller.may_move = false
	name_label.text = Loc.trans("items.radio.name")

func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(1, value)
	AudioServer.set_bus_mute(1, value == 0)
	G.settings.music_volume = value
	changed_volume.emit()
	
func _on_cancel_pressed() -> void:
	visible = false
	movement_controller.may_move = true
	await get_tree().process_frame
	pause_menu.may_pause = true
