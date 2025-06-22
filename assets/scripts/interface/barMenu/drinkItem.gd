extends Panel

class_name BarDrinkMenuItem

@onready var label: Label = get_node("label")
@onready var button: Button = get_node("button")
@onready var price: LineEdit = get_node("price")

var item: BarMenuItem

signal on_click(item: BarDrinkMenuItem)


func set_item(new_item: BarMenuItem) -> void:
	item = new_item
	label.text = Loc.trans("items." + new_item.code + ".name")
	price.text = str(new_item.price)
	button.pressed.connect(_on_button_pressed)


func _on_button_pressed() -> void:
	on_click.emit(self)


func _on_price_text_changed(new_text: String) -> void:
	item.price = int(new_text)
