extends Area2D

@export var bar_state: BarState
@export var dialogue: NpcDialogue
@export var sale_sound: AudioStream

@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var audi: AudioStreamPlayer2D = get_node("audi")


func interact() -> void:
	if !bar_state.is_processing(): return
	
	var player_drink = interaction_controller.holding_item
	if player_drink == null: return
	
	var ordered_drink = bar_state.ordered_drink
	if ordered_drink == "": return
	
	if player_drink.code != ordered_drink:
		dialogue.show_wrong_icon()
		
		await get_tree().create_timer(1).timeout
		if !bar_state.is_processing(): return
		
		dialogue.show_item_icon(ordered_drink)
	else:
		if G.glasses_count > 0: G.glasses_count -= 1
		G.statistics.drinks_sold += 1
		player_drink.queue_free()
		interaction_controller.update_holding_item(null)
		dialogue.set_transparency(1)
		dialogue.show_thanks_icon()
		
		if bar_state.ordered_price > 0:
			M.add_money(bar_state.ordered_price)
			audi.stream = sale_sound
			audi.play()
		
		bar_state.ordered_drink = ""
		
		await get_tree().create_timer(1).timeout
		if !bar_state.is_processing(): return
		
		bar_state.state_machine.set_state("idle")
