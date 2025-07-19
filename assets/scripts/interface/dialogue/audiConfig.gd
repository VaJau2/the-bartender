extends Node

#--------------------------------
# Отвечает за настройки "голоса" в диалогах
#--------------------------------

class_name AudiConfig

var temp_code: String = ""
var sounds: Array = []
var min_pitch: float = 0.5
var max_pitch: float = 3
var chars_to_sound: int = 3


func load_from_file(code: String) -> void:
	if temp_code == code: return
	
	var json_path = "res://assets/json/data/audi_configs.json"
	var configs_data: Dictionary = JsonParse.read(json_path)
	
	var config = configs_data[code]
	for sound in config.sounds:
		var sound_path = "res://assets/audio/dialogue/" + sound
		sounds.append(load(sound_path))
	min_pitch = float(config.min_pitch)
	max_pitch = float(config.max_pitch)
	chars_to_sound = int(config.chars_to_sound)
	temp_code = code
