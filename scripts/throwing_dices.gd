extends Node2D

var dice_results: Array = []

func send_dices_values():
	var level_info_node = get_node("../../LevelInformation")
	var level_info = level_info_node.level_information
	var index := 1
	for dice in get_children():
		if dice is RigidBody2D:
			dice.set_level_information(level_info["user_dices"][index], index)
			index += 1
		
func _init_dices():
	send_dices_values()
	for dice in get_children():
		if dice.has_signal("dice_value") and dice is RigidBody2D:
			dice.connect("dice_value", Callable(self, "_on_dice_rolled"))


func _on_dice_rolled(result):
	dice_results.append(result)
	if dice_results.size() == numberOfDices():
		print("Tous les dés ont roulé :", dice_results)


func _on_button_button_up() -> void:
	call_deferred("_init_dices")
	var index := 1
	for dice in get_children():
		if dice is RigidBody2D:
			dice.sleeping = true
			dice.global_transform.origin = Vector2(400 + index * 30,400)
			dice.launch()
			index += 1
			
func numberOfDices():
	var dice_count = 0
	for dice in get_children():
		if dice is RigidBody2D:
			dice_count += 1
	return dice_count
			
