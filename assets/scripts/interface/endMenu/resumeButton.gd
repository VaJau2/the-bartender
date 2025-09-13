extends Button

const statisticsCode: String = "statistics"
const financeCode: String = "financial_results"
@export var financePage: Control

func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	financePage.visible = !financePage.visible
	
	var code: String
	if (financePage.visible):
		code = statisticsCode
	else:
		code = financeCode
	
	text = Loc.trans("interface.resume." + code)
