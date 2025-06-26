extends Node

class_name Global

const DAYS_GOAL: int = 7
const MONEY_GOAL: int = 1000

const GLASS_MAX_COUNT = 50
var glasses_count: int = 0

var settings: Settings = Settings.new()
var statistics: Statistics = Statistics.new()

var player: Player
var time: TimeHandler
var game_manager: GameManager


signal lang_changed


func _ready() -> void:
	player = get_node_or_null("/root/main/player")
	time = get_node_or_null("/root/main/timeHandler")
	game_manager = get_node_or_null("/root/main/gameManager")
