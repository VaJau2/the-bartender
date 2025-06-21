extends StaticBody2D

class_name MarketStand

@onready var interaction: MarketStandInteraction = get_node("interaction")

@export var items: Array[ShopItem]
var is_open: bool


func start_trading(npc: CharacterBody2D) -> void:
	npc.global_position = interaction.get_stand_pos()
	interaction.set_open(true)
	is_open = true
