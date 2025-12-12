extends Control

var current_power_up = {}
signal hide_power_ups()
var level_info = LevelInformation.level_information

func get_random_power_up_and_initiate(power_ups: Array):
	var pool: Array = []
	for p in power_ups:
		var weight = 4 - p.rarity
		for i in range(weight):
			pool.append(p)

	if pool.is_empty():
		return null

	randomize()
	var index = randi() % pool.size()
	current_power_up = pool[index]
	$Background/PowerUpContainer/PowerUpNameButton/PowerUpNameLabel.text = pool[index]["name"]
	$Background/PowerUpContainer/PowerUpDescriptionLabel.text = pool[index]["description"]
	
# passif
# changer la valeur d'une face d'un dé dans levelinfo en récupérant l'index du dé
# l'index de la valeur à remplacer et la valeur à mettre
func replace_dice_value_forever(dice_index: int, value_index: int, value: int):
	var dices_values = level_info["user_dices"][dice_index]
	dices_values[value_index] = value

# passif
func get_extra_reroll():
	level_info["throwing_reset"] += 1

# one shot
func reroll_one_dice():
	pass
	
# one shot
# si half est true alors diamond multiplier *2 dans levelinfo
func change_next_round_score(half = null, double = null):
	var next_level = level_info["actual_lvl"] + 1
	if(double == true):
		level_info["score_to_reach"][next_level] *= 2
	if(half == true):
		level_info["score_to_reach"][next_level] / 2
		level_info["diamond_multiplier"] += 1

# one shot
# valider la combinaison meme si la combinaison n'est pas faite
func automatically_valid_combination(combination_name: String):
	pass
	
# one shot
func add_twenty_percent_score(score: int):
	pass
	
# passif
# changer le random
func favors_dice_values(high = null, low = null):
	pass
	
# one shot
# changer actual_lvl et diamond multiplier dans levelinfo
func skip_next_level():
	level_info["actual_lvl"] += 1
	level_info["diamond_multiplier"] += 1
	
# one shot
func reverse_dices_values():
	var user_dices = level_info["user_dices"]
	for dice in user_dices:
		for dice_value in dice:
			if dice_value == 1:
				dice[dice_value] = 6
				
			elif dice_value == 2:
				dice[dice_value] = 5
				
			elif dice_value == 3:
				dice[dice_value] = 4
				
			elif dice_value == 4:
				dice[dice_value] = 3
				
			elif dice_value == 5:
				dice[dice_value] = 2
			
			elif dice_value == 6:
				dice[dice_value] = 1
				
	


func _on_background_mouse_entered() -> void:
	$Background.texture = preload("res://assets/sprites/options_fond_hover.png")


func _on_background_mouse_exited() -> void:
		$Background.texture = preload("res://assets/sprites/options_fond.png")


func _on_power_up_chosen(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		level_info["user_power_ups"].append(current_power_up)
		current_power_up = {}
		emit_signal("hide_power_ups")
	
func use():
	print("utilisation du power up")
