
extends Area2D

@export var bit_value: int = 1  # Set this in inspector: 128, 64, 32, 16, 8, 4, 2, 1
@export var bit_index: int = 0  # Set this in inspector: 7, 6, 5, 4, 3, 2, 1, 0

@onready var bit_label = $BitLabel  # Adjust path if your label has different name
@onready var background = $Background  # If you have a ColorRect for background

var is_on: bool = false

# Colors for visual feedback
var color_off = Color(0.2, 0.2, 0.3)
var color_on = Color(0.3, 0.8, 0.5)

signal bit_toggled(bit_index, is_on, bit_value)

func _ready():
	input_event.connect(_on_input_event)
	update_display()

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			toggle()

func toggle():
	is_on = !is_on
	update_display()
	bit_toggled.emit(bit_index, is_on, bit_value)

func update_display():
	if is_on:
		bit_label.text = "1"
		if background:
			background.color = color_on
	else:
		bit_label.text = "0"
		if background:
			background.color = color_off

func reset():
	is_on = false
	update_display()
