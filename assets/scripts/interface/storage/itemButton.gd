extends Button

class_name StorageItemButton

var item: StorageItem


signal on_click(item: StorageItem)


func _ready() -> void:
	pressed.connect(_on_pressed)
	

func _on_pressed() -> void:
	on_click.emit(item)


func set_icon(texture: Texture) -> void:
	get_node("icon").texture = texture
