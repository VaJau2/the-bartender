extends Node


func _ready() -> void:
	G.statistics.reset()
	G.time.day_tick.connect(_on_day_tick)


func _on_day_tick() -> void:
	var days_left = G.DAYS_GOAL - G.time.day
	if days_left == 0:
		if M.money >= G.MONEY_GOAL:
			S.goto_scene("Win")
		else:
			S.goto_scene("Lost")
