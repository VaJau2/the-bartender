extends Panel

class_name BarMenuMenu

@export var drink_receipt_item: PackedScene
@export var drink_item: PackedScene

@onready var movement_controller: MovementController = G.player.movement_controller
@onready var interaction_controller: InteractionController = G.player.interaction_controller

@onready var items_parent: VBoxContainer = get_node("drinksScroll/vbox")
@onready var receipts_parent: VBoxContainer = get_node("receiptsScroll/vbox")

var temp_menu: BarMenu


func _ready() -> void:
	interaction_controller.open_bar_menu.connect(_on_open_menu)
	interaction_controller.close_menu.connect(_on_close_pressed)


func _process(_delta: float) -> void:
	if !visible: return
	if Input.is_action_just_pressed("ui_cancel"):
		_on_close_pressed()


func _on_open_menu(menu: BarMenu) -> void:
	visible = true
	movement_controller.may_move = false
	temp_menu = menu
	_load_receipt_items()
	_load_menu_items()


func _on_close_pressed() -> void:
	visible = false
	movement_controller.may_move = true
	for item in items_parent.get_children(): item.queue_free()
	for item in receipts_parent.get_children(): item.queue_free()


func _load_receipt_items() -> void:
	var receipt_items = temp_menu.get_receipt_items()
	for item in receipt_items:
		if temp_menu.has_item(item): continue
		
		var menu_item: ReceiptBarMenuItem = drink_receipt_item.instantiate()
		receipts_parent.add_child(menu_item)
		menu_item.set_code(item)
		menu_item.on_click.connect(_on_receipt_item_click)


func _load_menu_items() -> void:
	for item in temp_menu.items:
		_create_drink_menu_item(item)


func _create_drink_menu_item(bar_item: BarMenuItem) -> void:
	var menu_item: BarDrinkMenuItem = drink_item.instantiate()
	items_parent.add_child(menu_item)
	menu_item.set_item(bar_item)
	menu_item.on_click.connect(_on_menu_item_click)


func _on_receipt_item_click(item: ReceiptBarMenuItem) -> void:
	var new_item = temp_menu.add_item_to_menu(item.code)
	_create_drink_menu_item(new_item)
	item.queue_free()


func _on_menu_item_click(clicked_drink: BarDrinkMenuItem) -> void:
	temp_menu.remove_item(clicked_drink.item)
	clicked_drink.queue_free()
	
	for item in receipts_parent.get_children(): item.queue_free()
	_load_receipt_items()
