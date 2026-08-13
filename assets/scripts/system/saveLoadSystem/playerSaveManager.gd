extends BaseCharacterSaveManager

class_name PlayerSaveManager


func get_save_data() -> Dictionary:
	var data = super()
	data.using_storage = parent.using_storage
	data.has_storage = parent.has_storage
	return data


func load_save_data(data: Dictionary) -> void:
	parent.set_using_storage(data.using_storage)
	parent.has_storage = data.has_storage
	super(data)
