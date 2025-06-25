extends Label

@export var code: String


func _ready() -> void:
	text = str(G.statistics.get(code))
