extends TextureButton


func _on_pressed() -> void:
	G.player.interaction_controller.open_recepies_menu.emit()
