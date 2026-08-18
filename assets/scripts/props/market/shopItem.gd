extends Resource

class_name ShopItem

@export var code: String
@export var type: Enums.ShopItemType
@export var icon: Texture
@export var price: int
@export var one_time: bool


func to_json() -> String:
	var result = {
		"code": code,
		"type": var_to_str(type),
		"icon": icon.resource_path,
		"price": price,
		"one_time": one_time
	}
	
	return JSON.stringify(result)


static func from_json(str_data: String) -> ShopItem:
	var data = JSON.parse_string(str_data)
	var item = new()
	
	item.code = data.code
	item.type = str_to_var(data.type)
	item.icon = load(data.icon)
	item.price = data.price
	item.one_time = data.one_time
	
	return item
