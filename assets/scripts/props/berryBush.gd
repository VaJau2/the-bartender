extends Node2D

const SPAWN_TIME_MIN: float = 100
const SPAWN_TIME_MAX: float = 150

@export var code: String

@onready var spawn_points: Array = get_node("spawn-points").get_children()

var spawned_items: Array[Item]
var spawn_timer: float


func _ready() -> void:
	spawn_items()
	set_process(false)


func _process(delta: float) -> void:
	if spawn_timer > 0:
		spawn_timer -= delta
	else:
		spawn_items()
		set_process(false)


func spawn_items() -> void:
	for point in spawn_points:
		if randf() < 0.8:
			var item = ItemSpawner.spawn_item(code, point.global_position, self)
			item.taken.connect(_on_item_taken)
			spawned_items.append(item)
	
	if spawned_items.is_empty():
		spawn_timer = randf_range(SPAWN_TIME_MIN, SPAWN_TIME_MAX)
		set_process(true)


func _on_item_taken(item: Item) -> void:
	spawned_items.erase(item)
	if spawned_items.is_empty():
		spawn_timer = randf_range(SPAWN_TIME_MIN, SPAWN_TIME_MAX)
		set_process(true)
