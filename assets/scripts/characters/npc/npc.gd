extends CharacterBody2D

class_name NPC

@export var code: String
@export var work_place: MarketStand
@export var sleep_place: Node2D

@onready var dialogue: NpcDialogue = get_node("dialogue")
@onready var drunk_handler: DrunkHandler = get_node("drunkHandler")

var walk_state: String = "walk"
