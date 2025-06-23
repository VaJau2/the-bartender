extends State

const DISTANCE_TO_BAR: float = 250

@onready var bar_menu: BarMenu = get_tree().get_first_node_in_group("bar_menu")
@onready var bar_queue: BarQueueHandler = get_tree().get_first_node_in_group("bar_queue")
@export var dialogue: NpcDialogue

var npc: NPC

var closing_to_bar: bool
var closing_to_queue: bool

var queue_point: Vector2


func init() -> void:
	super()
	npc = state_machine.npc
	movement_controller.came_to_point.connect(_on_came)


func enable() -> void:
	if state_machine.npc.global_position.distance_to(bar_queue.global_position) > DISTANCE_TO_BAR:
		movement_controller.set_came_distance(DISTANCE_TO_BAR)
		movement_controller.set_target(bar_queue.global_position)
		closing_to_bar = true
	else:
		_go_to_bar_queue()
	super()


func disable() -> void:
	closing_to_queue = false
	npc.dialogue.hide_icon()
	
	if bar_queue.is_in_queue(npc):
		bar_queue.erase_from_queue(npc)
	
	if queue_point != Vector2.ZERO:
		npc.global_position = _get_queue_land_position()
		queue_point = Vector2.ZERO
	
	super()


func _process(_delta: float) -> void:
	if !bar_menu.is_open:
		state_machine.set_state("idle")


func _on_came() -> void:
	if !is_processing(): return
	
	if closing_to_queue:
		npc.global_position = queue_point
		movement_controller.load_state("sit")
		if bar_queue.is_first_in_queue(npc):
			_choose_drink()
		return
	
	if closing_to_bar:
		_go_to_bar_queue()
		return


func _go_to_bar_queue() -> void:
	if !bar_queue.has_free_point():
		state_machine.set_state("idle")
		return
	
	queue_point = bar_queue.get_free_point(npc)
	movement_controller.set_came_distance(movement_controller.DEFAULT_CAME_DISTANCE)
	movement_controller.set_target(_get_queue_land_position())
	closing_to_queue = true


func _get_queue_land_position() -> Vector2:
	return Vector2(queue_point.x, queue_point.y + 50)


func _choose_drink() -> void:
	npc.dialogue.show_thinking_icon()
	pass
