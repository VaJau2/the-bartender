extends CharacterBody2D

class_name NPC

@export var code: String
@export var work_place: StandBase
@export var sleep_place: Node2D

@onready var dialogue_icons: NpcDialogueIcons = get_node("dialogueIcons")
@onready var drunk_handler: DrunkHandler = get_node("drunkHandler")

var walk_state: String = "walk"
