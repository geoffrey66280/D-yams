extends RigidBody2D

func _ready():
	linear_damp = 2
	angular_damp = 3
	launch()
	
func _process(delta: float) -> void:
	if not sleeping and is_stopped():
		linear_velocity = Vector2.ZERO
		angular_velocity = 0
		sleeping = true
		$RollingDice.stop()
		$RollingDice.frame = 6
		
func launch():
	var force = Vector2(randf_range(0, 400), randf_range(0, -600))
	apply_impulse(force)
	angular_velocity = randf_range(-10, 10)

func is_stopped() -> bool:
	return linear_velocity.length() < 5 and abs(angular_velocity) < 1
