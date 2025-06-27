extends Panel

@onready var movement_controller: MovementController = G.player.movement_controller
@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var buttons_parent: GridContainer = get_node("grid")
@onready var delivery_button: CheckBox = get_node("delivery")
@onready var empty_label: Label = get_node("empty")
@onready var header: Label = get_node("header")
@onready var pause_menu: PauseMenu = get_tree().get_first_node_in_group("pause_menu")

@export var button_prefab: PackedScene

var temp_shop: MarketStand


func _ready() -> void:
	interaction_controller.open_shop_menu.connect(_on_open_menu)
	interaction_controller.close_menu.connect(_on_close_pressed)


func _on_open_menu(shop: MarketStand) -> void:
	if visible:
		_on_close_pressed()
		return
	
	pause_menu.may_pause = false
	temp_shop = shop
	movement_controller.may_move = false
	
	header.text = Loc.trans("items." + temp_shop.code + ".name")
	
	if temp_shop.hide_delivery:
		delivery_button.visible = false
	else:
		delivery_button.disabled = temp_shop.fixed_delivery
		delivery_button.button_pressed  = temp_shop.is_delivery
		delivery_button.text = Loc.trans("interface.shop.delivery") \
			+ "(+" + str(temp_shop.delivery_price) + " " \
			+ Loc.get_plural(temp_shop.delivery_price, "bits") + ")"
	
	for item in temp_shop.items:
		if item.type == Enums.ShopItemType.recipe:
			if G.game_manager.knowed_recipes.has(item.code):
				continue
		
		var button: ShopButton = button_prefab.instantiate()
		button.icon = item.icon
		button.item = item
		button.on_click.connect(_on_button_click)
		buttons_parent.add_child(button)
	
	empty_label.visible = buttons_parent.get_child_count() == 0
	
	visible = true


func _on_button_click(item: ShopItem) -> void:
	var result = temp_shop.try_buy_item(item)
	if result:
		if item.type == Enums.ShopItemType.recipe:
			for button in buttons_parent.get_children():
				if button.item == item:
					button.queue_free()
					interaction_controller.hide_item_hint.emit()
					break
			empty_label.visible = buttons_parent.get_child_count() == 1


func _on_close_pressed() -> void:
	visible = false
	movement_controller.may_move = true
	for button in buttons_parent.get_children():
		button.queue_free()
	await get_tree().process_frame
	pause_menu.may_pause = true


func _on_delivery_toggled(toggled_on: bool) -> void:
	temp_shop.is_delivery = toggled_on
