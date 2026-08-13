extends Node

@export var furn_logic: Node


func get_unique_group_name() -> String:
	return get_parent().name


func get_save_data() -> Dictionary:
	var save_data = furn_logic.get_save_data()
	var furn: Node2D = get_parent()
	
	save_data["visible"] = var_to_str(furn.visible)
	save_data["parent_path"] = var_to_str(furn.get_parent().get_path())
	save_data["position"] = var_to_str(furn.global_position)
	save_data["process_mode"] = var_to_str(furn.process_mode)
	 
	return save_data


func load_save_data(data: Dictionary) -> void:
	var furn = get_parent()
	var parent_path = str_to_var(data.parent_path)
	var new_parent = get_node(parent_path)
	furn.get_parent().remove_child(furn)
	new_parent.add_child(furn)
	
	furn.visible = str_to_var(data.visible)
	furn.global_position = str_to_var(data.position)
	furn.process_mode = str_to_var(data.process_mode)
	
	furn_logic.load_save_data(data)
