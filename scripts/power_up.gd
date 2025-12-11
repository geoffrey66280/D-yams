extends Control

var current_power_up = {}
signal hide_power_ups()

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
	
	
# changer la valeur d'une face d'un dé dans levelinfo en récupérant l'index du dé
# l'index de la valeur à remplacer et la valeur à mettre
func replace_dice_value_forever(dice_index: int, value_index: int, value: int):
	pass

func get_extra_reroll():
	pass
	
func reroll_one_dice():
	pass
	
# si half est true alors diamond multiplier *2 dans levelinfo
func change_next_round_score(half = null, double = null):
	if(double == true):
		pass
	if(half == true):
		pass
		# diamond * 2
	
# valider la combinaison meme si la combinaison n'est pas faite
func automatically_valid_combination(combination_name: String):
	pass
	
# changer le random
func add_twenty_percent_score(score: int):
	pass
	
# changer le random
func favors_dice_values(high = null, low = null):
	pass
	
# changer actual_lvl et diamond multiplier dans levelinfo
func skip_next_level():
	# earn *2 diamond next round
	pass
	
# dans tous les dès du joueur
# 1 devient 6 et inversement
# 2 devient 5 et inversement
# 3 devient 4 et inversement
func reverse_dices_values():
	pass


func _on_background_mouse_entered() -> void:
	$Background.texture = preload("res://assets/sprites/options_fond_hover.png")


func _on_background_mouse_exited() -> void:
		$Background.texture = preload("res://assets/sprites/options_fond.png")


func _on_power_up_chosen(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var level_info_node = get_node("../../../../LevelInformation")
		var level_info = level_info_node.level_information
		var power_ups = level_info_node.power_ups
		level_info["user_power_ups"].append(current_power_up)
		power_ups.erase(current_power_up)
		current_power_up = {}
		emit_signal("hide_power_ups")
