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
signal open_bar_menu(menu: BarMenu)
signal open_recepies_menu

var interacting_item: Item # костыль для того, чтобы игнорировать putArea, когда на ней Item
var interaction_cooldown: float
var holding_item: Item


func _process(delta: float) -> void:
	if interaction_cooldown > 0:
		interaction_cooldown -= delta


func update_holding_item(item: Item) -> void:
	holding_item = item
	if item != null:
		var old_scale = item.global_scale
		item.get_parent().remove_child(item)
		add_child(item)
		item.global_scale = old_scale
		
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


func try_get_item(item: Item) -> bool:
	if G.player.using_storage:
		if G.player.storage_handler.can_put_item(item):
			item.taken.emit(item)
			item.disable()
			G.player.storage_handler.put_item(item)
			return true
		
	if holding_item == null:
		item.disable()
		update_holding_item(item)
		item.taken.emit(item)
		return true
	
	return false
