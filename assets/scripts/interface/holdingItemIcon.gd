extends Panel

@onready var interaction_controller: InteractionController = G.player.interaction_controller

@onready var icon: TextureRect = get_node("icon")
@onready var put_hint: TextureRect = get_node("put-hint")
@onready var take_hint: TextureRect = get_node("take-hint")
@onready var craft_hint: Control = get_node("craft-hint")


func _ready() -> void:
	interaction_controller.pickup_item.connect(_on_pickup_item)
	interaction_controller.clear_item.connect(_on_clear_item)
	interaction_controller.show_put_hint.connect(_on_show_put_hint)
	interaction_controller.hide_put_hint.connect(_on_hide_put_hint)
	interaction_controller.show_craft_hint.connect(_on_show_craft_hint)
	interaction_controller.hide_craft_hint.connect(_on_hide_craft_hint)


func _on_show_put_hint() -> void:
	put_hint.visible = true


func _on_hide_put_hint() -> void:
	put_hint.visible = false


func _on_pickup_item(item: Item) -> void:
	icon.texture = item.sprite.texture


func _on_clear_item() -> void:
	icon.texture = null
	put_hint.visible = false


func _on_show_craft_hint() -> void:
	craft_hint.visible = true


func _on_hide_craft_hint() -> void:
	craft_hint.visible = false


func _on_mouse_entered() -> void:
	if interaction_controller.holding_item != null && G.player.using_storage:
		take_hint.visible = true


func _on_mouse_exited() -> void:
	take_hint.visible = false


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
		interaction_controller.take_holding_item_to_storage()
		take_hint.visible = false
