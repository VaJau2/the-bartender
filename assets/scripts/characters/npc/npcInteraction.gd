extends Area2D

class_name NpcInteraction

@export var bar_state: BarState
@export var drunk_handler: DrunkHandler
@export var dialogue_icons: NpcDialogueIcons


@onready var dialogue_menu: DialogueMenu = get_tree().get_first_node_in_group("dialogue_menu")
@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var audi: AudioStreamPlayer2D = get_node("audi")
@onready var npc: NPC = get_parent()


func interact() -> void:
	if bar_state.is_processing():
		check_ordered_drink(interaction_controller.holding_item)
		return
	if npc.dialogue_code != null and npc.dialogue_code != "" and drunk_handler.drunk_timer <= 0:
		dialogue_menu.start_dialogue(npc, npc.dialogue_code)


func check_ordered_drink(drink: Item) -> bool:
	if drink == null: return false
	
	var ordered_drink = bar_state.ordered_drink
	if ordered_drink == "": return false
	
	if drink.code != ordered_drink:
		show_wrong_icon(ordered_drink)
		return false
	else:
		bar_state.have_drink(drink)
		interaction_controller.update_holding_item(null)
		return true


func show_wrong_icon(ordered_drink: String) -> void:
	dialogue_icons.show_wrong_icon()
	await get_tree().create_timer(1).timeout
	if !bar_state.is_processing(): return
	
	dialogue_icons.show_item_icon(ordered_drink)
