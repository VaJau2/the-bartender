extends State

var npc: NPC

var temp_walk_point: NpcWalkPoint
var wait_timer: float
var is_walking: bool

@export var animation_controller: AnimationController


func init() -> void:
	super()
	is_walking = false
	npc = state_machine.npc
	movement_controller.came_to_point.connect(_on_came)


func _process(delta: float) -> void:
	if state_machine.npc.work_place != null:
		state_machine.set_state("work")
		return
	
	if wait_timer > 0:
		wait_timer -= delta
		return
	
	if !is_walking:
		_reset_old_point()
		_find_new_point()
		movement_controller.load_state("walk")
		movement_controller.set_target(temp_walk_point.global_position)
		is_walking = true


func disable() -> void:
	movement_controller.load_state("walk")
	temp_walk_point = null
	super()


func _reset_old_point() -> void:
	if temp_walk_point == null: return
	
	if temp_walk_point.point != null: 
		npc.global_position = temp_walk_point.global_position
	
	temp_walk_point.is_busy = false
	temp_walk_point = null


func _find_new_point() -> void:
	var points = get_tree().get_nodes_in_group("walk_point")
	points = points.filter(func(item): return !item.is_busy)
	var random_point = points[randi() % len(points) - 1]
	temp_walk_point = random_point
	temp_walk_point.is_busy = true


func _on_came() -> void:
	if !is_processing(): return
	animation_controller.set_flip(temp_walk_point.is_flip)
	movement_controller.load_state(temp_walk_point.movement_state_name)
	wait_timer = randf_range(temp_walk_point.wait_min_time, temp_walk_point.wait_max_time)
	if temp_walk_point.point != null:
		npc.global_position = temp_walk_point.point.global_position
	is_walking = false
