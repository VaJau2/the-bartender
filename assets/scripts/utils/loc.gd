class_name Loc

#-------------------------------------------
# Статичный класс
# Отвечает за получение всего игрового текста из assets/json/{lang}/
#--------------------------------------------

const LANG = 'ru'

# Получает на вход путь до кода в виде "inGame.logs.start"
# Первый элемент в пути - название файла
# Остальное - json ключи (любой вложенности)
# Возвращает строку или ошибку
static func trans(code: String) -> String:
	var path = code.split('.')
	if len(path) == 0: 
		push_error("file path is empty")
		
	var fileName = path[0]
	var jsonData = JsonParse.read("res://assets/json/" + LANG + "/" + fileName + ".json")
	path.remove_at(0)
	
	if len(path) == 0: 
		push_error("json path is empty")
	
	var firstJsonCode = path[0]
	var result = jsonData[firstJsonCode]
	path.remove_at(0)
	
	while (len(path) > 0):
		var nextJsonCode = path[0]
		result = result[nextJsonCode]
		path.remove_at(0)
	
	return result
