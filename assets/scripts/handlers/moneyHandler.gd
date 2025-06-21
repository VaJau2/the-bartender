extends Node

var money: int = 0

signal money_updated


func add_money(value: int) -> void:
	money += value
	money_updated.emit()



func remove_money(value: int) -> void:
	money -= value
	money_updated.emit()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		add_money(50)
