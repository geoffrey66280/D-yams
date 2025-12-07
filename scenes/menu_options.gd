extends Control

@onready var bouton_plein_ecran = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/CheckButton
@onready var slider_volume = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/HSlider
@onready var menu_resolution = $PanelContainer/MarginContainer/VBoxContainer/OptionButton

func _ready():
	visible = false
	bouton_plein_ecran.toggled.connect(_on_plein_ecran_toggled)
	menu_resolution.item_selected.connect(_on_resolution_selected)

func _on_plein_ecran_toggled(est_actif):
	if est_actif:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_resolution_selected(index):
	if index == 0:
		DisplayServer.window_set_size(Vector2i(1920, 1080))
	elif index == 1:
		DisplayServer.window_set_size(Vector2i(1280, 720))
