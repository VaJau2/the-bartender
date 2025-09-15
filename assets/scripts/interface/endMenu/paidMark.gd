extends TextureRect

class_name PaidMark

@export var paid_mark: Texture2D
@export var unpaid_mark: Texture2D


func calculate() -> void:
	if M.money >= G.MONEY_GOAL + M.debt:
		texture = paid_mark
	else:
		texture = unpaid_mark
