extends StaticBody2D

class_name StandBase

@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var interaction: MarketStandInteraction = get_node("interaction")
@onready var audi: AudioStreamPlayer2D = get_node("audi")

@export var code: String = "shop"

var is_open: bool


func start_trading(npc: CharacterBody2D) -> void:
	npc.global_position = interaction.get_stand_pos()
	interaction.set_open(true)
	is_open = true


func stop_trading() -> void:
	interaction.set_open(false)
	is_open = false
