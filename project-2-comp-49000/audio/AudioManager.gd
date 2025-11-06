extends Node

const MAIN_THEME := preload("res://audio/main_theme.mp3")
const EASY_THEME := preload("res://audio/easy_theme.mp3")
const MEDIUM_THEME := preload("res://audio/median_theme.mp3")
const HARD_THEME := preload("res://audio/hard_theme.mp3")
const CLICK_SFX := preload("res://audio/mouse-click.mp3")
const CORRECT_SFX := preload("res://audio/yay.mp3")

var _music_player: AudioStreamPlayer
var _sfx_player: AudioStreamPlayer
var _current_music: AudioStream

func _ready() -> void:
	_setup_players()
	# Default to main theme when the project boots.
	play_main_theme()

func _setup_players() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.name = "MusicPlayer"
	_music_player.bus = _safe_bus("Music")
	_music_player.finished.connect(_on_music_finished)
	add_child(_music_player)
	
	_sfx_player = AudioStreamPlayer.new()
	_sfx_player.name = "SfxPlayer"
	_sfx_player.bus = _safe_bus("SFX")
	add_child(_sfx_player)

func play_main_theme() -> void:
	_play_music(MAIN_THEME)

func play_theme_for_level(level: String) -> void:
	match level:
		"easy":
			_play_music(EASY_THEME)
		"medium", "median":
			_play_music(MEDIUM_THEME)
		"hard":
			_play_music(HARD_THEME)
		_:
			play_main_theme()

func stop_music() -> void:
	if _music_player and _music_player.playing:
		_music_player.stop()
	_current_music = null

func play_click() -> void:
	_play_sfx(CLICK_SFX)

func play_correct() -> void:
	_play_sfx(CORRECT_SFX)

func _play_music(stream: AudioStream) -> void:
	if not stream:
		return
	if _current_music == stream and _music_player and _music_player.playing:
		return
	if _music_player:
		_music_player.stop()
		_music_player.stream = stream
		_music_player.play()
	_current_music = stream

func _play_sfx(stream: AudioStream) -> void:
	if not stream or not _sfx_player:
		return
	# Restarting ensures rapid clicks still retrigger audio.
	_sfx_player.stop()
	_sfx_player.stream = stream
	_sfx_player.play()

func _on_music_finished() -> void:
	# Manual loop so every imported stream keeps playing.
	if _current_music and _music_player:
		_music_player.play()

func _safe_bus(bus_name: String) -> String:
	if AudioServer.get_bus_index(bus_name) != -1:
		return bus_name
	return "Master"
