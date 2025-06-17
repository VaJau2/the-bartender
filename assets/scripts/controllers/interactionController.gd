extends Node

class_name InteractionController

const INTERACTION_DISTANCE: float = 200
const INTERACTION_COOLDOWN: float = 0.1

# сигналы для интерфейса 
signal show_item_hint(code: String)
signal hide_item_hint()

signal show_put_hint()
signal hide_put_hint()

signal pickup_item(item: Item)
signal clear_item()

var holding_item: Item
var interaction_cooldown: float


func mouse_entered_item(item: CollisionObject2D) -> void:
	if item.has_method("on_mouse_entered"):
		item.on_mouse_entered()


func mouse_exited_item(item: CollisionObject2D) -> void:
	if item.has_method("on_mouse_exited"):
		item.on_mouse_exited()


func interact(item) -> void:
	if interaction_cooldown > 0: return
	item.interact()
	interaction_cooldown = INTERACTION_COOLDOWN


func _process(delta: float) -> void:
	if interaction_cooldown > 0:
		interaction_cooldown -= delta
