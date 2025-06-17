extends Node

class_name InputHandler

#----------------------------------------------
# Отвечает за кнопки клавиатуры
# Соединяется через другие ноды с помощью сигналов
#-----------------------------------------------

signal start_running
signal stop_running

@onready var main: Node2D = get_node('/root/main')


func _process(_delta: float) -> void:	
	if Input.is_action_just_pressed("ui_run"):
		start_running.emit()
	if Input.is_action_just_released("ui_run"):
		stop_running.emit()


func get_dir() -> Vector2:
	var result = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		result.y -= 1
	if Input.is_action_pressed("ui_down"):
		result.y += 1
	if Input.is_action_pressed("ui_left"):
		result.x -= 1
	if Input.is_action_pressed("ui_right"):
		result.x += 1
	return result
