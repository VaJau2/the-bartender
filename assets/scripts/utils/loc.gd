class_name Loc

#-------------------------------------------
# Статичный класс
# Отвечает за получение всего игрового текста из assets/json/{lang}/
#--------------------------------------------

static var current_lang = Enums.Lang.en

# Получает на вход путь до кода в виде "inGame.logs.start"
# Первый элемент в пути - название файла
# Остальное - json ключи (любой вложенности)
# Возвращает строку или ошибку
static func trans(code: String) -> String:
	var path = code.split('.')
	if len(path) == 0: 
		push_error("file path is empty")
		
	var fileName = path[0]
	
	var json_path = "res://assets/json/" + str(Enums.Lang.keys()[current_lang]) + "/" + fileName + ".json"
	
	var json_data = JsonParse.read(json_path)
	path.remove_at(0)
	
	if len(path) == 0: 
		push_error("json path is empty")
	
	var first_json_code = path[0]
	var result = json_data[first_json_code]
	path.remove_at(0)
	
	while (len(path) > 0):
		var next_json_code = path[0]
		result = result[next_json_code]
		path.remove_at(0)
	
	return result
