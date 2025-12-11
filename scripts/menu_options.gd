extends Control

@onready var slider_volume = $HUD_Fond/Volume
@onready var full_screen_button = $HUD_Fond/Fullscreen_Button
@onready var menu_resolution = $HUD_Fond/ScreenSettings_Button

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


func _on_exit_button_pressed():
	print("Fermeture du jeu...")
	get_tree().quit()


func _on_menu_button_button_up() -> void:
	visible = false


func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value / 5)
