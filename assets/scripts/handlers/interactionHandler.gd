extends Node

class_name InteractionHandler

const INTERACTION_DISTANCE: float = 200

signal show_item_hint(code: String)
signal hide_item_hint()

signal show_put_hint()
signal hide_put_hint()

signal pickup_item(item: Item)
signal clear_item()

var holding_item: Item


func mouse_entered_item(item: Item) -> void:
	show_item_hint.emit(item.code)


func mouse_exited_item() -> void:
	hide_item_hint.emit()


func mouse_entered_put_area() -> void:
	if holding_item == null: return
	show_put_hint.emit()


func mouse_exited_put_area() -> void:
	if holding_item == null: return
	hide_put_hint.emit()


func put_item(pos: Vector2, parent: Node2D) -> void:
	if holding_item == null: return
	var temp_scale = holding_item.global_scale
	holding_item.get_parent().remove_child(holding_item)
	parent.add_child(holding_item)
	holding_item.global_scale = temp_scale
	holding_item.process_mode = Node.PROCESS_MODE_INHERIT
	holding_item.visible = true
	holding_item.global_position = pos
	holding_item = null
	clear_item.emit()


func interact(item: Item) -> void:
	if holding_item == null:
		_interact_pickup(item)


func _interact_pickup(item: Item) -> void:
	holding_item = item
	item.visible = false
	item.process_mode = Node.PROCESS_MODE_DISABLED
	pickup_item.emit(item)
