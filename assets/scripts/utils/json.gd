class_name JsonParse

#-------------------------------------------
# Статичный класс
# Отвечает за чтение json файлов
#--------------------------------------------


static func read(json_file_path: String) -> Variant:
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var finish = JSON.parse_string(content)
	return finish
