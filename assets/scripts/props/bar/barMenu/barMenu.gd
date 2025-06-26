extends Area2D

class_name BarMenu

const CLOSING_TIME: float = 23

@onready var interaction_controller: InteractionController = G.player.interaction_controller
@export var working_area: BarWorkingArea

var items: Array[BarMenuItem]
var is_open: bool

var closing_timer: float

signal open_changed(value: bool)
signal menu_changed


func _ready() -> void:
	working_area.player_entered.connect(_on_player_entered)
	working_area.player_exited.connect(_on_player_exited)


func _process(delta: float) -> void:
	if closing_timer > 0:
		closing_timer -= delta
	else:
		set_is_open(false)
		closing_timer = CLOSING_TIME
		set_process(false)


func _on_player_entered() -> void:
	set_process(false)


func _on_player_exited() -> void:
	closing_timer = CLOSING_TIME
	set_process(true)


func set_is_open(value: bool) -> void:
	is_open = value
	open_changed.emit(is_open)


func on_mouse_entered() -> void:
	interaction_controller.show_hint.emit("menu")


func on_mouse_exited() -> void:
	interaction_controller.hide_item_hint.emit()


func interact() -> void:
	interaction_controller.hide_item_hint.emit()
	interaction_controller.open_bar_menu.emit(self)


func add_item_to_menu(code: String) -> BarMenuItem:
	var menu_item = BarMenuItem.new()
	menu_item.code = code
	menu_item.price = 0
	
	items.append(menu_item)
	menu_changed.emit()
	return menu_item


func remove_item(item: BarMenuItem) -> void:
	items.erase(item)
	menu_changed.emit()


func has_item(code: String) -> bool:
	for item in items:
		if item.code == code:
			return true
	return false


func get_recipe_items() -> Array[String]:
	var json_data = JsonParse.read("res://assets/json/data/items.json")
	var result: Array[String] = []
	
	for item_code in json_data:
		var item_data = json_data[item_code]
		var item_type = Enums.ItemType.get(item_data.type)
		if item_type == Enums.ItemType.glass:
			if item_data.has("empty"): continue
			result.append(item_code)
	
	return result
