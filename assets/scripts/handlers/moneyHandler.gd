extends Node

const DEBT_DAYS: int = 2

var money: int = 0
var debt: int = 0
var debt_days: int = DEBT_DAYS

signal money_updated
signal debt_updated


func _ready() -> void:
	money = 0
	debt = 0


func _process(_delta: float) -> void:
	if !OS.is_debug_build(): 
		set_process(false)
		return
	
	if Input.is_action_just_pressed("ui_home"):
		add_money(100)


func add_money(value: int) -> void:
	money += value
	
	if money >= G.MONEY_GOAL && !G.statistics.is_loan_paid:
		G.statistics.is_loan_paid = true 
	
	money_updated.emit()


func remove_money(value: int) -> void:
	money -= value
	
	if money < G.MONEY_GOAL && G.statistics.is_loan_paid:
		G.statistics.is_loan_paid = false 
	
	money_updated.emit()


func add_debt(value: int) -> void:
	debt += value
	debt_days = DEBT_DAYS
	debt_updated.emit()


func remove_debt() -> void:
	debt = 0
	debt_updated.emit()
