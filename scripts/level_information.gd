extends Control

var level_info = LevelInformation.level_information

func update_ui(score = null, combination_name = null) -> void:
	var lvl = level_info["actual_lvl"]
	# Séparer la mise à jour UI rend le code plus propre
	$BossName.text = level_info["bosses"][lvl]
	$Score.text = "Goal: " + str(level_info["score_to_reach"][lvl])
	$Reward.text = "reward : " + str(lvl)
	$Diamonds.text = str(level_info["user_diamond"])
	$PlayerScore.text = "score: 0"
	$RollsRemaining.text = str(level_info["throwing_count"])
	$SubLevel.text = str(((lvl - 1) % 5) + 1) + "/5"
	$ActualLevel.text = str(((lvl - 1) / 5) + 1) + "/5"
	
	var target_score = score if score != null else 0
	var speed = 150
	var current_score = 0
	while current_score < target_score:
		current_score += speed * get_process_delta_time()
		if current_score > target_score:
			current_score = target_score
		$PlayerScore.text = "score: " + str(int(current_score))
		await get_tree().process_frame
	await get_tree().create_timer(1).timeout


func _on_throwing_dices_score_combination(combination_name: Variant) -> void:
	var tokens = str(level_info["combinations"][combination_name]["tokens"])
	var mult = str(level_info["combinations"][combination_name]["mult"])
	$Tokens.text = tokens
	$Mult.text = mult


func _on_throwing_dices_score_ui(tokens: Variant) -> void:
	var user_token = int($Tokens.text)
	user_token += tokens
	$Tokens.text = str(user_token)
	
