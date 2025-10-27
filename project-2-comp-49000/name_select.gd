extends Node2D

@onready var line_edit = $CenterContainer/LineEdit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect the text_submitted signal (fires when Enter is pressed)
	line_edit.text_submitted.connect(_on_line_edit_text_submitted)

	line_edit.grab_focus()

func _on_line_edit_text_submitted(new_text: String):
	# Set the global variable
	Global.playername = new_text

	print("Player name set to: ", Global.playername)

	# Transition to next scene
	get_tree().change_scene_to_file("res://Difficulty.tscn")
