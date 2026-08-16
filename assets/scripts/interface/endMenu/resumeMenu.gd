extends Control

class_name ResumeMenu

const STATISTICS_CODE: String = "statistics"
const FINANCE_CODE: String = "financial_results"
const DELAY: float = 0.5

@export var blurAnim: AnimationPlayer
@export var interface: Control
@export var pause_menu: PauseMenu
@export var skip: Skip
@export var finances_labels: Array[StatisticsCountLabel]
@export var statistics_labels: Array[StatisticsCountLabel]
@export var paid_stamp: PaidStamp
@export var drinks_table: DrinksTable
@export var finance_page: Control
@export var continue_button: Button
@export var resume_button: Button

@export var win_music: AudioStream
@export var lose_music: AudioStream
@export var stamp_sound: AudioStream
@export var ticks_sounds: Array[AudioStream]

@onready var music_player: AudioStreamPlayer = get_node("music")
@onready var sound_player: AudioStreamPlayer = get_node("sound")
@onready var anim: AnimationPlayer = get_node("anim")
@onready var titles: Titles = get_node("titles")

@onready var interaction_controller: InteractionController = G.player.interaction_controller

var is_finances_calc_done: bool
var is_stats_calc_done: bool
var label_index: int

var timer: SceneTreeTimer


func _ready() -> void:
	for label in finances_labels:
		label.calculating_done.connect(on_calculating_done)
	for label in statistics_labels:
		label.calculating_done.connect(on_calculating_done)
	continue_button.pressed.connect(hide_resume)
	resume_button.pressed.connect(change_page)


func show_resume() -> void:
	Engine.time_scale = 1
	get_tree().paused = true
	interface.visible = false
	pause_menu.may_pause = false
	visible = true
	drinks_table._ready()
	titles.update_text()
	blurAnim.play("show")
	anim.play("show-resume")
	resume_button.text = Loc.trans("interface.resume." + STATISTICS_CODE)
	
	if paid_stamp.is_paid():
		music_player.stream = win_music
	else:
		music_player.stream = lose_music
	music_player.play()
	
	await get_tree().create_timer(anim.current_animation_length).timeout
	
	_play_tick_sound()
	finances_labels[0].calculate()


func on_calculating_done(with_delay: bool, play_stamp_sound: bool) -> void:
	sound_player.stop()
	
	if play_stamp_sound:
		sound_player.stream = stamp_sound
		sound_player.play()
		await get_tree().create_timer(stamp_sound.get_length()).timeout
	
	var labels: Array
	
	if (!is_finances_calc_done):
		labels = finances_labels
	elif (!is_stats_calc_done):
		labels = statistics_labels
	else:
		return
	
	if with_delay:
		await get_tree().create_timer(DELAY).timeout
	
	if label_index < labels.size() - 1:
		_play_tick_sound()
		label_index += 1
		labels[label_index].calculate()
		return
	
	if !is_finances_calc_done:
		paid_stamp.put_stamp()
		sound_player.stream = stamp_sound
		sound_player.play()
		is_finances_calc_done = true
	elif !is_stats_calc_done:
		is_stats_calc_done = true
	
	await get_tree().create_timer(DELAY).timeout
	anim.play("show-buttons")


func hide_resume() -> void:
	continue_button.disabled = true
	skip.on(_end)
	anim.animation_finished.connect(_on_anim_end)
	anim.play("show-titles")


func _on_anim_end(anim_name: String) -> void:
	if anim_name == "show-titles":
		_end()


func _end() -> void:
	M.remove_money(G.MONEY_GOAL)
	M.money_force_updated.emit()
	blurAnim.play("hide")
	music_player.stop()
	anim.animation_finished.disconnect(_on_anim_end)
	skip.off()
	get_tree().paused = false
	interface.visible = true
	pause_menu.may_pause = true
	visible = false
	interaction_controller.close_menu.emit()
	G.game_manager.set_freeplay()


func change_page() -> void:
	finance_page.visible = !finance_page.visible
		
	var code: String
	if (finance_page.visible):
		code = STATISTICS_CODE
	else:
		code = FINANCE_CODE
	
	resume_button.text = Loc.trans("interface.resume." + code)
	
	if is_stats_calc_done:
		return
	
	anim.play("hide-buttons")
	_play_tick_sound()
	label_index = 0
	statistics_labels[0].calculate()


func _play_tick_sound() -> void:
	var index = randi_range(0, ticks_sounds.size() -1)
	var tick = ticks_sounds[index]
	sound_player.stream = tick
	sound_player.play()
