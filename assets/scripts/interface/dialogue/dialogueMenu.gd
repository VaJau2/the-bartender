extends Panel

class_name DialogueMenu

const DEFAULT_TIMER: float = 0.03

@onready var movement_controller: MovementController = G.player.movement_controller
@onready var pause_menu: PauseMenu = get_tree().get_first_node_in_group("pause_menu")

@onready var text: RichTextLabel = get_node("text")
@onready var avatar: TextureRect = get_node("avatar")
@onready var skip: Label = get_node("skip")
@onready var audi: DialogueAudi = get_node("audi")

var temp_npc: CharacterBody2D
var dialogue_data: Array
var speaker_name: String
var index: int = 0
var node_timer: float = DEFAULT_TIMER
var animation_timer: float = 0


enum TypeEnum {
	phrase,
	change_code
}


func _process(delta: float) -> void:
	if !visible: return
	_animate_text(delta)
	
	if Input.is_action_just_pressed("ui_select"):
		if text.visible_ratio >= 1:
			_next_node()
		else:
			text.visible_ratio = 1


func start_dialogue(npc: NPC, code: String) -> void:
	temp_npc = npc
	temp_npc.state_machine.set_state("talk")
	dialogue_data = _get_dialogue_data(npc.code, code)
	if dialogue_data.is_empty(): return
	index = 0
	_show_node(dialogue_data[index])
	pause_menu.may_pause = false
	movement_controller.may_move = false
	visible = true


func finish_dialogue() -> void:
	temp_npc.state_machine.set_state("idle")
	pause_menu.may_pause = true
	movement_controller.may_move = true
	visible = false


func _show_node(node_data: Dictionary) -> void:
	var type = TypeEnum.get(node_data.type)
	match type:
		TypeEnum.phrase:
			speaker_name = node_data.speaker
			audi.set_config(speaker_name)
			var picture = load("res://assets/sprites/dialogue/" + speaker_name + "/" + node_data.avatar + ".png")
			avatar.texture = picture
			text.text = node_data.text
			node_timer = node_data.timer if node_data.has("timer") else DEFAULT_TIMER
			animation_timer = 0
			text.visible_characters = 0
			skip.visible = false
		TypeEnum.change_code:
			temp_npc.dialogue_code = node_data.value
			_next_node()


func _next_node() -> void:
	index += 1
	if index < len(dialogue_data):
		_show_node(dialogue_data[index])
	else:
		finish_dialogue()


func _animate_text(delta: float) -> void:
	if text.visible_ratio >= 1:
		skip.visible = true
		return
	
	if animation_timer > 0:
		animation_timer -= delta
		return
	
	text.visible_characters += 1
	var symbol = text.text[text.visible_characters - 1]
	var speaker: CharacterBody2D = G.player if speaker_name == "player" else temp_npc
	audi.play_dialogue_sound(text.visible_characters, symbol, speaker)
	animation_timer = _get_timer(node_timer, symbol)


func _get_timer(timer: float, new_symbol: String):
	match new_symbol:
		".", "!", "?": return timer + 0.4
		",": return timer + 0.1
		_: return timer


func _get_dialogue_data(file_name: String, dialogue_name: String) -> Array:
	var json_path = "res://assets/json/" \
		+ str(Enums.Lang.keys()[Loc.current_lang]) \
		+ "/dialogues/" + file_name + ".json"
	
	var json_data: Dictionary = JsonParse.read(json_path)
	if json_data.has(dialogue_name):
		return json_data[dialogue_name].nodes
	return []
