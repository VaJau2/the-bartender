extends Area2D

class_name PutArea

@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var main: Node2D = get_node("/root/main")
var may_interact: bool

signal put_item(item: Item)


func on_mouse_entered() -> void:
	if interaction_controller.holding_item == null: return
	interaction_controller.show_put_hint.emit()


func on_mouse_exited() -> void:
	interaction_controller.hide_put_hint.emit()


func interact() -> void:
	var item_to_put = interaction_controller.holding_item
	if item_to_put == null: 
		return
	var temp_scale = item_to_put.global_scale
	item_to_put.get_parent().remove_child(item_to_put)
	add_child(item_to_put)
	item_to_put.global_scale = temp_scale
	item_to_put.enable()
	item_to_put.global_position = main.get_global_mouse_position()
	interaction_controller.update_holding_item(null)
	if !item_to_put.try_spawn_furn():
		if !item_to_put.crafted.is_connected(item_crafted):
			item_to_put.crafted.connect(item_crafted)
		if !item_to_put.taken.is_connected(item_taken):
			item_to_put.taken.connect(item_taken)
		
		put_item.emit(item_to_put)


func find_item(code: String) -> Item:
	for child in get_children():
		if !child is Item: continue
		if child.code == code:
			return child
	return null


func item_taken(item: Item) -> void:
	if !item.crafted.is_connected(item_crafted):
		item.crafted.disconnect(item_crafted)


func item_crafted(item: Item) -> void:
	put_item.emit(item)
