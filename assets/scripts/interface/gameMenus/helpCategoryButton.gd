extends Button

@export var my_label: Label


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	my_label.visible = !my_label.visible
