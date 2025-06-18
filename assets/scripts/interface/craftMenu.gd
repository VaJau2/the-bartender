extends Panel

@onready var movement_controller: MovementController = G.player.movement_controller
@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var name_label: Label = get_node("name")

@onready var glass_icon: Button = get_node("glassIcon")
@onready var ingredient_icon: Button = get_node("ingredientIcon")
@onready var start: Button = get_node("start")

var temp_crarfting: CraftingBase


func _ready() -> void:
	interaction_controller.open_crafting_menu.connect(_on_open_menu)
	interaction_controller.close_menu.connect(_on_cancel_pressed)


func _process(_delta: float) -> void:
	if !visible: return
	if Input.is_action_just_pressed("ui_cancel"):
		_on_cancel_pressed()


func _on_open_menu(crafting: CraftingBase) -> void:
	visible = true
	movement_controller.may_move = false
	name_label.text = Loc.trans("items." + crafting.code + ".name")
	temp_crarfting = crafting
	
	if crafting.glass != null:
		glass_icon.icon = crafting.glass.sprite.texture
	else:
		glass_icon.icon = null

	if crafting.ingredient != null:
		ingredient_icon.icon = crafting.ingredient.sprite.texture
	else:
		ingredient_icon.icon = null
	
	start.disabled = crafting.glass == null or crafting.ingredient == null


func _on_cancel_pressed() -> void:
	visible = false
	movement_controller.may_move = true


func _on_glass_icon_pressed() -> void:
	if temp_crarfting: temp_crarfting.get_glass()
	_on_cancel_pressed()


func _on_ingredient_icon_pressed() -> void:
	if temp_crarfting: temp_crarfting.get_ingredient()
	_on_cancel_pressed()


func _on_start_pressed() -> void:
	temp_crarfting.start()
	_on_cancel_pressed()
