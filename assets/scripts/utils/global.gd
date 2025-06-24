extends Node

class_name Global

const GLASS_MAX_COUNT = 50
var glasses_count: int = 0

var settings: Settings = Settings.new()

@onready var player: Player = get_node("/root/main/player")
@onready var time: TimeHandler = get_node("/root/main/timeHandler")
