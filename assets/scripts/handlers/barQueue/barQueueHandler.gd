extends Node2D

class_name BarQueueHandler

var queue_items: Array[BarQueueItem]

signal queue_updated

var ordering_npc: NPC


func _ready() -> void: 
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


func is_first_in_queue(npc: NPC) -> bool:
	for item in queue_items:
		if item.npc != null:
			return item.npc == npc
	return false
