extends Node

@onready var bits_container = $"CenterContainer/Game Area/Bits"
@onready var target_label = $"CenterContainer/Game Area/target number"
@onready var score_label = $"TopBar/Score"
@onready var timer_label = $"TopBar/Timer"
@onready var current_value_label = $"CenterContainer/Game Area/current value"
@onready var tutorial_overlay = $tutorial
@onready var continue_label = $continue

# Tutorial steps
@onready var steps = [
	$tutorial/step1,
	$tutorial/step2, 
	$tutorial/step3,
	$tutorial/step4,
	$tutorial/step5, 
	$tutorial/step6
]

# Tutorial state
var current_step: int = 0
var tutorial_active: bool = true

# Array to hold all bit nodes
var bits = []

# Game state
var target_number: int = 0
var current_value: int = 0
var score: int = 0
var time_remaining: float = 60.0  # Default 60 seconds, adjust as needed
var is_game_active: bool = false
var game_started: bool = false  # Track if game has ever started

func _ready():
	initialize_bits()
	Disable_all_bits()
	reset_bits()
	setup_tutorial()
	# show_start_screen()
	
	if Global.level == "medium" or Global.level == "hard":
		current_value_label.visible = false
	

func setup_tutorial():
	# Hide all steps except the first one
	for i in range(steps.size()):
		if i == 0:
			steps[i].visible = true
		else:
			steps[i].visible = false
	
	
func advance_tutorial():
	# Hide current step
	steps[current_step].visible = false
	
	# Move to next step
	current_step += 1
	
	# Check if tutorial is complete
	if current_step >= steps.size():
		end_tutorial()
	else:
		# Show next step
		steps[current_step].visible = true
		print("Now showing Step ", current_step + 1)

func end_tutorial():
	tutorial_active = false
	tutorial_overlay.visible = false
	
	print("Tutorial Complete!")
	
	continue_label.text = "Try it out!"
	
	show_start_screen()

func initialize_bits():
	# Get all bit children from the Bits container
	for i in range(bits_container.get_child_count()):
		var bit = bits_container.get_child(bits_container.get_child_count()-i-1)
		
		print(i)
		# Set the bit's properties
		bit.bit_index = i
		bit.bit_value = int(pow(2, i))  # 2^i: 1, 2, 4, 8, 16, 32, 64, 128
		
		# Connect to the bit's toggle signal
		bit.bit_toggled.connect(_on_bit_toggled)
		
		bit.update_values()
		
		# Add to our bits array
		bits.append(bit)
	
	print("Initialized ", bits.size(), " bits")

func show_start_screen():
	is_game_active = false
	game_started = false

	# Show start message
	target_label.text = "Press SPACE to start"

	# Initialize displays
	score = 0
	time_remaining = 60.0
	update_score_display()
	update_timer_display()

	# Reset bits
	reset_bits()

func start_game():
	score = 0
	time_remaining = 600.0  
	is_game_active = true
	game_started = true
	continue_label.text = "Press SPACE to exit tutorial"
	Enable_all_bits()
	
	update_score_display()
	generate_new_target()

func _process(delta):
	if is_game_active:
		time_remaining -= delta
		update_timer_display()
		
		if time_remaining <= 0:
			end_game()

func _on_bit_toggled(_bit_index, _is_on, _bit_value):
	calculate_current_value()
	check_if_correct()

func calculate_current_value():
		
	
	current_value = 0
	
	for bit in bits:
		if bit.is_on:
			current_value += bit.bit_value
	
	# Update display of current value label
	current_value_label.text = "%d" % current_value

func check_if_correct():
	if current_value == target_number:
		# Correct answer!
		score += 1
		update_score_display()
		
		print("Correct! Score: ", score)
		
		# Reset and generate new target
		reset_bits()
		generate_new_target()

func generate_new_target():
	# Generate a random number between 1-255 (for 8 bits)
	target_number = (randi() % 255) + 1
	target_label.text = str(target_number)
	
	print("New target: ", target_number)

func reset_bits():
	for bit in bits:
		bit.reset()
	current_value = 0
	

	current_value_label.text = "0"

func update_score_display():
	score_label.text = "Score: %d" % score

func update_timer_display():
	var minutes = int(time_remaining) / 60.0
	var seconds = int(time_remaining) % 60
	timer_label.text = "Time: %d:%02d" % [minutes, seconds]
	
func Disable_all_bits():
	for i in bits:
		i.disableBit()

func Enable_all_bits():
	for i in bits:
		i.enableBit()

func end_game():
	is_game_active = false
	time_remaining = 0
	update_timer_display()  # Show 0:00
	reset_bits()
	
	# save info on file
	#saveFile()
	#Global.reset();
	
	# Show game over message
	#target_label.text = "GAME OVER\nPress SPACE to play again"

	print("Game Over! Final Score: ", score)
	
	get_tree().change_scene_to_file("res://HomePage.tscn")

func _input(event):
	if tutorial_active and event.is_action_pressed("ui_accept"):  # Spacebar
		advance_tutorial()
		return

	if is_game_active and event.is_action_pressed("ui_accept"):
		if game_started:
			is_game_active = false
			game_started = false
			end_game()
	
	# Add restart with spacebar or something
	if not is_game_active and event.is_action_pressed("ui_accept"):
		if game_started:
			# Game over, restart
			end_game()
		else:
			# First time starting
			start_game()

func reset_game():
	# Reset all game state
	score = 0
	time_remaining = 60.0
	current_value = 0

	# Reset bits
	reset_bits()

	# Update all displays
	update_score_display()
	update_timer_display()

	# Generate new target (this will replace the game over text)
	generate_new_target()

	# Restart the game
	is_game_active = true
	print("Game restarted!")

func saveFile() -> void:
	var list = []
	
	var filepath = ""
	
	if Global.level == "easy":
		filepath = 'res://scoreEasy.data'
	if Global.level == "medium":
		filepath = 'res://scoreMedium.data'
	if Global.level == "hard":
		filepath = 'res://scoreHard.data'
	
	if FileAccess.file_exists(filepath):
		var file = FileAccess.open(filepath, FileAccess.READ)
		list = file.get_var()
		list.append([Global.playername,score])
		
		file = FileAccess.open(filepath, FileAccess.WRITE)
		file.store_var(list)
		file.close()
	else:
		var file = FileAccess.open(filepath, FileAccess.WRITE)
		list.append([Global.playername,score])
		file.store_var(list)
		file.close()
