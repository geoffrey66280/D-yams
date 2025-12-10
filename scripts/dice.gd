extends RigidBody2D

# La variable rollingDice correspond à l'animation du dè qui est lancé
# la variable FinalDiceResult représente l'état d'un dè immobile
var base_position = 0
var last_position = 0
var allowed_values = []
signal dice_value(result)
signal kept(result, index)
var final_random_value = 0
var throwable = true

# récupère toutes les faces du dès actuel et son index
@warning_ignore("unused_parameter")
func set_level_information(dice_values, dice_index, is_throwable):
	allowed_values = dice_values
	throwable = is_throwable
	
func _ready():
	base_position = global_transform.origin
	last_position = global_transform.origin
	$RollingDice.hide()
	linear_damp = 2
	angular_damp = 3
	
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	# si le dès n'est plus en mouvement
	if not sleeping and is_stopped():
		# si le dès n'a aucune face ne rien faire
		if !(allowed_values.size() == 0):
			sleeping = true
			# change la seed aléatoire pour la génération de chiffres
			randomize()
			# arréter le process car sinon se relance très vite et duplique les résultats
			set_process(false)
			# Résultat du dé aléatoire selon la liste des faces du dè actuel
			final_random_value = int(allowed_values[randi() % allowed_values.size()])
			$RollingDice.stop()
			# affichage de la texture du dé immobile
			var tex = load("res://assets/sprites/de_" + str(final_random_value) + ".png")
			$FinalDiceResult.texture = tex
			$RollingDice.hide()
			$FinalDiceResult.show()
			# Envoi de la valeur du dé au parent (throwing dice)
			emit_signal('dice_value', final_random_value, get_index())
		
# Lance le dé avec une force aléatoire
func launch():
	if(throwable):
		set_process(true)
		$FinalDiceResult.hide()
		$RollingDice.play()
		$RollingDice.show()
		var force = Vector2(randf_range(0, 400), randf_range(0, -600))
		apply_impulse(force)
		angular_velocity = randf_range(-1, 10)
		
# Renvoie si le dès est proche de s'arréter
func is_stopped() -> bool:
	return linear_velocity.length() < 20 and abs(angular_velocity) < 1
	
func reset_dice_position():
	if(global_transform.origin == base_position):
		global_transform.origin = last_position
	else:
		last_position = global_transform.origin
		global_transform.origin = base_position
	rotation = 0

func reset_right_position():
	last_position = global_transform.origin
	global_transform.origin = base_position
	
@warning_ignore("unused_parameter")
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if(throwable):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			emit_signal("kept", final_random_value, get_index())
			reset_dice_position()

func animate_score(pitch):
	$ScoreAnimation.play("score")
	$ScoreSound.pitch_scale = pitch
	$ScoreSound.play()
	await get_tree().create_timer(0.5).timeout

func play_rolling_song():
	pass
