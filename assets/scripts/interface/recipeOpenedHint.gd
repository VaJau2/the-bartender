extends Panel

const SHOW_TIME = 2
const HIDE_TIME = 1

@onready var anim: AnimationPlayer = get_node("anim")
@onready var item: Label = get_node("item")
@onready var icon: TextureRect = get_node("icon")

var show_timer: float
var hide_timer: float


func _ready() -> void:
	G.game_manager.know_recipe.connect(_on_know_recipe)
	set_process(false)


func _process(delta: float) -> void:
	if show_timer > 0:
		show_timer -= delta
	else:
		anim.play("hide")
		
		if hide_timer > 0:
			hide_timer -= delta
		else:
			visible = false
			set_process(false)


func _on_know_recipe(code: String) -> void:
	visible = true
	anim.play("show")
	show_timer = SHOW_TIME
	hide_timer = HIDE_TIME
	item.text = Loc.trans("items." + code + ".name")
	
	var json_data = JsonParse.read("res://assets/json/data/items.json")
	icon.texture = load(json_data[code].texture)
	
	set_process(true)
