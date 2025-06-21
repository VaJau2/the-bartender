extends Node

class_name InteractionController

const INTERACTION_COOLDOWN: float = 0.2
const INTERACTION_DISTANCE: float = 150

@export var movement_controller: MovementController

# сигналы для интерфейса 
signal show_hint(code: String)
signal show_item_hint(item: Item)
signal show_hint_text(text: String)
signal hide_item_hint()

signal show_put_hint()
signal hide_put_hint()

signal pickup_item(item: Item)
signal clear_item()

signal close_menu()
signal open_crafting_menu(crafting: CraftingBase)
signal open_storage_menu(storage: StorageHandler)
signal open_shop_menu(shop: MarketStand)

var interacting_item: Item # костыль для того, чтобы игнорировать putArea, когда на ней Item
var interaction_cooldown: float
var holding_item: Item


func _process(delta: float) -> void:
	if interaction_cooldown > 0:
		interaction_cooldown -= delta


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
	if item is Item:
		interacting_item = item


func mouse_exited_item(item: CollisionObject2D) -> void:
	if !movement_controller.may_move: return
	if item.has_method("on_mouse_exited"):
		item.on_mouse_exited()
	if item == interacting_item:
		interacting_item = null


func interact(item) -> void:
	if !movement_controller.may_move: return
	if interaction_cooldown > 0: return
	
	if interacting_item != null:
		interacting_item.interact()
		interacting_item = null
		interaction_cooldown = INTERACTION_COOLDOWN
		return
	
	item.interact()
