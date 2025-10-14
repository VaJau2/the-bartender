extends TextureRect

class_name PaidStamp

@export var paid_stamp: Texture2D
@export var unpaid_stamp: Texture2D


func put_stamp() -> void:
	if is_paid():
		texture = paid_stamp
	else:
		texture = unpaid_stamp


func is_paid() -> bool:
	return M.money >= G.MONEY_GOAL + M.debt
