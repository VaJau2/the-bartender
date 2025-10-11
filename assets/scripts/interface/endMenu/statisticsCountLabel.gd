extends Label

class_name StatisticsCountLabel

@export var code: String
@export var method: Method
@export var unit: Unit

const SPEED: Array[float] = [0.1, 1, 5]
const SPEED_MULTIPLY: int = 6

var stat_text: Array[String]
var stat_numbers: Array[float]
var anim_numbers: Array[float]
var calculaitng_speed: Array[float]
var done: Array[bool]

signal calculating_done(with_delay: bool, play_stamp_sound: bool)


func _ready() -> void:
	set_physics_process(false)
	process_mode = Node.PROCESS_MODE_ALWAYS

func _physics_process(_delta: float) -> void:
	var done_amount: int = 0
	for i in stat_numbers.size():
		if done[i]:
			done_amount += 1
			continue
		
		if anim_numbers[i] < stat_numbers[i]:
			anim_numbers[i] += calculaitng_speed[i]
			anim_numbers[i] = snapped(anim_numbers[i], 0.01)
		else:
			anim_numbers[i] = stat_numbers[i]
			done_amount += 1
			done[i] = true
	
	_apply_unit(anim_numbers)
	
	if done_amount == done.size():
		set_physics_process(false)
		calculating_done.emit(true, false)


func calculate() -> void:
	_get_values()
	
	if stat_numbers.size() > 0:
		if stat_numbers[0] > 0:
			for i in stat_numbers.size():
				var speed = _calculate_speed(stat_numbers[i])
				calculaitng_speed.push_back(speed)
				anim_numbers.push_back(0)
				done.push_back(false)
			set_physics_process(true)
		else:
			_apply_unit(stat_numbers)
			calculating_done.emit(false, false)
	else:
		_apply_unit(stat_text)
		calculating_done.emit(false, true)


func _calculate_speed(value: float) -> float:
	var index: int = 0
	
	while int(value / 10) != 0:
		value = int(value / 10)
		index += 1
	
	if index < SPEED.size():
		return SPEED[index]
	else:
		index -= SPEED.size()
		return SPEED_MULTIPLY * index + SPEED[SPEED.size() - 1]


func _get_values() -> void:
	match method:
		Method.None:
			var value = G.statistics.get(code)
			if value is ItemStats:
				stat_numbers.push_back(value.amount)
				stat_numbers.push_back(value.profit)
			else:
				value = float(str(value))
				stat_numbers.push_back(value)
		Method.GetTotal:
			var value = G.statistics.get(code)
			value = G.statistics.get_total(value)
			stat_numbers.push_back(value)
		Method.GetAverage:
			var value = G.statistics.get(code)
			if value.size() > 0:
				value = snapped(G.statistics.get_average(value), 0.01)
				stat_numbers.push_back(value)
			else:
				stat_text.push_back("0.0")
		Method.GetMax:
			var value = G.statistics.get(code)
			value = G.statistics.get_max(value)
			stat_numbers.push_back(value)
		Method.GetMostSoldDrink:
			var value = G.statistics.get_most_sold_drink()
			if value != "":
				stat_text.push_back(Loc.trans("items." + value + ".name"))
			else:
				stat_text.push_back("None")
		Method.GetMostProfitDrink:
			var value = G.statistics.get_most_profit_drink()
			if value != "":
				stat_text.push_back(Loc.trans("items." + value + ".name"))
			else:
				stat_text.push_back("None")


func _apply_unit(values: Array) -> void:
	values = _try_covert_to_int(values)
	
	match unit:
		Unit.x:
			text = "x" + values[0]
		Unit.B:
			text = values[0] + " B"
		Unit.xB:
			text = "x" + values[0] + " (" + values[1] + " B)"
		Unit.sec:
			text = values[0] + " " + Loc.trans("interface.resume.seconds")
		Unit.None:
			text = values[0]

# где это возможно конвертирует 0.0 в 0
func _try_covert_to_int(values: Array) -> Array:
	if values[0] is String:
		return values
	
	var result: Array
	
	for value in values:
		var int_value = int(value)
		if int_value == value:
			result.push_back(str(int_value))
		else:
			result.push_back(str(value))
	
	return result


enum Method {
	None,
	GetTotal,
	GetAverage,
	GetMax,
	GetMostSoldDrink,
	GetMostProfitDrink
}

enum Unit {
	x,
	B,
	xB,
	sec,
	None
}
