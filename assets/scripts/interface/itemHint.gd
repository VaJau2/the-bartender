extends Panel

class_name ItemHint

@onready var main: Node2D = get_node('/root/main')
@onready var name_label: Label = get_node("name")


func _ready() -> void:
	set_process(false)


func _process(_delta: float) -> void:
	if !visible:
		set_process(false)
		return
	_update_pos()


func _update_pos() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	position = mouse_pos + Vector2(20, 20)


func show_item_hint(item_code: String) -> void:
	name_label.text = Loc.trans("items." + item_code + ".name")
	visible = true
	set_process(true)


func hide_item_hint() -> void:
	visible = false
