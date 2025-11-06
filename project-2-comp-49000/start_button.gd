extends Button


func _ready() -> void:
	AudioManager.play_main_theme()

func _on_pressed() -> void:
	AudioManager.play_click()
	print("Start Button pressed")
	get_tree().change_scene_to_file("res://NameSelect.tscn")
