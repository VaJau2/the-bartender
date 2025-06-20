extends Node

class_name StorageHandler

@export var storage_type: Enums.StorageType
@export var interaction_controller: InteractionController
@export var area: StorageArea
@export var code: String
@export var weight: int

var items: Array[Item]


func _ready() -> void:
	if interaction_controller == null:
		interaction_controller = G.player.interaction_controller
	G.player.update_using_storage.connect(_on_update_using_storage)


func put_holding_item() -> void:
	var item = interaction_controller.holding_item
	
	if weight > 0 and !can_put_item(item): return
	
	put_item(item)
	interaction_controller.update_holding_item(null)


func put_item(item: Item) -> void:
	items.append(item)


func can_put_item(item: Item) -> bool:
	return weight > (get_items_weight() + item.weight)


func get_item(item: Item) -> void:
	items.erase(item)
	
	if storage_type == Enums.StorageType.bag:
		item.get_parent().remove_child(item)
		get_node("/root/main").add_child(item)
		item.global_position = get_parent().global_position
		item.moving.set_velocity(Vector2(_rand_speed(), _rand_speed()))
		item.enable()
	else:
		interaction_controller.update_holding_item(item)


func close() -> void:
	if area != null: area.close()


func get_items_weight() -> float:
	var items_weight = 0
	
	for item in items:
		items_weight += item.weight
		
	return items_weight


func _rand_speed() -> float:
	var speed = randf_range(40, 60)
	return speed if randf() > 0.5 else -speed


func _on_update_using_storage(value: bool) -> void:
	if value: return
	
	if storage_type == Enums.StorageType.bag && len(items) > 0:
		get_node("audi").play()
		return
	
	for item in G.player.storage_handler.items:
		if item.needs_fridge and storage_type != Enums.StorageType.fridge: continue
		if !item.needs_fridge and storage_type == Enums.StorageType.fridge: continue
		G.player.storage_handler.items.erase(item)
		items.append(item)
