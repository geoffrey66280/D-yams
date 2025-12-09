extends Control

var level_information: Dictionary = {
	"kept_dices": [0, 0, 0, 0, 0],
	"actual_lvl": 1,
	"user_diamond": 0,
	"diamond_multiplier": 1,
	"bosses": {
		1: "The great barbarian",
		2: "The ultimate goat",
		3: "Heat the hitter"
	},
	"score_to_reach": {
		1: 50,
		2: 100,
		3: 200,
	},
	"round_score": 0,
	"user_dices": {
		0: [1, 2, 3, 4, 5, 6],
		1: [1, 2, 3, 4, 5, 6],
		2: [1, 2, 3, 4, 5, 6],
		3: [1, 2, 3, 4, 5, 6],
		4: [1, 2, 3, 4, 5, 6],
		5: [1, 2, 3, 4, 5, 6]
	}, 
	
	# Le ruleset
	"combinations": {
		"D-yams": 		{"tokens": 100, "mult": 8},
		"4 of a kind": 	{"tokens": 60, "mult": 5},
		"Full house": 	{"tokens": 40, "mult": 4},
		"Large straight": {"tokens": 50, "mult": 5},
		"Small straight": {"tokens": 30, "mult": 3},
		"3 of a kind": 	{"tokens": 20, "mult": 3},
		"Double pair": 	{"tokens": 20, "mult": 2},
		"Pair": 		{"tokens": 10, "mult": 2},
		"Chance": 		{"tokens": 10, "mult": 1}
	}
}

func _ready() -> void:
	level_information["actual_lvl"] = 1
	update_ui()

func update_ui(score = null) -> void:
	# Séparer la mise à jour UI rend le code plus propre
	$BossName.text = level_information["bosses"][level_information["actual_lvl"]]
	$Score.text = "Goal\n" + str(level_information["score_to_reach"][level_information["actual_lvl"]])
	$Reward.text = "reward : " + str(level_information["actual_lvl"])
	if(score):
		$PlayerScore.text = "score: " + str(score)
	else:
		$PlayerScore.text = "score: 0"

func compute_score(dices_values: Array, user_combination_name: String) -> int:
	var final_score: int = 0
	var base_chips: int = 0
	
	# On additionne la valeur des dés
	for dice_value in dices_values:
		base_chips += dice_value
	#On ajoute le bonus de la combinaison
	var combo_data = level_information["combinations"].get(user_combination_name)
	if combo_data:
		base_chips += combo_data["tokens"]
		final_score = base_chips * combo_data["mult"]
	return final_score

func detect_combination(dices: Array) -> Array:
	var valid_combinations: Array = []
	
	# On créé l'histogramme pour compter combien de fois chaque face apparait
	# counts sera ex: {1: 0, 2: 2, 3: 0, 4: 3, 5: 0, 6: 0} pour un Full
	var counts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0}
	for d in dices:
		# Verif que d est entre 1 et 6 
		if d is int and d >= 1 and d <= 6:
			counts[d] += 1
	
	var values_list = counts.values() # On récupère juste les quantités ex pour le full : [0, 2, 0, 3, 0, 0]
	
	# On vérifie les combinaisons basées sur les quantités
	
	# YAMS
	if 5 in values_list:
		valid_combinations.append("D-yams")
	
	# CARRÉ
	if 4 in values_list or 5 in values_list:
		valid_combinations.append("4 of a kind")
		
	# FULL HOUSE
	if (3 in values_list and 2 in values_list) or 5 in values_list:
		valid_combinations.append("Full house")
		
	# BRELAN
	if 3 in values_list or 4 in values_list or 5 in values_list:
		valid_combinations.append("3 of a kind")
	
	# DOUBLE PAIRE
	var pairs_count = 0
	for v in values_list:
		if v >= 2:
			pairs_count += 1
	if pairs_count >= 2:
		valid_combinations.append("Double pair")

	# PAIRE
	if 2 in values_list or 3 in values_list or 4 in values_list or 5 in values_list:
		valid_combinations.append("Pair")

	# SUITES ( on a besoin des dés uniques triés )
	var unique_dices = []
	for key in counts.keys():
		if counts[key] > 0:
			unique_dices.append(key)
	unique_dices.sort()
	
	# On compte combien de nombres suités on a
	var max_consecutive = 0
	var current_consecutive = 0
	if unique_dices.size() > 0:
		current_consecutive = 1
		for i in range(unique_dices.size() - 1):
			if unique_dices[i+1] == unique_dices[i] + 1:
				current_consecutive += 1
			else:
				max_consecutive = max(max_consecutive, current_consecutive)
				current_consecutive = 1
		max_consecutive = max(max_consecutive, current_consecutive)
	
	if max_consecutive >= 5:
		valid_combinations.append("Large straight")
		valid_combinations.append("Small straight")
	elif max_consecutive >= 4:
		valid_combinations.append("Small straight")

	# Chance
	valid_combinations.append("Chance")

	return valid_combinations
