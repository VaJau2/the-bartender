extends Panel

@onready var volume_slider: HSlider = get_node("volume")


func _ready() -> void:
	volume_slider.value = AudioServer.get_bus_volume_linear(0)


func _on_lang_pressed() -> void:
	Loc.current_lang = Enums.Lang.ru \
		if Loc.current_lang == Enums.Lang.en \
		else Enums.Lang.en
	
	G.lang_changed.emit()


func _on_fullscreen_pressed() -> void:
	var on = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	
	DisplayServer.window_set_mode(\
		DisplayServer.WINDOW_MODE_WINDOWED if on\
		else DisplayServer.WINDOW_MODE_FULLSCREEN\
	)


func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, value)
	AudioServer.set_bus_mute(0, value == 0)
