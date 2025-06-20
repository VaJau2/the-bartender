extends TextureButton



func _ready() -> void:
	G.player.update_using_storage.connect(_on_update_using_storage)
	visible = G.player.using_storage


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_focus_next") && G.player.using_storage:
		_on_pressed()


func _on_pressed() -> void:
	var storage = G.player.storage_handler
	G.player.interaction_controller.open_storage_menu.emit(storage)


func _on_update_using_storage(value: bool):
	visible = value
