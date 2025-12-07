extends Control

@onready var menu_options = $MenuOptions

func _ready():
	menu_options.visible = false

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_options_button_pressed():
	menu_options.visible = not menu_options.visible

func _on_exit_button_pressed():
	get_tree().quit()
