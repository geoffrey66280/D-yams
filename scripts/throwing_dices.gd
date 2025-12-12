extends Node2D

@export var ui_level_info_node: Node
@onready var throw_button := $ThrowButton
@onready var score_button := $ScoreButton
@onready var roll_audio := $RollAudio
var dices = []
var dice_results: Array = []
var kept_dices = [0,0,0,0,0]
var level_info_node = LevelInformation
var level_info = LevelInformation.level_information
var animation_score_pitch = 0.7
signal show_power_up()
signal power_up_chosen()
signal score_ui(tokens)
signal add_card_power_up(current_power_up)
signal score_combination(combination_name)
			

func _ready() -> void:
	for dice in get_children():
		if dice is RigidBody2D:
			dices.append(dice)
			dice.connect("dice_value", Callable(self, "_on_dice_rolled"))
			dice.connect("kept", Callable(self, "_on_dice_kept"))

func _on_dice_kept(result, index):
	if(level_info["throwing_count"] > 0):
		if(kept_dices[index] == 0):
			kept_dices[index] = int(result)
		else:
			kept_dices[index] = 0
	
	if(are_all_dices_kept()):
		throw_button.disabled = true
	else:
		throw_button.disabled = false

func send_dices_values():
	var index := 0
	
	for dice in dices:
		var is_dice_kept = level_info["kept_dices"][index]
		index += 1
			
		if is_dice_kept == 0:
			dice.set_level_information(level_info["user_dices"][index], index, true)
		else:
			dice.set_level_information(level_info["user_dices"][index], index, false)
			
		
func _init_dices():
	send_dices_values()

func _on_dice_rolled(result, index):
	if(level_info["throwing_count"] == 0):
		dice_results.append(result)
		if dice_results.size() == number_of_dices():
			score_button.show()
			throw_button.disabled = true
			dice_results = []
		kept_dices[index] = result
	else:
		dice_results.append(result)
		if dice_results.size() == number_of_dices():
			score_button.show()
			throw_button.disabled = false

func number_of_dices():
	var dice_count = 0
	for element in kept_dices:
		if element == 0:
			dice_count += 1
	return dice_count

func are_all_dices_kept() -> bool:
	return not kept_dices.has(0)


func _on_throw_button_button_up() -> void:
	dice_results = []
	if(level_info["throwing_count"] > 0 and not are_all_dices_kept()):
		throw_button.disabled = true
		score_button.hide()
		call_deferred("_init_dices")
		play_roll_sound()
		var index := 0
		for kept in kept_dices:
			if kept == 0:
				var dice = get_child(index)
				dice.sleeping = true
				dice.global_transform.origin = Vector2(100 + index * 30,100)
				await get_tree().create_timer(0.01).timeout
				dice.launch()
			index += 1
		level_info["throwing_count"] -= 1
		ui_level_info_node.update_ui(null)
	else:
		level_info["throwing_count"] -= 1
		ui_level_info_node.update_ui(null)
		finish_level()

func finish_level():
	pass


func _on_score_button_button_up() -> void:
	var pop_up_score = get_node("../../popup_score")
	var all_dices = get_dices_values()
	if (pop_up_score.visible == false):
		pop_up_score.change_combinations_visibility(all_dices)
		pop_up_score.visible = true
	else:
		pop_up_score.visible = false
		
func get_dices_values():
	var all_dices = []
	var i = 0
	var j = 0
	for dice in kept_dices:
		if dice == 0:
			all_dices.append(dice_results[j])
			j += 1
		else:
			all_dices.append(kept_dices[i])
		i += 1
	return all_dices
	


func _on_popup_score_combination(combination_name: Variant) -> void:
	throw_button.disabled = true
	score_button.hide()
	var all_dices = get_dices_values()
	var scored = level_info_node.compute_score(all_dices, combination_name)
	_on_score_button_button_up()
	emit_signal("score_combination", combination_name)
	for dice in dices:
		dice.reset_right_position()
		animation_score_pitch += 0.05
		dice.animate_score(animation_score_pitch)
		emit_signal("score_ui", dice.final_random_value)
		await dice.animate_score(animation_score_pitch)
	animation_score_pitch = 0.7
	await ui_level_info_node.update_ui(scored, combination_name)
	pass_level(scored)
	
func pass_level(score):
	kept_dices = [0,0,0,0,0]
	emit_signal("show_power_up")
	await power_up_chosen
	if(score >= level_info["score_to_reach"][level_info["actual_lvl"]]):
		level_info["throwing_count"] = level_info["throwing_reset"]
		level_info["user_diamond"] += level_info["actual_lvl"] * level_info["diamond_multiplier"]
		level_info["actual_lvl"] += 1
		level_info["diamond_multiplier"] = 1
		ui_level_info_node.update_ui(null)
		throw_button.disabled = false
	else:
		print('you loose')
		
func play_roll_sound() -> void:
	var folder := "res://resources/audio/throwing_dices/"
	var dir := DirAccess.open(folder)
	if dir == null:
		return

	var mp3s := []
	dir.list_dir_begin()
	while true:
		var f := dir.get_next()
		if f == "":
			break
		if not dir.current_is_dir() and f.ends_with(".mp3"):
			mp3s.append(f)
	dir.list_dir_end()

	if mp3s.is_empty():
		return

	randomize()
	roll_audio.stream = load(folder + mp3s.pick_random())
	roll_audio.pitch_scale = randf_range(0.95, 1.05)
	roll_audio.play()
	
	
func _on_power_ups_power_up_chosen() -> void:
	emit_signal("power_up_chosen")
