extends Node2D

func _ready() -> void:
	displayLevel()

func _on_easy_pressed() -> void:
	Global.level = "easy"
	displayLevel()
	changeScene()

func _on_medium_pressed() -> void:
	Global.level = "medium"
	displayLevel()
	changeScene()

func _on_hard_pressed() -> void:
	Global.level = "hard"
	displayLevel()
	changeScene()

func changeScene() -> void:
	get_tree().change_scene_to_file("res://Game.tscn")

func displayLevel() -> void:
	print(Global.level)
