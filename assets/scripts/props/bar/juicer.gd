extends CraftingBase

const WORK_TIME: float = 3

@onready var audi: AudioStreamPlayer2D = get_node("audi")
@onready var anim: AnimationPlayer = get_node("anim")
@onready var timer: Timer = get_node("timer")
@onready var spawn_point: Node2D = get_node("spawnPoint")


func on_mouse_entered() -> void:
	if !may_interact: return
	interaction_controller.show_hint.emit(code)


func on_mouse_exited() -> void:
	if !may_interact: return
	interaction_controller.hide_item_hint.emit()


func interact() -> void:
	if !may_interact: return
	interaction_controller.hide_item_hint.emit()
	var item = interaction_controller.holding_item
	
	if item == null:
		interaction_controller.open_crafting_menu.emit(self)
	
	elif item.code == "empty-glass" and glass == null:
		glass = item
		interaction_controller.holding_item = null
		interaction_controller.clear_item.emit()
	
	elif item.type == Enums.ItemType.ingredient and ingredient == null:
		var result = RecepiesHandler.get_crafting_result(code, item.code)
		if result == "": return
		ingredient = item
		result_code = result
		interaction_controller.holding_item = null
		interaction_controller.clear_item.emit()


func start() -> void:
	may_interact = false
	ingredient.limit -= 1
	if ingredient.limit < 1:
			ingredient.queue_free()
			ingredient = null
	glass.queue_free()
	glass = null
	audi.play()
	anim.play("work")
	timer.start(WORK_TIME)
	
	await timer.timeout
	
	anim.stop()
	
	if code == "juicer":
		G.statistics.juices_made += 1
	elif code == "coffee-machine":
		G.statistics.coffee_made += 1
	
	G.game_manager.try_know_recipe.emit(result_code)
	var result = ItemSpawner.spawn_item(result_code, spawn_point.global_position, get_parent())
	result.moving.set_velocity(result_velocity)
	may_interact = true
