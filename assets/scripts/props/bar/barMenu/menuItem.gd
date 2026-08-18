extends Resource

class_name BarMenuItem

@export var code: String
@export var price: int


func to_json() -> String:
	var result = {
		"code": code,
		"price": price
	}
	
	return JSON.stringify(result)


static func from_json(json: String) -> BarMenuItem:
	var data = JSON.parse_string(json)
	var result = new()
	result.code = data.code
	result.price = data.price
	return result
