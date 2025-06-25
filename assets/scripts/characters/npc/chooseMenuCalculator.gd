class_name ChooseCalculator

const max_chance = 0.9
const min_chance = 0.5

var min_value: float
var max_value: float


func _init(new_min: float, new_max: float) -> void:
	min_value = new_min
	max_value = new_max


func calculate(value: float) -> float:
	if min_value == max_value: return 0
	
	var a = (min_chance - max_chance) / (max_value - min_value)
	var b = max_chance - a * min_value
	
	var result = a * value + b
	return clamp(result, 0, 1)
