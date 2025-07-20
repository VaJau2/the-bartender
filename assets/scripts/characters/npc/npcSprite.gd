extends Sprite2D

@export var add_name: String = ""


func _ready() -> void:
	var path: String
	
	if add_name != "":
		path = "res://assets/sprites/characters/" + get_parent().code + add_name + ".png"
		if !ResourceLoader.exists(path):
			path = "res://assets/sprites/characters/pinkie_mouth.png"
	else:
		path = "res://assets/sprites/characters/" + get_parent().code + ".png"
	
	texture = load(path)
