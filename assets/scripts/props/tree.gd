extends CollisionObject2D

const SPAWN_TIME_MIN: float = 150
const SPAWN_TIME_MAX: float = 200

@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var audi: AudioStreamPlayer2D = get_node("audi")

@export var fruits_parent: Node2D
@export var anim: AnimationPlayer
@export var code: String
@export var fruit_code: String
@export var hit_sound: AudioStream
@export var fall_sound: AudioStream

@onready var fruit_sprites: Array = fruits_parent.get_children()
var spawned_items: Array
var has_fruits: bool
var may_interact: bool = true

var spawn_timer: float


func _ready() -> void:
	spawn_fruits()
	set_process(false)


func _process(delta: float) -> void:
	if spawn_timer > 0:
		spawn_timer -= delta
	else:
		anim.play("RESET")
		spawn_fruits()
		set_process(false)


func spawn_fruits() -> void:
	for spawned_item in spawned_items:
		if spawned_item != null: spawned_item.queue_free()
	spawned_items.clear()
	
	for fruit in fruit_sprites:
		fruit.visible = randf() < 0.8
		if fruit.visible: has_fruits = true


func on_mouse_entered() -> void:
	if !may_interact or !has_fruits: return
	interaction_controller.show_hint.emit(code)


func on_mouse_exited() -> void:
	interaction_controller.hide_item_hint.emit()


func interact() -> void:
	if !may_interact or !has_fruits: return
	may_interact = false
	anim.play("shake")
	audi.stream = hit_sound
	audi.play()
	await anim.animation_finished
	if randf() < 0.3:
		anim.play("fall")
		audi.stream = fall_sound
		audi.play()
		await anim.animation_finished
		for fruit in fruit_sprites:
			if fruit.visible: 
				var item = ItemSpawner.spawn_item(fruit_code, fruit.global_position, get_parent())
				item.taken.connect(_on_item_taken)
				spawned_items.append(item)
			fruit.visible = false
		
		has_fruits = false
		spawn_timer = randf_range(SPAWN_TIME_MIN, SPAWN_TIME_MAX)
		set_process(true)
		
	may_interact = true


func _on_item_taken(item: Item) -> void:
	if spawned_items.has(item):
		spawned_items.erase(item)
		if item.code == "apple":
			G.statistics.apples_stolen += 1
