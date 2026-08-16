extends Node

const DEBT_DAYS: int = 2

var money: int = 0
var debt: int = 0
var debt_days: int = DEBT_DAYS

signal money_updated
signal money_force_updated
signal debt_updated


func _ready() -> void:
	add_to_group("save")
	money = 0
	debt = 0


func _process(_delta: float) -> void:
	if !OS.is_debug_build(): 
		set_process(false)
		return
	
	if Input.is_action_just_pressed("ui_home"):
		add_money(1000)


func add_money(value: int) -> void:
	money += value
	money_updated.emit()


func remove_money(value: int) -> void:
	money -= value
	money_updated.emit()


func add_debt(value: int) -> void:
	debt += value
	debt_days = DEBT_DAYS
	debt_updated.emit()


func remove_debt() -> void:
	debt = 0
	debt_updated.emit()


func get_save_data() -> Dictionary:
	return {
		"money": money,
		"debt": debt,
		"debt_days": debt_days
	}


func load_save_data(data: Dictionary) -> void:
	money = data.money
	debt = data.debt
	debt_days = data.debt_days
	money_force_updated.emit()
