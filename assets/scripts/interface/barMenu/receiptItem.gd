extends Panel

class_name ReceiptBarMenuItem

@onready var label: Label = get_node("label")
@onready var button: Button = get_node("button")

var code

signal on_click(item: ReceiptBarMenuItem)


func set_code(new_code: String) -> void:
	code = new_code
	label.text = Loc.trans("items." + new_code + ".name")
	button.pressed.connect(_on_button_pressed)


func _on_button_pressed() -> void:
	on_click.emit(self)
