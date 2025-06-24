extends Area2D

const SPAWN_TIME_MIN: float = 150
const SPAWN_TIME_MAX: float = 250

@onready var interaction_controller: InteractionController = G.player.interaction_controller
@export var sprite: Sprite2D
@export var code: String

var has_item: bool = true
var spawn_timer: float


func _ready() -> void:
	set_process(false)


func _process(delta: float) -> void:
	if spawn_timer > 0:
		spawn_timer -= delta
	else:
		sprite.visible = true
		has_item = true
		set_process(false)


func on_mouse_entered() -> void:
	if !has_item or interaction_controller.holding_item != null: return
	interaction_controller.show_hint.emit(code)


func on_mouse_exited() -> void:
	interaction_controller.hide_item_hint.emit()


func interact() -> void:
	if !has_item or interaction_controller.holding_item != null: return
	
	var item = ItemSpawner.spawn_item(code, global_position, get_parent())
	item.disable()
	
	if !interaction_controller.try_get_item(item):
		item.queue_free()
		return
	
	sprite.visible = false
	has_item = false
	spawn_timer = randf_range(SPAWN_TIME_MIN, SPAWN_TIME_MAX)
	set_process(true)
