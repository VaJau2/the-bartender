extends Panel

@onready var movement_controller: MovementController = G.player.movement_controller
@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var buttons_parent: GridContainer = get_node("grid")

@export var button_prefab: PackedScene

var temp_shop: MarketStand


func _ready() -> void:
	interaction_controller.open_shop_menu.connect(_on_open_menu)
	interaction_controller.close_menu.connect(_on_close_pressed)


func _on_open_menu(shop: MarketStand) -> void:
	if visible:
		_on_close_pressed()
		return
	
	temp_shop = shop
	movement_controller.may_move = false
	
	for item in temp_shop.items:
		var button: ShopButton = button_prefab.instantiate()
		button.icon = item.icon
		button.item = item
		button.on_click.connect(_on_button_click)
		buttons_parent.add_child(button)
	
	visible = true


func _on_button_click(item: ShopItem) -> void:
	print("buy item " + item.code)


func _on_close_pressed() -> void:
	visible = false
	movement_controller.may_move = true
