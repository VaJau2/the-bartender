class_name StorageItem

var code: String
var category: String
var limit: int


func _init(_code: String, _category: String, _limit: int) -> void:
	code = _code
	category = _category
	limit = _limit


func to_json() -> String:
	var result = {
		"code": code,
		"category": category,
		"limit": limit
	}
	
	return JSON.stringify(result)


static func from_json(str_data: String) -> StorageItem:
	var data = JSON.parse_string(str_data)
	return new(data.code, data.category, data.limit)
