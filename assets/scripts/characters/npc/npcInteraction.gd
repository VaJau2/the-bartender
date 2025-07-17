extends Area2D

@export var bar_state: BarState
@export var drunk_handler: DrunkHandler
@export var dialogue_icons: NpcDialogueIcons
@onready var bar_front_area: PutArea = get_tree().get_first_node_in_group("bar_front_area")

@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var audi: AudioStreamPlayer2D = get_node("audi")


func _ready() -> void:
	bar_front_area.put_item.connect(_on_put_front_item)


func interact() -> void:
	if bar_state.is_processing():
		check_ordered_drink(interaction_controller.holding_item)


func _on_put_front_item(item: Item) -> void:
	if bar_state.is_processing():
		check_ordered_drink(item)


func check_ordered_drink(drink: Item) -> void:
	if drink == null: return
	
	var ordered_drink = bar_state.ordered_drink
	if ordered_drink == "": return
	
	if drink.code != ordered_drink:
		dialogue_icons.show_wrong_icon()
		
		await get_tree().create_timer(1).timeout
		if !bar_state.is_processing(): return
		
		dialogue_icons.show_item_icon(ordered_drink)
	else:
		bar_state.have_drink(drink)
		interaction_controller.update_holding_item(null)
