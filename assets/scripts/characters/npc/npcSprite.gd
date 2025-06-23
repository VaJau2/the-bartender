extends Sprite2D


func _ready() -> void:
	var code = get_parent().code
	texture = load("res://assets/sprites/characters/" + code + ".png")
