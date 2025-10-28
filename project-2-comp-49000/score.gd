extends Node2D

@onready var easyScore = $EasyScore
@onready var mediumScore = $MediumScore
@onready var hardScore = $HardScore

@onready var start = $StartOver
@onready var quit = $Quit

var easylist = []
var mediumlist = []
var hardlist = []

var line = ""

func _ready() -> void:
	loadFiles()
	easylist.sort_custom(sort)
	mediumlist.sort_custom(sort)
	hardlist.sort_custom(sort)
	
	for l in easylist:
		line = l[0] + "..." + str(l[1])
		easyScore.add_item(line)
	
	for l in mediumlist:
		line = l[0] + "..." + str(l[1])
		mediumScore.add_item(line)
	
	for l in hardlist:
		line = l[0] + "..." + str(l[1])
		hardScore.add_item(line)

static func sort(a, b):
		return a[1] > b[1]

func loadFiles() -> void:
	
	if FileAccess.file_exists("res://scoreEasy.data"):
		var file = FileAccess.open("res://scoreEasy.data", FileAccess.READ)
		easylist = file.get_var();
		file.close()
	
	if FileAccess.file_exists("res://scoreMedium.data"):
		var file2 = FileAccess.open("res://scoreMedium.data", FileAccess.READ)
		mediumlist = file2.get_var();
		file2.close()
	
	if FileAccess.file_exists("res://scoreHard.data"):
		var file3 = FileAccess.open("res://scoreHard.data", FileAccess.READ)
		hardlist = file3.get_var();
		file3.close()

func _on_start_over_pressed() -> void:
	get_tree().change_scene_to_file("res://HomePage.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
