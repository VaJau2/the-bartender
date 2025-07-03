extends Node

var money: int = 0

signal money_updated

func _ready() -> void:
	money = 0


func _process(_delta: float) -> void:
	if !OS.is_debug_build(): 
		set_process(false)
		return
	
	if Input.is_action_just_pressed("ui_home"):
		add_money(100)


func add_money(value: int) -> void:
	money += value
	money_updated.emit()


func remove_money(value: int) -> void:
	G.statistics.money_spent += value
	money -= value
	money_updated.emit()
