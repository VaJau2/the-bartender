extends Panel

@onready var menu: RecipesMenu = get_node("../")
@onready var header: Label = get_node("name")


func _ready() -> void:
	menu.show_hint.connect(_show_hint)
	menu.hide_hint.connect(_on_hide_hint)


func _process(_delta: float) -> void:
	if !visible:
		set_process(false)
		return
	_update_pos()


func _update_pos() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	position = mouse_pos - Vector2(375, 180)


func _show_hint(code: String) -> void:
	visible = true
	header.text = code
	set_process(true)


func _on_hide_hint() -> void:
	visible = false
