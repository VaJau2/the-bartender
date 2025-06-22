extends Button

class_name ShopButton

@onready var interaction_controller: InteractionController = G.player.interaction_controller

var item: ShopItem

signal on_click(item: ShopItem)


func _on_pressed() -> void:
	on_click.emit(item)


func _on_mouse_entered() -> void:
	var item_text = Loc.trans("items." + item.code + ".name")
	item_text += " - " + str(item.price) + " " + Loc.get_plural(item.price, "bits")
	interaction_controller.show_hint_text.emit(item_text)


func _on_mouse_exited() -> void:
	interaction_controller.hide_item_hint.emit()
