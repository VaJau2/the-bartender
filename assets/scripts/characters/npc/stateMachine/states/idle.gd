extends State

class_name IdleState

const CHECK_BAR_TIME: float = 10
const CHECK_BAR_CHANCE: float = 0.4

var npc: NPC

var temp_walk_point: NpcWalkPoint
var wait_timer: float
var check_bar_timer: float
var is_walking: bool

@export var animation_controller: AnimationController
@onready var bar_menu: BarMenu = get_tree().get_first_node_in_group("bar_menu")
@onready var bar_radio: Radio = get_tree().get_first_node_in_group("bar_radio")


func init() -> void:
	super()
	is_walking = false
	npc = state_machine.npc
	movement_controller.came_to_point.connect(_on_came)
	G.time.minute_tick.connect(_on_minute_tick)


func _process(delta: float) -> void:
	if state_machine.npc.work_place != null:
		state_machine.set_state("work")
		return
	
	if wait_timer > 0:
		wait_timer -= delta
		return
	
	if _check_bar(delta): return
	
	if !is_walking:
		_reset_old_point()
		_find_new_point()
		movement_controller.load_state(npc.walk_state)
		movement_controller.set_target(temp_walk_point.global_position)
		is_walking = true


func enable() -> void:
	movement_controller.reset_came_distance()
	check_bar_timer = CHECK_BAR_TIME
	super()


func disable() -> void:
	movement_controller.load_state(npc.walk_state)
	if temp_walk_point != null: temp_walk_point.is_busy = false
	temp_walk_point = null
	wait_timer = 0
	is_walking = false
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
	
	if temp_walk_point == null: 
		is_walking = false
		return
	
	animation_controller.set_flip(temp_walk_point.is_flip)
	movement_controller.load_state(temp_walk_point.movement_state_name)
	wait_timer = randf_range(temp_walk_point.wait_min_time, temp_walk_point.wait_max_time)
	if temp_walk_point.point != null:
		npc.global_position = temp_walk_point.point.global_position
	is_walking = false


func _check_bar(delta: float) -> bool:
	if bar_menu.is_open:
		if check_bar_timer > 0:
			check_bar_timer -= delta
		else:
			var check_chance = CHECK_BAR_CHANCE
			if bar_radio.is_playing: check_chance = check_chance + 0.2
			if randf() < check_chance:
				state_machine.set_state("bar")
				return true
			else:
				check_bar_timer = CHECK_BAR_TIME
	return false


func _on_minute_tick() -> void:
	if !is_processing() or npc.sleep_place == null: return
	if G.time.hour >= SLEEP_TIME or G.time.hour < WAKE_TIME:
		if randf() < SLEEP_CHANCE:
			state_machine.set_state("sleep")
