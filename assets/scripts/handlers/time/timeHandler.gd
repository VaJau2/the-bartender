extends Node

class_name TimeHandler

@export var hour: int
@export var minute: int
var day: int

var minute_delta: float

signal hour_tick
signal minute_tick
signal day_tick


func get_time_formatted() -> String:
	var result = ""
	if hour < 10:
		result += "0"
	
	result += str(hour) + ":"
	
	if minute < 10:
		result += "0"
	
	return result + str(int(minute))


func _process(delta: float) -> void:
	if minute_delta < 1:
		minute_delta += delta
		return
	
	minute += 1
	minute_delta = 0
	
	if minute >= 60:
		minute = 0
		
		if hour < 23:
			hour += 1
		else:
			hour = 0
			day += 1
			day_tick.emit()
		
		hour_tick.emit()
	
	minute_tick.emit()
