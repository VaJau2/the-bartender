extends State

class_name BarState

const DISTANCE_TO_BAR: float = 250
const ORDER_WAITING_TIME = 100

@onready var bar_menu: BarMenu = get_tree().get_first_node_in_group("bar_menu")
@onready var bar_queue: BarQueueHandler = get_tree().get_first_node_in_group("bar_queue")
@export var dialogue: NpcDialogue

var npc: NPC

var closing_to_bar: bool
var closing_to_queue: bool

var queue_point: Vector2

var ordered_drink: String
var ordered_price: int
var order_timer: float


func init() -> void:
	super()
	npc = state_machine.npc
	movement_controller.came_to_point.connect(_on_came)
	bar_queue.queue_updated.connect(_on_queue_updated)


func enable() -> void:
	if state_machine.npc.global_position.distance_to(bar_queue.global_position) > DISTANCE_TO_BAR:
		movement_controller.set_came_distance(DISTANCE_TO_BAR)
		movement_controller.set_target(bar_queue.global_position)
		closing_to_bar = true
	else:
		_go_to_bar_queue()
	super()


func disable() -> void:
	npc.dialogue.hide_icon()
	
	if bar_queue.ordering_npc == npc:
		bar_queue.ordering_npc = null
	
	if bar_queue.is_in_queue(npc):
		bar_queue.erase_from_queue(npc)
	
	if queue_point != Vector2.ZERO:
		npc.global_position = _get_queue_land_position()
		queue_point = Vector2.ZERO
	
	closing_to_bar = false
	closing_to_queue = false
	ordered_drink = ""
	order_timer = 0
	ordered_price = 0
	super()


func _process(delta: float) -> void:
	if ordered_drink != "":
		if order_timer > 0:
			order_timer -= delta
			npc.dialogue.set_transparency(order_timer / ORDER_WAITING_TIME)
		else:
			state_machine.set_state("idle")
			return
	
	if !bar_menu.is_open:
		state_machine.set_state("idle")


func _on_came() -> void:
	if !is_processing(): return
	
	if closing_to_queue:
		npc.global_position = queue_point
		movement_controller.load_state("sit")
		
		if bar_queue.is_first_in_queue(npc) and bar_queue.ordering_npc == null:
			_make_order()
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


func _make_order() -> void:
	npc.dialogue.show_thinking_icon()
	await get_tree().create_timer(randf_range(1, 2)).timeout
	
	if !is_processing(): return
	
	var result = _try_choose_drink()
	if result:
		bar_queue.ordering_npc = npc
		npc.dialogue.show_item_icon(ordered_drink)
		order_timer = ORDER_WAITING_TIME
	else:
		state_machine.set_state("idle")


func _try_choose_drink() -> bool:
	var json_data = JsonParse.read("res://assets/json/data/items.json")
	var menu_drinks = bar_menu.items.duplicate()
	menu_drinks.shuffle()
	
	for drink in menu_drinks:
		var prices = json_data[drink.code].prices
		var calculator = ChooseCalculator.new(prices[0], prices[1])
		var chance = calculator.calculate(drink.price)
		if randf() < chance:
			ordered_price = drink.price
			ordered_drink = drink.code
			return true
	
	return false


func _on_queue_updated() -> void:
	if bar_queue.ordering_npc == null and bar_queue.is_first_in_queue(npc):
		_make_order()
