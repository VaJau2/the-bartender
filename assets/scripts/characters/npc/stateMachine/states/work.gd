extends State

class_name WorkState

const CHECK_BAR_TIME: float = 20
const CHECK_BAR_CHANCE: float = 0.1

@onready var bar_menu: BarMenu = get_tree().get_first_node_in_group("bar_menu")

var work_place: MarketStand

var check_bar_timer: float


func init() -> void:
	super()
	work_place = state_machine.npc.work_place
	movement_controller.came_to_point.connect(_on_came)


func _process(delta: float) -> void:
	_check_bar(delta)


func enable() -> void:
	if work_place == null: 
		state_machine.set_state("idle")
		return
	
	movement_controller.set_target(state_machine.npc.work_place.global_position)
	super()


func disable() -> void:
	if work_place != null: work_place.stop_trading()
	super()


func _on_came() -> void:
	if !is_processing(): return
	state_machine.npc.work_place.start_trading(state_machine.npc)


func _check_bar(delta: float) -> bool:
	if bar_menu.is_open:
		if check_bar_timer > 0:
			check_bar_timer -= delta
		else:
			if randf() < CHECK_BAR_CHANCE:
				state_machine.set_state("bar")
				return true
			else:
				check_bar_timer = CHECK_BAR_TIME
	return false
