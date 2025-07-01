extends Node

var money: int = 0

signal money_updated


func add_money(value: int) -> void:
	money += value
	money_updated.emit()


func remove_money(value: int) -> void:
	G.statistics.money_spent += value
	money -= value
	money_updated.emit()
