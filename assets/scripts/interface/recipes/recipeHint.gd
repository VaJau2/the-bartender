extends Panel

@onready var menu: RecipesMenu = get_node("../")
@onready var header: Label = get_node("name")
@onready var item1: TextureRect = get_node("item1")
@onready var item2: TextureRect = get_node("item2")
@onready var result: TextureRect = get_node("result")


func _ready() -> void:
	menu.show_hint.connect(_show_hint)
	menu.hide_hint.connect(_on_hide_hint)


func _process(_delta: float) -> void:
	if !visible:
		set_process(false)
		return
	_update_pos()


func _update_pos() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	position = mouse_pos - Vector2(375, 180)


func _show_hint(data: RecipeData) -> void:
	visible = true
	header.text = Loc.trans("items." + data.result + ".name")
	
	var json_data = JsonParse.read("res://assets/json/data/items.json")
	
	if data.custom_item_texture:
		item1.texture = data.custom_item_texture
	else:
		item1.texture = load(json_data[data.item].texture)
	
	item2.texture = load(json_data[data.holding_item].texture)
	result.texture = load(json_data[data.result].texture)
	
	set_process(true)


func _on_hide_hint() -> void:
	visible = false
