extends VBoxContainer

class_name DrinksTable

@onready var drinkStats = load("res://objects/interface/drinkStatistics.tscn")

func _ready() -> void:
	if (G.statistics.drinks_stats.size() < 1):
		visible = false
		return
	else:
		reset()
		visible = true
	
	for code in G.statistics.drinks_stats.keys():
		var drinkStats_instance = drinkStats.instantiate()
		add_child(drinkStats_instance)
		drinkStats_instance.init(code)


func reset() -> void:
	for i in range(2, get_child_count()):
		get_child(i).queue_free()
