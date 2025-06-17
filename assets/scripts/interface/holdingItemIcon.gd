extends Panel


@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var icon: TextureRect = get_node("icon")
@onready var put_hint: TextureRect = get_node("put-hint")


func _ready() -> void:
	interaction_controller.pickup_item.connect(_on_pickup_item)
	interaction_controller.clear_item.connect(_on_clear_item)
	interaction_controller.show_put_hint.connect(_on_show_put_hint)
	interaction_controller.hide_put_hint.connect(_on_hide_put_hint)


func _on_show_put_hint() -> void:
	put_hint.visible = true


func _on_hide_put_hint() -> void:
	put_hint.visible = false


func _on_pickup_item(item: Item) -> void:
	icon.texture = item.sprite.texture


func _on_clear_item() -> void:
	icon.texture = null
	put_hint.visible = false
