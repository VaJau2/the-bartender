extends CharacterBody2D

class_name NPC

@export var code: String
@export var work_place: MarketStand

@onready var dialogue: NpcDialogue = get_node("dialogue")
