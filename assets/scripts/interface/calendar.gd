extends Control

class_name Calendar

var day_icons: Array[DayIcon]


func _ready() -> void:
	G.time.day_tick.connect(mark_day)
	
	for child:DayIcon in get_children():
		day_icons.push_back(child)
		
	var shown_count = get_child_count()
	while shown_count > G.DAYS_GOAL:
		day_icons[shown_count - 1].visible = false
		shown_count -= 1


func mark_day() -> void:
	day_icons[G.time.day - 1].set_mark(true)
