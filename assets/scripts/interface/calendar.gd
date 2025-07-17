extends Control

class_name Calendar

var day_icons: Array[DayIcon]


func _ready() -> void:
	G.time.day_tick.connect(_on_day_tick)
	
	for child:DayIcon in get_children():
		day_icons.push_back(child)
	
	var shown_count = get_child_count()
	while shown_count > G.DAYS_GOAL:
		day_icons[shown_count - 1].visible = false
		shown_count -= 1
	
	if G.time.day > 0:
		for day in range(G.time.day):
			_mark_day(day - 1)


func _on_day_tick() -> void:
	_mark_day(G.time.day - 1)


func _mark_day(day: int) -> void:
	day_icons[day].set_mark(true)
