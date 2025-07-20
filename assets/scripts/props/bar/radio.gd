extends Area2D

class_name Radio

const INSIDE_BAR_DISTANCE: int = 200
const SONGS_PATH: String = "res://assets/audio/radio/songs"

@export var anim: AnimationPlayer

@export var switch: AudioStream
@export var noise: AudioStream

@onready var interaction_controller: InteractionController = G.player.interaction_controller
@onready var radio_menu: RadioMenu = get_node("/root/main/menu/interface/radioMenu")
@onready var song_player: AudioStreamPlayer2D = get_node("song")
@onready var noise_player: AudioStreamPlayer2D = get_node("noise")
@onready var songsFileNames: PackedStringArray = ResourceLoader.list_directory(SONGS_PATH)

var songs: Array[AudioStream]
var is_playing: bool
var is_inside_bar: bool
var song_index: int


func _ready() -> void:	
	for filename in songsFileNames:
		if filename.contains(".import"): continue
		var song: AudioStream = load(SONGS_PATH + "/" + filename)
		songs.push_back(song)
	
	_randomize_songs()
	_play_song()
	radio_menu.changed_volume.connect(_on_music_volume_changed)


func interact() -> void:
	interaction_controller.hide_item_hint.emit()
	interaction_controller.show_radio_menu.emit(self)


func check_inside_bar() -> void:
	var bar: Node2D = get_tree().get_first_node_in_group("bar")
	var distance = bar.global_position.distance_to(global_position)
	is_inside_bar = distance < INSIDE_BAR_DISTANCE


func is_working() -> bool:
	return is_playing and is_inside_bar


func on_mouse_entered() -> void:
	interaction_controller.show_hint.emit("radio")


func on_mouse_exited() -> void:
	interaction_controller.hide_item_hint.emit()


func _on_music_volume_changed() -> void:
	if G.settings.music_volume == 0 && is_playing:
		noise_player.stream = switch
		noise_player.play()
		is_playing = false
	elif G.settings.music_volume > 0 && !is_playing:
		noise_player.stream = switch
		noise_player.play()
		is_playing = true


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
		anim.play("play")
		noise_player.stream = noise
		noise_player.play()
				
	else:
		anim.play("RESET")
