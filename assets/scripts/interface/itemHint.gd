extends Panel

class_name ItemHint

@onready var interaction_handler: InteractionHandler = G.player.interaction_handler
@onready var name_label: Label = get_node("name")


func _ready() -> void:
	set_process(false)
	interaction_handler.show_item_hint.connect(_on_show_hint)
	interaction_handler.hide_item_hint.connect(_on_hide_hint)


func _process(_delta: float) -> void:
	if !visible:
		set_process(false)
		return
	_update_pos()


func _update_pos() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	position = mouse_pos + Vector2(20, 20)


func _on_show_hint(item_code: String) -> void:
	name_label.text = Loc.trans("items." + item_code + ".name")
	visible = true
	set_process(true)


func _on_hide_hint() -> void:
	visible = false
