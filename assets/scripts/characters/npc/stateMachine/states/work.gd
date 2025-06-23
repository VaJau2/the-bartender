extends State

var work_place: MarketStand


func init() -> void:
	super()
	work_place = state_machine.npc.work_place
	movement_controller.came_to_point.connect(_on_came)


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
