extends TextureRect

@export var paid_mark: Texture2D
@export var unpaid_mark: Texture2D

func _ready() -> void:
	if G.statistics.is_loan_paid:
		texture = paid_mark
	else:
		texture = unpaid_mark
