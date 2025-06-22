extends Area2D

class_name Radio

@export var anim: AnimationPlayer
@export var songs: Array[AudioStream]
@export var switch: AudioStream
@export var noise: AudioStream

@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var song_player: AudioStreamPlayer2D = get_node("song")
@onready var noise_player: AudioStreamPlayer2D = get_node("noise")

var is_playing: bool
var song_index: int

func _ready() -> void:
	_randomize_songs()
	_play_song()
	song_player.volume_linear = 0


func interact() -> void:
	interaction_controller.hide_item_hint.emit()
	
	if is_playing:
		anim.play("RESET")
	else:
		anim.play("play")
	
	noise_player.stream = switch;
	noise_player.play()


func on_mouse_entered() -> void:
	interaction_controller.show_hint.emit("radio")


func on_mouse_exited() -> void:
	interaction_controller.hide_item_hint.emit()


func _on_song_finished() -> void:
	if song_index < len(songs) - 1: 
		song_index += 1
		
	else:
		_randomize_songs()
	
	_play_song()


func _randomize_songs() -> void:
	songs.shuffle()
	song_index = 0


func _play_song() -> void:
	song_player.stream = songs[song_index]
	song_player.play()


func _on_noise_finished() -> void:
	if noise_player.stream != switch:
		return
	
	if is_playing:
		anim.play("RESET")
		song_player.volume_linear = 0
		
	else:
		anim.play("play")
		song_player.volume_linear = G.settings.music_volume
		noise_player.stream = noise
		noise_player.play()
	
	is_playing = !is_playing
		
