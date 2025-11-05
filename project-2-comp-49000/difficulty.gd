extends Node2D

func _ready() -> void:
	displayLevel()

func _on_easy_pressed() -> void:
	AudioManager.play_click()
	Global.level = "easy"
	displayLevel()
	AudioManager.play_theme_for_level(Global.level)
	changeScene()

func _on_medium_pressed() -> void:
	AudioManager.play_click()
	Global.level = "medium"
	displayLevel()
	AudioManager.play_theme_for_level(Global.level)
	changeScene()

func _on_hard_pressed() -> void:
	AudioManager.play_click()
	Global.level = "hard"
	displayLevel()
	AudioManager.play_theme_for_level(Global.level)
	changeScene()

func changeScene() -> void:
	get_tree().change_scene_to_file("res://Game.tscn")

func displayLevel() -> void:
	print(Global.level)
