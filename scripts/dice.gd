extends Node2D


func _process(delta: float) -> void:
	position.y -= 5

func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.frame = 0
	set_process(false)
