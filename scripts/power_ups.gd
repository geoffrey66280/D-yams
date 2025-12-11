extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	display_power_ups()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func display_power_ups():
	for power_up in $TextureRect/PowerUpContainer.get_children():
		power_up.get_random_power_up_and_initiate()
