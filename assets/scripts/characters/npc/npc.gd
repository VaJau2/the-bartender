extends CharacterBody2D

class_name NPC

@export var code: String
@export var work_place: StandBase
@export var sleep_place: Node2D
@export var dialogue_code: String = ""
@export var talk_on_start: bool = false

@onready var dialogue_icons: NpcDialogueIcons = get_node("dialogueIcons")
@onready var state_machine: StateMachine = get_node("stateMachine")
@onready var drunk_handler: DrunkHandler = get_node("drunkHandler")
@onready var interaction: NpcInteraction = get_node("interactionArea")
@onready var mouth: Sprite2D = get_node("mouth")


var walk_state: String = "walk"


func _ready() -> void:
	if talk_on_start:
		await get_tree().create_timer(state_machine.DELAY).timeout
		state_machine.set_state("startTalking")


func animate_mouth(time: float = 0):
	if time > 0:
		mouth.visible = true
		await get_tree().create_timer(time).timeout
		mouth.visible = false
