extends Panel

class_name RecipesMenu

@export var other_menus: Array[Panel]
@export var recipe_prefab: PackedScene

@onready var movement_controller: MovementController = G.player.movement_controller
@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var pause_menu: PauseMenu = get_tree().get_first_node_in_group("pause_menu")

@onready var recipes_parent: GridContainer = get_node("scroll/vbox")


signal show_hint(code: String)
signal hide_hint


func _ready() -> void:
	interaction_controller.open_recepies_menu.connect(_on_open_menu)
	interaction_controller.close_menu.connect(_on_close_pressed)
	
	var recipes = JsonParse.read("res://assets/json/data/recipes.json")
	
	for category in recipes:
		for item_data in recipes[category]:
			var item_code = ""
			if category == "tool":
				item_code = item_data.result
			else: 
				item_code = recipes[category][item_data]
			
			var recipe: RecipeIcon = recipe_prefab.instantiate()
			recipe.set_item_code(item_code)
			recipe.menu = self
			recipes_parent.add_child(recipe)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_recepies"):
		_on_open_menu()


func _on_open_menu() -> void:
	for menu in other_menus:
		if menu.visible: return
	
	if visible:
		_on_close_pressed()
		return
	
	pause_menu.may_pause = false
	movement_controller.may_move = false
	visible = true


func _on_close_pressed() -> void:
	pause_menu.may_pause = true
	movement_controller.may_move = true
	visible = false
