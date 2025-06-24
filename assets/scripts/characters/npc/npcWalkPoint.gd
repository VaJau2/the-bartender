extends Node2D

class_name NpcWalkPoint

@export var wait_min_time: float
@export var wait_max_time: float
@export var movement_state_name: String = "walk"
@export var is_flip: bool

@onready var point: Node2D = get_node_or_null("point")

var is_busy: bool
