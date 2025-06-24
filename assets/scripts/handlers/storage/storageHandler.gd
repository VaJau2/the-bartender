extends Node

class_name StorageHandler

@export var storage_type: Enums.StorageType
@export var interaction_controller: InteractionController
@export var area: StorageArea
@export var code: String
@export var weight: int

var items: Array[StorageItem]


func _ready() -> void:
	if interaction_controller == null:
		interaction_controller = G.player.interaction_controller
	G.player.move_items_from_bag.connect(_on_move_items_to_bag)


func put_holding_item() -> void:
	var item = interaction_controller.holding_item
	if weight > 0 and !can_put_item(item): return
	
	put_item(item)
	interaction_controller.update_holding_item(null)


func put_item(item: Item) -> void:
	var item_data = StorageItem.new(item.code, item.category, item.limit)
	items.append(item_data)
	item.queue_free()


func can_put_item(item: Item) -> bool:
	return weight > (get_items_weight() + item.weight)


func get_item(item_code: String) -> void:
	for i in range(len(items)):
		if items[i].code == item_code:
			items.remove_at(i)
			break
	
	var item = ItemSpawner.spawn_item(item_code, get_parent().global_position, get_node("/root/main"))
	
	if storage_type == Enums.StorageType.bag:
		item.get_parent().remove_child(item)
		get_node("/root/main").add_child(item)
		item.global_position = get_parent().global_position
		item.moving.set_velocity(Vector2(_rand_speed(), _rand_speed()))
	else:
		item.disable()
		interaction_controller.update_holding_item(item)


func close() -> void:
	if area != null: area.close()


func get_items_weight() -> float:
	var json_data = JsonParse.read("res://assets/json/data/items.json")
	var items_weight = 0
	
	for item_data in items:
		if json_data.has(item_data.code):
			items_weight += json_data[item_data.code].weight
		
	return items_weight


func _rand_speed() -> float:
	var speed = randf_range(40, 60)
	return speed if randf() > 0.5 else -speed


func _on_move_items_to_bag() -> void:
	if storage_type == Enums.StorageType.bag && len(items) > 0:
		get_node("audi").play()
		return
	
	var items_moved = []
	var json_data = JsonParse.read("res://assets/json/data/items.json")
	
	for item: StorageItem in G.player.storage_handler.items:
		var needs_fridge = json_data[item.code].has("needs_fridge")
		
		if needs_fridge and storage_type != Enums.StorageType.fridge: continue
		if !needs_fridge and storage_type == Enums.StorageType.fridge: continue
		items_moved.append(item)
		items.append(item)
	
	for item in items_moved:
		G.player.storage_handler.items.erase(item)
