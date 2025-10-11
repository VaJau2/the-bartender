extends HBoxContainer

class_name Skip

const HIDE_TIME = 5

@onready var anim: AnimationPlayer = get_node("anim")
var enabled: bool
var timer: float
signal skip_signal


func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_select"):
		if !visible:
			anim.play("show")
			timer = 0
		else:
			set_process(false)
			skip_signal.emit()
		return
	
	if !visible or anim.current_animation == "hide":
		return
	
	timer += delta
	
	if timer > HIDE_TIME:
		anim.play("hide")


func on(function: Callable):
	skip_signal.connect(function)
	set_process(true)

func off():
	var functions = skip_signal.get_connections()
	
	for function in functions:
		skip_signal.disconnect(function.callable)
	
	set_process(false)
	visible = false
