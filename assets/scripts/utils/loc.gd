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


static func get_plural(number:int, code: String) -> String:
	var trans_text = trans("interface.plural." + code)
	var words = trans_text.split('|')
	var cases = [2, 0, 1, 1, 1, 2];
	if number % 100 > 4 and number % 100 < 20: return words[2]
	if number % 10 < 5: return words[cases[number % 10]]
	return words[cases[5]]
