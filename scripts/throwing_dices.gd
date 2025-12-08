extends Node2D

var dice_results: Array = []
var dices_kept = [0,0,0,0,0]
var throwing_count = 3

func _ready() -> void:
	$KeepButton.hide()
	for dice in get_children():
		if dice is RigidBody2D:
			if dice.has_signal("dice_value"):
				dice.connect("dice_value", Callable(self, "_on_dice_rolled"))
			dice.connect("kept", Callable(self, "_on_dice_kept"))
	$KeepDicesLabel.hide()
	$ScoreButton.hide()

func _on_dice_kept(result, index):
	if(throwing_count > 0):
		if(dices_kept[index] == 0):
			dices_kept[index] = int(result)
		else:
			dices_kept[index] = 0

func send_dices_values():
	# Récupération des informations du level actuel
	var level_info_node = get_node("../../LevelInformation")
	var level_info = level_info_node.level_information
	var index := 0
	
	# Récupération des enfants (tous les dès)
	for dice in get_children():
		
		# Prendre en compte que les dès enfants et non les autres (les dès sont de type RigidBody2D)
		if dice is RigidBody2D:
			# Si la valeur contenu dans la liste kept dices est 0 alors le dès n'est pas gardé (la valeur contenu dans kept dices représente la valeur du dès obtenu)
			var is_dice_kept = level_info["kept_dices"][index]
			index += 1
			
			# si l'index = 0 le dès n'est pas gardé donc on le relance en activant la fonction set_level_information
			if is_dice_kept == 0:
				dice.set_level_information(level_info["user_dices"][index], index, true)
			else:
				dice.set_level_information(level_info["user_dices"][index], index, false)
			
		
func _init_dices():
	send_dices_values()

func _on_dice_rolled(result, index):
	if(throwing_count == 0):
		dice_results.append(result)
		if dice_results.size() == number_of_dices():
			change_keep_score_button_visibility()
			dice_results = []
		dices_kept[index] = result
	else:
		dice_results.append(result)
		if dice_results.size() == number_of_dices():
			change_keep_score_button_visibility()
			dice_results = []

func number_of_dices():
	var dice_count = 0
	for element in dices_kept:
		if element == 0:
			dice_count += 1
	return dice_count
	
func change_keep_score_button_visibility():
	if(throwing_count > 0):
		$ThrowButton.disabled = false
		$ScoreButton.show()
	else:
		$ThrowButton.disabled = true
		$ScoreButton.show()


func _on_throw_button_button_up() -> void:
	if(throwing_count > 0):
		$ScoreButton.hide()
		$ThrowButton.disabled = true
		call_deferred("_init_dices")
		var index := 0
		for kept in dices_kept:
			if kept == 0:
				var dice = get_child(index)
				dice.sleeping = true
				dice.global_transform.origin = Vector2(100 + index * 30,100)
				dice.launch()
			index += 1
		throwing_count -= 1
	else:
		finish_level()

func finish_level():
	pass

func _on_keep_button_button_up() -> void:
	var level_info_node = get_node("../../LevelInformation")
	var level_info = level_info_node.level_information
	level_info['kept_dices'] = dices_kept
	change_keep_score_button_visibility()


func _on_score_button_button_up() -> void:
	var pop_up_score = get_node("../../popup_score")
	if (pop_up_score.visible == false):
		pop_up_score.change_combinations_visibility(dices_kept)
		pop_up_score.visible = true
	else:
		pop_up_score.visible = false
		


func _on_popup_score_combination(combination_name: Variant) -> void:
	var level_info_node = get_node("../../LevelInformation")
	var scored = level_info_node.compute_score(dices_kept, combination_name)
	level_info_node.update_ui(scored)
	_on_score_button_button_up()
	$ScoreButton.hide()
