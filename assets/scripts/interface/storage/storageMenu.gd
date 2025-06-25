extends Panel

@onready var movement_controller: MovementController = G.player.movement_controller
@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var name_label: Label = get_node("header")
@onready var empty_label: Label = get_node("empty")
@onready var buttons_parent: VBoxContainer = get_node("scroll/vbox")
@onready var weight_parent: Control = get_node("weight")
@onready var weight_bar: ProgressBar = get_node("weight/weightBar")
@onready var pause_menu: PauseMenu = get_tree().get_first_node_in_group("pause_menu")

@export var button_prefab: PackedScene
@export var other_menus: Array[Panel]

var temp_storage: StorageHandler
var categories_codes: Array[String]


func _ready() -> void:
	interaction_controller.open_storage_menu.connect(_on_open_menu)
	interaction_controller.close_menu.connect(_on_close_pressed)


func _process(_delta: float) -> void:
	if !visible: return
	if Input.is_action_just_pressed("ui_cancel"):
		_on_close_pressed()


func _on_open_menu(storage: StorageHandler) -> void:
	interaction_controller.hide_item_hint.emit()
	
	for menu in other_menus:
		if menu.visible: return
	
	if visible:
		_on_close_pressed()
		return
	
	pause_menu.may_pause = false
	movement_controller.may_move = false
	temp_storage = storage
	
	name_label.text = Loc.trans("items." + storage.code + ".name")
	weight_parent.visible = storage.weight > 0
	if weight_parent.visible:
		weight_bar.max_value = storage.weight
		_update_weight()
	
	empty_label.visible = storage.items.is_empty()
	if storage.items.is_empty():
		visible = true
		return
	
	var sorted_items = _sort_items(storage.items)
	var create_categories = len(categories_codes) > 1
	for key in sorted_items.keys():
		_create_item_button(sorted_items[key], create_categories)
		
	visible = true


func _on_close_pressed() -> void:
	temp_storage.close()
	visible = false
	movement_controller.may_move = true
	categories_codes.clear()
	for child in buttons_parent.get_children():
		child.queue_free()
	await get_tree().process_frame
	pause_menu.may_pause = true


func _sort_items(items: Array) -> Dictionary:
	var result = {} 
	
	items.sort_custom(func(a: StorageItem, b: StorageItem): return a.category > b.category)
	var categories_count = {}
	
	for item: StorageItem in items:
		if categories_count.has(item.category):
			categories_count[item.category] += 1
		else:
			categories_count[item.category] = 1
		
		if result.has(item.code):
			result[item.code].count += 1
		else:
			result[item.code] = {}
			result[item.code].count = 1
			result[item.code].item = item
	
	for category in categories_count:
		categories_codes.append(category)
	
	return result


func _create_item_button(item_data: Dictionary, create_category: bool) -> void:
	var item: StorageItem = item_data.item
	
	if create_category and categories_codes.has(item.category):
		_create_category(item.category)
		categories_codes.erase(item.category)
		
	var button: StorageItemButton = button_prefab.instantiate()
	button.item = item
	button.text = Loc.trans("items." + item.code + ".name")
	if item_data.count > 1:
		button.text += " x" + str(item_data.count)
	buttons_parent.add_child(button)
	button.on_click.connect(_on_item_button_click)


func _on_item_button_click(item: StorageItem) -> void:
	temp_storage.get_item(item.code)
	_on_close_pressed()


func _create_category(code: String) -> void:
	var label = Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.text = Loc.trans("interface.categories." + code)
	buttons_parent.add_child(label)
	buttons_parent.add_child(HSeparator.new())


func _update_weight() -> void:
	weight_bar.value = temp_storage.get_items_weight()
