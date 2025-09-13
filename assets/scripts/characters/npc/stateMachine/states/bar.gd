extends State

class_name BarState

const DISTANCE_TO_BAR: float = 250
const ORDER_WAITING_TIME = 100

@onready var bar_menu: BarMenu = get_tree().get_first_node_in_group("bar_menu")
@onready var bar_queue: BarQueueHandler = get_tree().get_first_node_in_group("bar_queue")
@onready var bar_front_area: PutArea = get_tree().get_first_node_in_group("bar_front_area")

@export var dialogue_icons: NpcDialogueIcons
@export var drunk_handler: DrunkHandler
@export var sale_audi: AudioStreamPlayer2D
@export var sale_sound: AudioStream

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
	npc.dialogue_icons.hide_icon()
	
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
			npc.dialogue_icons.set_transparency(order_timer / ORDER_WAITING_TIME)
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
	npc.dialogue_icons.show_thinking_icon()
	await get_tree().create_timer(randf_range(1, 2)).timeout
	
	if bar_queue.ordering_npc != null or !is_processing(): 
		state_machine.set_state("idle")
		return
	
	var result = _try_choose_drink()
	if result:
		# Сразу заводим таймер, чтобы и при автоматическом подборе напитка со
		# стойки, и при ручной выдаче напитка корректно работала статистика
		# подсчёта времени выполнения заказа (ORDER_WAITING_TIME - order_timer)
		order_timer = ORDER_WAITING_TIME
		
		# Ищем напиток на стойке и сразу пьем, если он есть
		var front_drink = bar_front_area.find_item(ordered_drink)
		if front_drink:
			have_drink(front_drink)
			return
		
		bar_queue.ordering_npc = npc
		npc.dialogue_icons.show_item_icon(ordered_drink)
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
	if !is_processing(): return
	if bar_queue.ordering_npc == null and bar_queue.is_first_in_queue(npc):
		_make_order()


func have_drink(drink_item: Item) -> void:
	if G.glasses_count > 0: G.glasses_count -= 1
	
	G.statistics.add_day_stats(G.statistics.clients_served_per_day, 1)
	G.statistics.add_drink_stats(drink_item.code, ordered_price)
	G.statistics.avg_order_fulfillment_time.push_back(ORDER_WAITING_TIME - order_timer)
	
	var booze_time = drink_item.booze_time
	
	drink_item.queue_free()
	
	dialogue_icons.set_transparency(1)
	dialogue_icons.show_thanks_icon()
	
	if ordered_price > 0:
		M.add_money(ordered_price)
		sale_audi.stream = sale_sound
		sale_audi.play()
		
		G.statistics.add_day_stats(G.statistics.profit_per_day, ordered_price)
		
		if drink_item.code.contains("juice"):
			G.statistics.juices_sold.amount += 1
			G.statistics.juices_sold.profit += ordered_price
		elif drink_item.code == "espresso" || drink_item.code == "cappuccino" || drink_item.code.contains("latte"):
			G.statistics.coffee_sold.amount += 1
			G.statistics.coffee_sold.profit += ordered_price
		elif drink_item.booze_time > 0:
			G.statistics.alcohol_sold.amount += 1
			G.statistics.alcohol_sold.profit += ordered_price
		else:
			G.statistics.other_sold.amount += 1
			G.statistics.other_sold.profit += ordered_price
	
	ordered_drink = ""
	
	await get_tree().create_timer(1).timeout
	if !is_processing(): return
	
	if booze_time > 0:
		drunk_handler.add_drunk_time(booze_time)
	
	state_machine.set_state("idle")
