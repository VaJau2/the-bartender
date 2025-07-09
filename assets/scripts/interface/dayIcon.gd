extends Panel

class_name DayIcon

@export var code: String
@onready var label: Label = get_node("label")
@onready var xIcon: TextureRect = get_node("X")


func _ready() -> void:
	G.lang_changed.connect(_update_label)
	_update_label()


func set_mark(value: bool):
	xIcon.visible = value


func _update_label():
	label.text = Loc.trans("interface.time." + code)
