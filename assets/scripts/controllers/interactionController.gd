extends Node

class_name InteractionController

const INTERACTION_DISTANCE: float = 150
const INTERACTION_COOLDOWN: float = 0.1

@export var movement_controller: MovementController

# сигналы для интерфейса 
signal show_hint(code: String)
signal show_item_hint(item: Item)
signal hide_item_hint()

signal show_put_hint()
signal hide_put_hint()

signal pickup_item(item: Item)
signal clear_item()

signal close_menu()
signal open_crafting_menu(crafting: CraftingBase)
signal open_storage_menu(storage: Storage)


var holding_item: Item
var interaction_cooldown: float


func update_holding_item(item: Item) -> void:
	holding_item = item
	if item != null:
		pickup_item.emit(item)
	else:
		clear_item.emit()


func mouse_entered_item(item: CollisionObject2D) -> void:
	if !movement_controller.may_move: return
	if item.has_method("on_mouse_entered"):
		item.on_mouse_entered()


func mouse_exited_item(item: CollisionObject2D) -> void:
	if !movement_controller.may_move: return
	if item.has_method("on_mouse_exited"):
		item.on_mouse_exited()


func interact(item) -> void:
	if !movement_controller.may_move: return
	if interaction_cooldown > 0: return
	item.interact()
	interaction_cooldown = INTERACTION_COOLDOWN


func _process(delta: float) -> void:
	if interaction_cooldown > 0:
		interaction_cooldown -= delta
