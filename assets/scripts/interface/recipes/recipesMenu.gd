extends Panel

class_name RecipesMenu

@export var other_menus: Array[Panel]
@export var recipe_prefab: PackedScene

@onready var movement_controller: MovementController = G.player.movement_controller
@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var pause_menu: PauseMenu = get_tree().get_first_node_in_group("pause_menu")

@onready var recipes_parent: GridContainer = get_node("scroll/vbox")

@onready var sink_icon: Texture = preload("res://assets/sprites/props/furn/sink.png")
@onready var coffee_icon: Texture = preload("res://assets/sprites/props/furn/Coffee Machine.png")
@onready var juicer_icon: Texture = preload("res://assets/sprites/props/furn/juicer.png")


signal show_hint(data: RecipeData)
signal hide_hint


func _ready() -> void:
	interaction_controller.open_recepies_menu.connect(_on_open_menu)
	interaction_controller.close_menu.connect(_on_close_pressed)
	
	var recipes = JsonParse.read("res://assets/json/data/recipes.json")
	
	for category in recipes:
		for item_data in recipes[category]:
			var recipe_data = RecipeData.new()
			
			if category == "tool":
				recipe_data.item = item_data.item
				recipe_data.holding_item = item_data.holding_item
				recipe_data.result = item_data.result
			else:
				recipe_data.custom_item_texture = _get_category_icon(category)
				recipe_data.holding_item = item_data
				recipe_data.result = recipes[category][item_data]
			
			var recipe: RecipeIcon = recipe_prefab.instantiate()
			recipe.set_item_data(recipe_data)
			recipe.menu = self
			recipes_parent.add_child(recipe)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_recepies"):
		_on_open_menu()
	
	if !visible: return
	if Input.is_action_just_pressed("ui_cancel"):
		_on_close_pressed()


func _on_open_menu() -> void:
	interaction_controller.hide_item_hint.emit()
	
	for menu in other_menus:
		if menu.visible: return
	
	if visible:
		_on_close_pressed()
		return
	
	for item: RecipeIcon in recipes_parent.get_children():
		item.check_opened()

	pause_menu.may_pause = false
	movement_controller.may_move = false
	visible = true


func _on_close_pressed() -> void:
	movement_controller.may_move = true
	visible = false
	
	await get_tree().process_frame
	pause_menu.may_pause = true


func _get_category_icon(category: String) -> Texture:
	match category:
		"sink": return sink_icon
		"juicer": return juicer_icon
		"coffee-machine": return coffee_icon
	return null
