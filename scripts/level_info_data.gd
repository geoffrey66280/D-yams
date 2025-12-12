extends Node


var level_information: Dictionary = {
	"kept_dices": [0, 0, 0, 0, 0],
	"actual_lvl": 1,
	"user_diamond": 0,
	"diamond_multiplier": 1,
	"user_power_ups": [],
	"throwing_count": 3,
	"throwing_reset": 3,
	"bosses": {
		1: "The great barbarian",
		2: "The ultimate goat",
		3: "Heat the hitter",
		4: "The great barbarian",
		5: "The ultimate goat",
		6: "Heat the hitter",
		7: "The great barbarian",
		8: "The ultimate goat",
		9: "Heat the hitter",
		10: "The great barbarian",
		11: "The ultimate goat",
		12: "Heat the hitter",
	},
	"score_to_reach": {
		1: 50,
		2: 50,
		3: 50,
		4: 50,
		5: 50,
		6: 50,
		7: 50,
		8: 50,
		9: 50,
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

var power_ups = [
	{"id": 1, "name": "Extra 6", "description": "Replace a chosen value of a dice by a 6 forever", "rarity": 1},
	{"id": 2, "name": "Extra 1", "description": "Replace a chosen value of a dice by a 1 forever", "rarity": 1},
	{"id": 3, "name": "Extra Reroll", "description": "Get an additional reroll per round", "rarity": 2},
	{"id": 4, "name": "Little Reroll", "description": "Reroll a single dice one time per round", "rarity": 1},
	{"id": 5, "name": "Double Score", "description": "Double the score of the next combination (1 use)", "rarity": 3},
	{"id": 6, "name": "Half Rich", "description": "Halve the score of the next combination and earn double diamond (1 use)", "rarity": 3},
	{"id": 7, "name": "Auto Full House", "description": "Automatically complete a full house (1 use)", "rarity": 3},
	{"id": 8, "name": "Auto Large Straight", "description": "Automatically complete a large straight (1 use)", "rarity": 3},
	{"id": 9, "name": "Auto Small Straight", "description": "Automatically complete a small straight (1 use)", "rarity": 2},
	{"id": 10, "name": "Bonus Points", "description": "Add 20% of your points to your round score (2 use)", "rarity": 2},
	{"id": 11, "name": "Lucky Dice", "description": "Next dice roll favors high values (1 round)", "rarity": 2},
	{"id": 12, "name": "Unlucky Dice", "description": "Next dice roll favors low values (1 round)", "rarity": 2},
	{"id": 13, "name": "Skip Round", "description": "Skip the next round and earn double diamond next round (1 use)", "rarity": 3},
	{"id": 14, "name": "Auto Yams", "description": "Automatically score a Yams (5 of a kind) (1 use)", "rarity": 3},
	{"id": 15, "name": "Dice Reversal", "description": "All dice values are reversed (6 becomes 1, etc.) (1 round)", "rarity": 2},
]


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
	# use an array for counts: index 0 => face 1, index 5 => face 6
	var counts := [0, 0, 0, 0, 0, 0]

	# normalize input and build histogram
	for raw in dices:
		var val = null
		# check/convert types robustly
		match typeof(raw):
			TYPE_INT:
				val = raw
			TYPE_FLOAT:
				val = int(raw)
			TYPE_STRING:
				# only accept if the string is an int literal
				if raw.is_valid_integer():
					val = int(raw)
			_:
				# ignore other types
				pass

		if val != null and val >= 1 and val <= 6:
			counts[val - 1] += 1

	# quick debug (uncomment to trace)
	# print("dices:", dices, " -> counts:", counts)

	# values_list : les quantités (ex. [0,2,0,3,0,0])
	var values_list := counts.duplicate()

	# YAMS (5 of a kind)
	if 5 in values_list:
		valid_combinations.append("D-yams")

	# CARRE (4 of a kind or 5)
	if 4 in values_list or 5 in values_list:
		valid_combinations.append("4 of a kind")

	# FULL HOUSE (3+2) or 5 of a kind
	if (3 in values_list and 2 in values_list) or 5 in values_list:
		valid_combinations.append("Full house")

	# BRELAN (3 or 4 or 5)
	if 3 in values_list or 4 in values_list or 5 in values_list:
		valid_combinations.append("3 of a kind")

	# DOUBLE PAIRE (au moins deux valeurs >=2)
	var pairs_count := 0
	for v in values_list:
		if v >= 2:
			pairs_count += 1
	if pairs_count >= 2:
		valid_combinations.append("Double pair")

	# PAIRE (au moins une paire / meilleur inclus)
	if 2 in values_list or 3 in values_list or 4 in values_list or 5 in values_list:
		valid_combinations.append("Pair")

	# SUITES (unique, triés)
	var unique_dices: Array = []
	for i in range(counts.size()):
		if counts[i] > 0:
			unique_dices.append(i + 1) # restore face value
	unique_dices.sort()

	# calc max_consecutive
	var max_consecutive := 0
	var current_consecutive := 0
	if unique_dices.size() > 0:
		current_consecutive = 1
		for i in range(unique_dices.size() - 1):
			if unique_dices[i + 1] == unique_dices[i] + 1:
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

	# Chance : toujours disponible
	valid_combinations.append("Chance")
	return valid_combinations
