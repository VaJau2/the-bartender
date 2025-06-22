extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player and body.has_storage:
		body.set_using_storage(false)


func _on_body_exited(body: Node2D) -> void:
	if body is Player and body.has_storage:
		body.set_using_storage(true)
