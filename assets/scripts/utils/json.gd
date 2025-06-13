class_name JsonParse

#-------------------------------------------
# Статичный класс
# Отвечает за чтение json файлов
#--------------------------------------------


static func read(jsonFilePath: String) -> Variant:
	var file = FileAccess.open(jsonFilePath, FileAccess.READ)
	var content = file.get_as_text()
	var finish = JSON.parse_string(content)
	return finish
