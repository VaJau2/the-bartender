extends Node

class_name BaseCharacterSaveManager

@onready var parent: CharacterBody2D = get_parent()
@onready var animation_controller: AnimationController = get_node("../animationController")
@export var savable_nodes: Array[Node]


func get_save_data() -> Dictionary:
	var savable_nodes_data: Dictionary = {}
	
	for node in savable_nodes:
		savable_nodes_data[node.name] = {}
		
		for property_name in node.get_save_props():
			savable_nodes_data[node.name][property_name] = node.get(property_name)
	
	return {
		'savable_nodes': JSON.stringify(savable_nodes_data),
		'pos': var_to_str(parent.global_position),
		'flip_x': animation_controller.flip_x
	}


func load_save_data(data: Dictionary) -> void:
	parent.global_position = str_to_var(data.pos)
	animation_controller.set_flip(data.flip_x)
	
	var nodes_data: Dictionary = JSON.parse_string(data.savable_nodes)
	for node in savable_nodes:
		if nodes_data.has(node.name):
			for property_name in node.get_save_props():
				node.set(property_name, nodes_data[node.name][property_name])
