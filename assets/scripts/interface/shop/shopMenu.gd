extends Panel

@onready var movement_controller: MovementController = G.player.movement_controller
@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var buttons_parent: GridContainer = get_node("grid")
@onready var delivery_button: CheckBox = get_node("delivery")

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
	
	delivery_button.text = Loc.trans("interface.shop.delivery") \
		+ "(+" + str(temp_shop.delivery_price) + " " \
		+ Loc.get_plural(temp_shop.delivery_price, "bits") + ")"
	
	for item in temp_shop.items:
		var button: ShopButton = button_prefab.instantiate()
		button.icon = item.icon
		button.item = item
		button.on_click.connect(_on_button_click)
		buttons_parent.add_child(button)
	
	visible = true


func _on_button_click(item: ShopItem) -> void:
	temp_shop.buy_item(item)


func _on_close_pressed() -> void:
	visible = false
	movement_controller.may_move = true
	for button in buttons_parent.get_children():
		button.queue_free()


func _on_delivery_toggled(toggled_on: bool) -> void:
	temp_shop.is_delivery = toggled_on
