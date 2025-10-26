extends Button


func ready() -> void:
	pass

func _on_pressed() -> void:
	print("Start Button pressed")
	get_tree().change_scene_to_file("res://Difficulty.tscn")
