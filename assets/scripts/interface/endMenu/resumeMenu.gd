extends Control

class_name ResumeMenu

const STATISTICS_CODE: String = "statistics"
const FINANCE_CODE: String = "financial_results"

@export var interface: Control
@export var pause_menu: PauseMenu
@export var statistics_count_labels: Array[StatisticsCountLabel]
@export var paid_mark: PaidMark
@export var drinks_table: DrinksTable
@export var finance_page: Control
@export var continue_button: Button
@export var resume_button: Button


func _ready() -> void:
	continue_button.pressed.connect(hide_resume)
	resume_button.pressed.connect(change_page)


func show_resume() -> void:
	interface.visible = false
	pause_menu.may_pause = false
	visible = true
	
	for label in statistics_count_labels:
		label.calculate()
		
	paid_mark.calculate()
	drinks_table._ready()
	resume_button.text = Loc.trans("interface.resume." + STATISTICS_CODE)
	Engine.time_scale = 1
	get_tree().paused = true


func hide_resume() -> void:
	get_tree().paused = false
	S.goto_scene("Main")


func change_page() -> void:
	finance_page.visible = !finance_page.visible
	
	var code: String
	if (finance_page.visible):
		code = STATISTICS_CODE
	else:
		code = FINANCE_CODE
	
	resume_button.text = Loc.trans("interface.resume." + code)
