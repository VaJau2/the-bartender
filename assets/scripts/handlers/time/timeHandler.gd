extends Node

class_name TimeHandler

@export var hour: int
@export var minute: int
var minute_delta: float

signal hour_tick
signal minute_tick


func get_time_formatted() -> String:
	var result = ""
	if hour < 10:
		result += "0"
	
	result += str(hour) + ":"
	
	if minute < 10:
		result += "0"
	
	return result + str(int(minute))


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"): minute += 10
	
	if minute_delta < 1:
		minute_delta += delta
		return
	
	minute += 1
	minute_delta = 0
	
	if minute == 60:
		minute = 0
		
		if hour < 23:
			hour += 1
		else:
			hour = 0
		
		hour_tick.emit()
	
	minute_tick.emit()
