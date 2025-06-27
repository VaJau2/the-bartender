extends StaticBody2D

class_name MarketStand

@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var interaction: MarketStandInteraction = get_node("interaction")
@onready var audi: AudioStreamPlayer2D = get_node("audi")

@onready var buy_sound: AudioStream = load("res://assets/audio/buying/buy.wav")
@onready var delivery_buy_sound: AudioStream = load("res://assets/audio/buying/delivery_buy.wav")

@export var code: String = "shop"
@export var items: Array[ShopItem]
@export var load_recipes: bool
@export var delivery_price: int = 10
@export var fixed_delivery: bool
@export var hide_delivery: bool

var is_open: bool
var is_delivery: bool


func _ready() -> void:
	if load_recipes:
		var json_data = JsonParse.read("res://assets/json/data/items.json")
		var recipes = JsonParse.read("res://assets/json/data/recipes.json")
		for category in recipes:
			if category == "sink": continue
			
			for item_data in recipes[category]:
				var shop_item = ShopItem.new()
				shop_item.type = Enums.ShopItemType.recipe
				
				if category == "tool":
					shop_item.code = item_data.result
					shop_item.price = 8
				else:
					shop_item.code = recipes[category][item_data]
					shop_item.price = 4
				
				shop_item.icon = load(json_data[shop_item.code].texture)
				items.append(shop_item)


func start_trading(npc: CharacterBody2D) -> void:
	npc.global_position = interaction.get_stand_pos()
	interaction.set_open(true)
	is_open = true
	if fixed_delivery:
		is_delivery = true


func stop_trading() -> void:
	interaction.set_open(false)
	is_open = false


func try_buy_item(item: ShopItem) -> bool:
	if M.money < item.price: 
		_show_text("not_money")
		return false
	
	match item.type:
		Enums.ShopItemType.recipe:
			G.game_manager.try_know_recipe.emit(item.code)
			_show_text("success")
			audi.stream = buy_sound
			audi.play()
		
		Enums.ShopItemType.bag:
			if G.player.has_storage: return false
			G.player.has_storage = true
			G.player.set_using_storage(true)
			_show_text("success")
			audi.stream = buy_sound
			audi.play()
	
		Enums.ShopItemType.item:
			var new_item = ItemSpawner.spawn_item(item.code, global_position, get_parent())
			new_item.disable()
			
			if is_delivery:
				if M.money < item.price + delivery_price:
					_show_text("not_money")
					return false
				else:
					_deliver_item(new_item)
					M.remove_money(delivery_price)
					_show_text("success")
					audi.stream = delivery_buy_sound
					audi.play()
			else:
				var get_item_result = interaction_controller.try_get_item(new_item)
				if get_item_result:
					_show_text("success")
					audi.stream = buy_sound
					audi.play()
				else:
					_show_text("not_space")
					new_item.queue_free()
					return false
	
	M.remove_money(item.price)
	return true


func _show_text(_code: String) -> void:
	var text = Loc.trans("interface.shop." + _code)
	interaction_controller.show_hint_text.emit(text)


func _deliver_item(item: Item) -> void:
	var storages = get_tree().get_nodes_in_group("bar_storage")
	for storage: StorageHandler in storages:
		if !item.needs_fridge and storage.storage_type == Enums.StorageType.fridge: continue
		if item.needs_fridge and storage.storage_type != Enums.StorageType.fridge: continue
		storage.put_item(item)
