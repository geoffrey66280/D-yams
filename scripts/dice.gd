extends RigidBody2D

var final_random_value = 0

func _ready():
	$FinalDiceResult.hide()
	linear_damp = 2
	angular_damp = 3
	launch()
	
func _process(delta: float) -> void:
	if not sleeping and is_stopped():
		set_process(false)
		sleeping = true
		final_random_value = randi() % 6 + 1
		$RollingDice.stop()
		var tex = load("res://assets/sprites/de_" + str(final_random_value) + ".png")
		$FinalDiceResult.texture = tex
		$RollingDice.hide()
		$FinalDiceResult.show()
		print(final_random_value)
		

		
func launch():
	var force = Vector2(randf_range(0, 800), randf_range(0, -1200))
	apply_impulse(force)
	angular_velocity = randf_range(-1, 10)

func is_stopped() -> bool:
	return linear_velocity.length() < 5 and abs(angular_velocity) < 1
