extends RigidBody2D

var allowed_values = []
signal dice_value(result)

func set_level_information(dice_values, dice_index):
	allowed_values = dice_values
	
	

func _ready():
	$RollingDice.hide()
	linear_damp = 2
	angular_damp = 3
	
	
func _process(delta: float) -> void:
	if not sleeping and is_stopped():
		if !(allowed_values.size() == 0):
			sleeping = true
			randomize()
			set_process(false)
			var final_random_value = allowed_values[randi() % allowed_values.size()]
			$RollingDice.stop()
			var tex = load("res://assets/sprites/de_" + str(final_random_value) + ".png")
			$FinalDiceResult.texture = tex
			$RollingDice.hide()
			$FinalDiceResult.show()
			emit_signal('dice_value', final_random_value)
		
func launch():
	$FinalDiceResult.hide()
	$RollingDice.show()
	var force = Vector2(randf_range(0, 800), randf_range(0, -1200))
	apply_impulse(force)
	angular_velocity = randf_range(-1, 10)

func is_stopped() -> bool:
	return linear_velocity.length() < 20 and abs(angular_velocity) < 1
