extends Area2D

class_name BarWorkingArea

signal player_entered
signal player_exited


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_entered.emit()
		
		if body.has_storage:
			body.set_using_storage(false)


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_exited.emit()
		
		if body.has_storage:
			body.set_using_storage(true)
