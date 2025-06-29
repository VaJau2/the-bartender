extends State

const WAKE_CHANCE = 0.4

const CHECK_BAR_TIME: float = 50
const CHECK_BAR_CHANCE: float = 0.1

@onready var bar_menu: BarMenu = get_tree().get_first_node_in_group("bar_menu")
@onready var bar_radio: Radio = get_tree().get_first_node_in_group("bar_radio")

var npc: NPC

var check_bar_timer: float


func init() -> void:
	super()
	npc = state_machine.npc
	movement_controller.came_to_point.connect(_on_came)
	G.time.hour_tick.connect(_on_hour_tick)


func _process(delta: float) -> void:
	_check_bar(delta)


func enable() -> void:
	super()
	if npc.sleep_place == null:
		state_machine.set_state("idle")
		return
	
	movement_controller.set_target(npc.sleep_place.global_position)


func disable() -> void:
	super()
	npc.visible = true
	npc.process_mode = Node.PROCESS_MODE_INHERIT


func _on_came() -> void:
	if !is_processing(): return
	npc.visible = false
	npc.process_mode = Node.PROCESS_MODE_DISABLED


func _on_hour_tick() -> void:
	if !is_processing(): return
	# нпц просыпается в утреннее время
	if G.time.hour >= WAKE_TIME and G.time.hour < SLEEP_TIME:
		if randf() < WAKE_CHANCE:
			state_machine.set_state("idle")


func _check_bar(delta: float) -> bool:
	if bar_menu.is_open:
		if check_bar_timer > 0:
			check_bar_timer -= delta
		else:
			var check_chance = CHECK_BAR_CHANCE
			if bar_radio.is_playing: check_chance = check_chance + 0.05
			if randf() < check_chance:
				state_machine.set_state("bar")
				return true
			else:
				check_bar_timer = CHECK_BAR_TIME
	return false
