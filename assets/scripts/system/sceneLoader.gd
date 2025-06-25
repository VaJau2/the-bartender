extends Node

class_name SceneLoader

var current_scene: Node


func _ready() -> void: 
	var children_count = get_tree().get_root().get_child_count()
	current_scene = get_tree().get_root().get_child(children_count - 1)


func goto_scene(scene: String) -> void:
	call_deferred("_deferred_goto_scene", "res://scenes/" + scene + ".tscn")


func _deferred_goto_scene(path: String) -> void:
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instantiate()
	current_scene.tree_entered.connect(_on_tree_entered)
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)


func _on_tree_entered() -> void:
	G._ready()
	current_scene.tree_entered.disconnect(_on_tree_entered)
