extends Node2D

class_name BarQueueHandler

@onready var bar_front_area: PutArea = get_tree().get_first_node_in_group("bar_front_area")
var queue_items: Array[BarQueueItem]

signal queue_updated


func _ready() -> void:
	bar_front_area.put_item.connect(_on_put_front_item)
	for point in get_children():
		var item = BarQueueItem.new()
		item.point = point
		item.npc = null
		queue_items.append(item)


func has_free_point() -> bool:
	for item in queue_items:
		if item.npc == null: return true
	return false


func get_free_point(npc: NPC) -> Vector2:
	for item in queue_items:
		if item.npc == null: 
			item.npc = npc
			return item.point.global_position
	return Vector2.ZERO


func erase_from_queue(npc: NPC) -> void:
	for item in queue_items:
		if item.npc == npc:
			item.npc = null
			queue_updated.emit()


func is_in_queue(npc: NPC) -> bool:
	for item in queue_items:
		if item.npc == npc: return true
	return false


func _on_put_front_item(item: Item) -> void:
	for queue_item in queue_items:
		if queue_item.npc != null:
			var check_result = queue_item.npc.interaction.check_ordered_drink(item)
			if check_result:
				break


func get_save_data() -> Dictionary:
	var items_npc = []
	
	for item in queue_items:
		var npc_path = null
		if item.npc: npc_path = item.npc.get_path()
		items_npc.append(npc_path)
	
	return {
		"items": items_npc
	}


func load_save_data(data: Dictionary) -> void:
	for i in range(len(queue_items)):
		var item_npc_path = data.items[i]
		if item_npc_path == null: continue
		var item = queue_items[i]
		item.npc = get_node(item_npc_path)
