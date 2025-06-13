extends Node2D

class_name MaterialChecker

@export var parent: CharacterBody2D

signal material_changed(material: Enums.Materials)

var current_material: Enums.Materials
var current_floor: TileMapLayer


func _ready() -> void:
	current_material = get_new_material()
	material_changed.emit(current_material)


func _process(_delta: float) -> void:
	if parent != null && parent.velocity.length() == 0:
		return
	
	var new_material = get_new_material()
	if new_material != null and current_material != new_material:
		current_material = new_material
		material_changed.emit(current_material)


func get_new_material() -> Enums.Materials:
	if current_floor == null:
		current_floor = get_first_floor()
	
	var local_pos = current_floor.to_local(global_position)
	var map_pos = current_floor.local_to_map(local_pos)
	var tile_data = current_floor.get_cell_tile_data(map_pos)
	
	if tile_data == null:
		current_floor = null
		return current_material
	
	var temp_material = tile_data.get_custom_data("material")
	return Enums.Materials[temp_material]


func get_first_floor() -> TileMapLayer:
	var floors = get_tree().get_nodes_in_group("floor")
	if len(floors) == 0:
		return null
	return floors[0]
	#var min_distance = global_position.distance_to(floors[0].global_position)
	#floors.remove_at(0)
	#for temp_floor in floors:
		#var other_distance = global_position.distance_to(temp_floor.global_position)
		#if other_distance < min_distance:
			#min_distance = other_distance
			#closest_floor = temp_floor
	#return closest_floor
	
