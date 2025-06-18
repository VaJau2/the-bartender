extends Panel

class_name ItemHint

@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var name_label: Label = get_node("name")


func _ready() -> void:
	set_process(false)
	interaction_controller.show_item_hint.connect(_on_show_hint)
	interaction_controller.hide_item_hint.connect(_on_hide_hint)


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
	await get_tree().process_frame
	size.x = 72 + name_label.text.length() * 4.5
	visible = true
	set_process(true)


func _on_hide_hint() -> void:
	visible = false
