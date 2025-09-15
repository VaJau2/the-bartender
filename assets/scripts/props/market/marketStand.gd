extends StandBase

class_name MarketStand

const RECIPE_COST: int = 20

@onready var buy_sound: AudioStream = load("res://assets/audio/buying/buy.wav")
@onready var delivery_buy_sound: AudioStream = load("res://assets/audio/buying/delivery_buy.wav")

@export var items: Array[ShopItem]
@export var load_recipes: bool
@export var delivery_price: int = 10
@export var fixed_delivery: bool
@export var hide_delivery: bool

var is_delivery: bool


func _ready() -> void:
	if load_recipes:
		var json_data = JsonParse.read("res://assets/json/data/items.json")
		var recipes = JsonParse.read("res://assets/json/data/recipes.json")
		for category in recipes:
			if category != "tool": continue
			
			for item_data in recipes[category]:
				if item_data.has("hide_shop"): continue
				var shop_item = ShopItem.new()
				shop_item.type = Enums.ShopItemType.recipe
				shop_item.code = item_data.result
				shop_item.price = RECIPE_COST
				shop_item.icon = load(json_data[shop_item.code].texture)
				shop_item.one_time = true
				items.append(shop_item)


func start_trading(npc: CharacterBody2D) -> void:
	super(npc)
	if fixed_delivery:
		is_delivery = true


func try_buy_item(item: ShopItem) -> bool:
	if M.money < item.price: 
		_show_text("not_money")
		return false
	
	match item.type:
		Enums.ShopItemType.recipe:
			G.game_manager.try_know_recipe.emit(item.code)
			interaction_controller.hide_item_hint.emit()
			audi.stream = buy_sound
			audi.play()
		
		Enums.ShopItemType.bag:
			if G.player.has_storage: return false
			G.player.has_storage = true
			G.player.set_using_storage(true)
			interaction_controller.hide_item_hint.emit()
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
					G.statistics.deliveries_spent += delivery_price
					G.statistics.add_day_stats(G.statistics.spent_per_day, delivery_price)
					interaction_controller.hide_item_hint.emit()
					audi.stream = delivery_buy_sound
					audi.play()
			else:
				var get_item_result = interaction_controller.try_get_item(new_item)
				if get_item_result:
					interaction_controller.hide_item_hint.emit()
					audi.stream = buy_sound
					audi.play()
				else:
					_show_text("not_space")
					new_item.queue_free()
					return false
			
			match new_item.category:
				"fruit":
					G.statistics.fruits_bought.amount += 1
					G.statistics.fruits_bought.profit += item.price
				"berry":
					G.statistics.berries_bought.amount += 1
					G.statistics.berries_bought.profit += item.price
				"vegetable":
					G.statistics.vegetables_bought.amount += 1
					G.statistics.vegetables_bought.profit += item.price
	
	match item.type:
		Enums.ItemType.ingredient:
			G.statistics.ingredients_spent += item.price
		Enums.ItemType.glass:
			G.statistics.ingredients_spent += item.price
		Enums.ItemType.tool:
			G.statistics.tools_spent += item.price
		Enums.ItemType.furn:
			G.statistics.furns_spent += item.price
	
	G.statistics.add_day_stats(G.statistics.spent_per_day, item.price)
	M.remove_money(item.price)
	return true


func _show_text(_code: String) -> void:
	var text = Loc.trans("interface.shop." + _code)
	interaction_controller.show_hint_text.emit(text)


func _deliver_item(item: Item) -> void:
	var storages = get_tree().get_nodes_in_group("bar_storage")
	for storage: StorageHandler in storages:
		var storage_type = storage.storage_type
		var needs_fridge = item.needs_fridge
		
		if needs_fridge and storage_type != Enums.StorageType.fridge: continue
		if !needs_fridge and storage_type == Enums.StorageType.fridge: continue
		
		storage.put_item(item)
