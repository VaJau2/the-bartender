extends Node

class_name LoadManager

const FILE_PATH: String = "user://save_game.dat"

signal file_exist_event()


func _ready() -> void:
	var file_exists = FileAccess.file_exists(FILE_PATH)
	if file_exists:
		file_exist_event.emit()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_save"):
		save_data()
	if Input.is_action_just_pressed("ui_load"):
		load_data()


func save_data() -> void:
	var data = {
		"nodes": {},
		"spawned_items": {},
	}
	
	for node: Node in get_tree().get_nodes_in_group("save"):
		if !node.has_method("get_save_data"): continue
		var path = node.get_path()
		if node.is_in_group("spawned_item"):
			data["spawned_items"][path] = _get_spawned_item_data(node)
		else:
			data["nodes"][path] = node.get_save_data()
	
	var file = FileAccess.open_compressed(FILE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
	print("game saved")


func load_data() -> void:
	var file = FileAccess.open_compressed(FILE_PATH, FileAccess.READ)
	var data: Dictionary = JSON.parse_string(file.get_as_text())
	file.close()
	
	var items_to_spawn: Dictionary = data.spawned_items
	for node_path in items_to_spawn.keys():
		_load_spawned_item_data(items_to_spawn[node_path])
	
	var exist_nodes: Dictionary = data.nodes
	for node_path in exist_nodes.keys():
		var node_data = exist_nodes[node_path]
		var node = get_node(node_path)
		if node and node.has_method("load_save_data"):
			node.load_save_data(node_data)


func _get_spawned_item_data(item: Item) -> Dictionary:
	return {
		"data": item.get_save_data(),
		"parent": item.get_parent().get_path(),
		"name": item.name,
		"code": item.code,
		"position": var_to_str(item.global_position)
	}


func _load_spawned_item_data(data: Dictionary) -> void:
	var parent_path = data["parent"]
	var parent = get_node(parent_path)
	var item_pos = str_to_var(data["position"])
	var item = ItemSpawner.spawn_item(data["code"], item_pos, parent)
	item.name = data["name"]
	item.load_save_data(data["data"])
