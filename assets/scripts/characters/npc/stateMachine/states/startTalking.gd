extends State

const TALK_DISTANCE: float = 60

@onready var dialogue_menu: DialogueMenu = get_tree().get_first_node_in_group("dialogue_menu")

var npc: NPC
var player: Player
var going_to_player: bool = false


func init() -> void:
	super()
	player = G.player
	npc = state_machine.npc
	movement_controller.came_to_point.connect(_on_came)


func enable() -> void:
	if npc.dialogue_code == null or npc.dialogue_code == "":
		state_machine.set_state("idle")
	movement_controller.stop_navigation()
	movement_controller.set_came_distance(TALK_DISTANCE)
	going_to_player = false
	super()


func _process(_delta: float) -> void:
	if !player.movement_controller.may_move or going_to_player: return
	movement_controller.set_target(player.global_position)
	going_to_player = true


func _on_came() -> void:
	if !is_processing(): return
	if !going_to_player: return
	
	if npc.dialogue_code != null and npc.dialogue_code != "":
		dialogue_menu.start_dialogue(npc, npc.dialogue_code)
