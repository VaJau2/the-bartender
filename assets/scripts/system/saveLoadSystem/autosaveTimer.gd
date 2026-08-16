extends Timer


func _ready() -> void:
	L.game_saved.connect(_on_saved)
	timeout.connect(_on_timeout)


func _on_saved() -> void:
	start()


func _on_timeout() -> void:
	L.save_data()
