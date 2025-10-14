class_name Statistics

var profit_per_day: Array[int] = []
var other_sold: ItemStats = ItemStats.new()
var juices_sold: ItemStats = ItemStats.new()
var coffee_sold: ItemStats = ItemStats.new()
var alcohol_sold: ItemStats = ItemStats.new()
var drinks_stats: Dictionary[String, ItemStats] = {}

var spent_per_day: Array[int] = []
var ingredients_spent: int
var deliveries_spent: int
var tools_and_furns_spent: int
var recipes_spent: int

var clients_served_per_day: Array[int] = []
var avg_order_fulfillment_time: Array[float] = []

var fruits_bought: ItemStats = ItemStats.new()
var berries_bought: ItemStats = ItemStats.new()
var vegetables_bought: ItemStats = ItemStats.new()

var fruits_stolen: ItemStats = ItemStats.new()
var berries_stolen: ItemStats = ItemStats.new()
var vegetables_stolen: ItemStats = ItemStats.new()


func reset() -> void:
	other_sold.reset()
	juices_sold.reset()
	coffee_sold.reset()
	alcohol_sold.reset()
	drinks_stats.clear()
	
	ingredients_spent = 0
	deliveries_spent = 0
	tools_and_furns_spent = 0
	recipes_spent = 0
	
	_reset_day_stats(profit_per_day)
	_reset_day_stats(spent_per_day)
	_reset_day_stats(clients_served_per_day)
	avg_order_fulfillment_time.clear()
	
	fruits_bought.reset()
	berries_bought.reset()
	vegetables_bought.reset()
	
	fruits_stolen.reset()
	berries_stolen.reset()
	vegetables_stolen.reset()


func ingredient_stolen(code: String) -> void:
	var json_data = JsonParse.read("res://assets/json/data/items.json")
	var category = json_data[code].category
	
	match category:
		"fruit":
			var prices = json_data[code].prices
			var price = randi_range(prices[0], prices[prices.size() - 1])
			fruits_stolen.profit += price
			fruits_stolen.amount += 1
		"berry":
			var prices = json_data[code].prices
			var price = randi_range(prices[0], prices[prices.size() - 1])
			berries_stolen.profit += price
			berries_stolen.amount += 1
		"vegetable":
			var prices = json_data[code].prices
			var price = randi_range(prices[0], prices[prices.size() - 1])
			vegetables_stolen.profit += price
			vegetables_stolen.amount += 1


func add_day_stats(array: Array, value) -> void:
	array[G.time.day] += value


func _reset_day_stats(array: Array) -> void:
	array.clear()
	while array.size() < G.DAYS_GOAL:
		array.push_back(0)


func add_buy_stats(shop_item: ShopItem, item: Item) -> void:
	match shop_item.type:
		Enums.ShopItemType.bag:
			tools_and_furns_spent += shop_item.price
		Enums.ShopItemType.recipe:
			recipes_spent += shop_item.price
		Enums.ShopItemType.item:
			match item.category:
				"fruit":
					fruits_bought.amount += 1
					fruits_bought.profit += shop_item.price
				"berry":
					berries_bought.amount += 1
					berries_bought.profit += shop_item.price
				"vegetable":
					vegetables_bought.amount += 1
					vegetables_bought.profit += shop_item.price
			
			match item.type:
				Enums.ItemType.ingredient:
					ingredients_spent += shop_item.price
				Enums.ItemType.glass:
					ingredients_spent += shop_item.price
				Enums.ItemType.tool:
					tools_and_furns_spent += shop_item.price
				Enums.ItemType.furn:
					tools_and_furns_spent += shop_item.price


func add_drink_stats(code: String, profit: int) -> void:
	if drinks_stats.has(code):
		drinks_stats[code].amount += 1
		drinks_stats[code].profit += profit
	else:
		var newItemStats = ItemStats.new()
		newItemStats.amount = 1
		newItemStats.profit = profit
		var new_dictionary = {code: newItemStats}
		drinks_stats.merge(new_dictionary)


func get_most_sold_drink() -> String:
	var max_value: int
	var most_sold_drink: String
	
	for key in drinks_stats:
		var drink = drinks_stats[key]
		if drink.amount > max_value:
			max_value = drink.amount
			most_sold_drink = key
	
	return most_sold_drink


func get_most_profit_drink() -> String:
	var max_value: int
	var most_profit_drink: String
	
	for key in drinks_stats:
		var drink = drinks_stats[key]
		if drink.profit > max_value:
			max_value = drink.profit
			most_profit_drink = key
	
	return most_profit_drink


func get_total(array_values: Array) -> float:
	var total = 0
	for value in array_values:
		total += value
	return total


func get_average(array_values: Array) -> float:
	return float(get_total(array_values)) / float(array_values.size())


func get_max(array_values: Array) -> int:
	var maxValue: int = 0
	for value in array_values:
		maxValue = max(maxValue, value)
	return maxValue
