extends Control

signal power_up_chosen()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var power_ups = $TextureRect/PowerUpContainer.get_children()
	for power_up in power_ups:
		power_up.connect("hide_power_ups", Callable(self, "_on_power_up_chosen"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func display_power_ups():
	var power_ups = LevelInformation.power_ups
	visible = true
	for power_up in $TextureRect/PowerUpContainer.get_children():
		power_up.get_random_power_up_and_initiate(power_ups)

func _on_power_up_chosen():
	visible = false
	emit_signal("power_up_chosen")


func _on_throwing_dices_show_power_up() -> void:
	display_power_ups()
