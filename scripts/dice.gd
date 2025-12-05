extends RigidBody2D

func _ready():
	$FinalDiceResult.hide()
	linear_damp = 2
	angular_damp = 3
	launch()
	
func _process(delta: float) -> void:
	if not sleeping and is_stopped():
		var final_random_value = randi() % 6 + 1
		linear_velocity = Vector2.ZERO
		angular_velocity = 0
		sleeping = true
		$RollingDice.stop()
		var tex = load("res://assets/sprites/de_" + str(final_random_value) + ".png")
		$FinalDiceResult.texture = tex
		$RollingDice.hide()
		$FinalDiceResult.show()

		
func launch():
	var force = Vector2(randf_range(0, 400), randf_range(0, -600))
	apply_impulse(force)
	angular_velocity = randf_range(-10, 10)

func is_stopped() -> bool:
	return linear_velocity.length() < 5 and abs(angular_velocity) < 1
