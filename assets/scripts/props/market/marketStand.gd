extends StaticBody2D

class_name MarketStand

@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var interaction: MarketStandInteraction = get_node("interaction")
@onready var audi: AudioStreamPlayer2D = get_node("audi")

@onready var buy_sound: AudioStream = load("res://assets/audio/buying/buy.wav")
@onready var delivery_buy_sound: AudioStream = load("res://assets/audio/buying/delivery_buy.wav")

@export var items: Array[ShopItem]
@export var delivery_price: int = 10

var is_open: bool
var is_delivery: bool


func start_trading(npc: CharacterBody2D) -> void:
	npc.global_position = interaction.get_stand_pos()
	interaction.set_open(true)
	is_open = true


func stop_trading() -> void:
	interaction.set_open(false)
	is_open = false


func buy_item(item: ShopItem) -> void:
	if M.money < item.price: 
		_show_text("not_money")
		return
	
	if item.type == Enums.ShopItemType.bag:
		if G.player.has_storage: return
		G.player.has_storage = true
		G.player.set_using_storage(true)
		_show_text("success")
		audi.stream = buy_sound
		audi.play()
	
	elif item.type == Enums.ShopItemType.item:
		var new_item = ItemSpawner.spawn_item(item.code, global_position, get_parent())
		new_item.disable()
		
		if is_delivery:
			if M.money < item.price + delivery_price:
				_show_text("not_money")
				return
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
				return
	
	M.remove_money(item.price)


func _show_text(code: String) -> void:
	var text = Loc.trans("interface.shop." + code)
	interaction_controller.show_hint_text.emit(text)


func _deliver_item(item: Item) -> void:
	var storages = get_tree().get_nodes_in_group("bar_storage")
	for storage: StorageHandler in storages:
		if !item.needs_fridge and storage.storage_type == Enums.StorageType.fridge: continue
		if item.needs_fridge and storage.storage_type != Enums.StorageType.fridge: continue
		storage.put_item(item)
