extends Node

class_name LoadingManager

const FILE_PATH: String = "user://save_game.dat"

var created_objects: Dictionary[int, Node]

var file_exist: bool


func _ready() -> void:
	file_exist = FileAccess.file_exists(FILE_PATH)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_save"):
		save_data()
	if Input.is_action_just_pressed("ui_load"):
		load_data()


func save_data() -> void:
	var data = {
		"nodes": {},
		"group_items": {},
		"spawned_items": {},
	}
	
	for node: Node in get_tree().get_nodes_in_group("save"):
		if !node.has_method("get_save_data"): continue
		var path = node.get_path()
		
		# сохранение наспавненных вещей
		if node.is_in_group("spawned_item"):
			data["spawned_items"][path] = _get_spawned_item_data(node)
			continue
		
		# сохранение радио, соковыжималки, кофемашины и тд
		if node.has_method("get_unique_group_name"):
			var group: String = node.get_unique_group_name()
			data["group_items"][group] = node.get_save_data()
			continue
		
		# сохранение всего остального
		data["nodes"][path] = node.get_save_data()
	
	var file = FileAccess.open_compressed(FILE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
	
	file_exist = true
	print("game saved")


func load_data() -> void:
	var file = FileAccess.open_compressed(FILE_PATH, FileAccess.READ)
	var data: Dictionary = JSON.parse_string(file.get_as_text())
	file.close()
	
	# загрузка наспавненных вещей
	var items_to_spawn: Dictionary = data.spawned_items
	for node_path in items_to_spawn.keys():
		_load_spawned_item_data(items_to_spawn[node_path])
	
	# загрузка радио, соковыжималки, кофемашины и тд
	var global_group_items: Dictionary = data.group_items
	for node_group in global_group_items.keys():
		var node_data = global_group_items[node_group]
		var node = get_tree().get_first_node_in_group(node_group)
		var node_load_manager = node.get_node_or_null("loadManager")
		if node_load_manager and node_load_manager.has_method("load_save_data"):
			node_load_manager.load_save_data(node_data)
	
	# загрузка всего остального
	var exist_nodes: Dictionary = data.nodes
	for node_path in exist_nodes.keys():
		var node_data = exist_nodes[node_path]
		var node = get_node(node_path)
		if node and node.has_method("load_save_data"):
			node.load_save_data(node_data)
	
	created_objects.clear()


func _get_spawned_item_data(item: Item) -> Dictionary:
	return {
		"data": item.get_save_data(),
		"parent": item.get_parent().get_path(),
		"code": item.code,
		"position": var_to_str(item.global_position)
	}


func _load_spawned_item_data(data: Dictionary) -> void:
	var parent_path = data["parent"]
	var parent = get_node(parent_path)
	var item_pos = str_to_var(data["position"])
	var item = ItemSpawner.spawn_item(data["code"], item_pos, parent)
	item.load_save_data(data["data"])
	created_objects[item.save_id] = item
