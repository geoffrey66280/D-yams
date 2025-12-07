extends Control

@onready var full_screen_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/CheckButton
@onready var slider_volume = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/HSlider
@onready var menu_resolution = $PanelContainer/MarginContainer/VBoxContainer/OptionButton

func _ready():
	visible = false
	full_screen_button.toggled.connect(_on_full_screen_toggled)
	menu_resolution.item_selected.connect(_on_resolution_selected)

func _on_full_screen_toggled(est_actif):
	if est_actif:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_resolution_selected(index):
	if index == 0:
		DisplayServer.window_set_size(Vector2i(1920, 1080))
	elif index == 1:
		DisplayServer.window_set_size(Vector2i(1280, 720))
