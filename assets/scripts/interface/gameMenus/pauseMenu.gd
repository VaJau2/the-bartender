extends Control

class_name PauseMenu

@onready var settings_panel: Panel = get_node("menu/settingsPanel")

var may_pause: bool

func _process(_delta: float) -> void:
	if !may_pause: return
	if Input.is_action_just_pressed("ui_cancel"):
		visible = !visible
		get_tree().paused = visible


func _on_continue_pressed() -> void:
	visible = false
	get_tree().paused = false


func _on_settings_pressed() -> void:
	settings_panel.visible = !settings_panel.visible


func _on_exit_pressed() -> void:
	get_tree().quit()
