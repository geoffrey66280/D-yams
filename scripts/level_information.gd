extends Control

var level_information = {
	"kept_dices": [0,0,0,0,0],
	"actual_lvl": 1,
	"bosses": {
		1: "The great barbarian",
		2: "The ultimate goat",
		3: "Heat the hitter"
	},
	"score_to_reach": {
		1: "100",
		2: "300",
		3: "500"
	},
	"round_score": 0,
	"user_dices": {
		0: ["1", "2", "3", "4", "5", "6"],
		1: ["1", "2", "3", "4", "5", "6"],
		2: ["1", "2", "3", "4", "5", "6"],
		3: ["1", "2", "3", "4", "5", "6"],
		4: ["1", "2", "3", "4", "5", "6"],
		5: ["1", "2", "3", "4", "5", "6"]
	},
	"combinations": [{
		"name": "D-yams",
		"tokens": 100,
		"mult": 8,
		},
		{
		"name": "4 of a kind",
		"tokens": 60,
		"mult": 5,
		},
		{
		"name": "Full house",
		"tokens": 40,
		"mult": 4,
		},
		{
		"name": "Large straight",
		"tokens": 50,
		"mult": 5,
		},
		{
		"name": "Small straight",
		"tokens": 30,
		"mult": 3,
		},
		{
		"name": "3 of a kind",
		"tokens": 20,
		"mult": 3,
		},
		{
		"name": "Double pair",
		"tokens": 20,
		"mult": 2,
		},
		{
		"name": "Pair",
		"tokens": 10,
		"mult": 2,
		},
		{
		"name": "Chance",
		"tokens": 10,
		"mult": 1,
		},
	],
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_information["actual_lvl"] = 1
	var boss_name = $BossName
	var score = $Score
	var reward = $Reward
	var player_score = $PlayerScore
	boss_name.text = level_information["bosses"][level_information["actual_lvl"]]
	score.text = "Goal\n" + level_information["score_to_reach"][level_information["actual_lvl"]]
	reward.text = "reward : " + str(level_information["actual_lvl"])
	player_score.text = "score: 0"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func compute_score(dices_values: Array, user_combination: String):
	var final_score: int = 0
	var token: int = 0
	for dice_value in dices_values:
		token += dice_value
	for combination in level_information["combinations"]:
		if combination["name"] == user_combination:
			token += combination["name"]["tokens"]
			final_score = token * combination["name"]["mult"]
	return final_score
	
	
func detect_combination(dices: Array):
	var combinations = []
	var num_pairs = 0
	var counts = {}
	var sorted_dice = dices.duplicate()
	sorted_dice.sort()
	
	for dice in sorted_dice:
		counts[dice] = counts.get(dice, 0) + 1
	var values = counts.values()
	
	# --- YAMS ---
	if values.has(5):
		combinations.append("D-yams")

	# --- Double Pair ---
	for v in values:
		if v == 2:
			num_pairs += 1
	if num_pairs == 2:
		combinations.append("Double pair")
	
	# --- Pair ---
	if values.has(2) and not values.has(3):
		combinations.append("Pair")

	# --- 4 OF A KIND ---
	if values.has(4):
		combinations.append("4 of a kind")

	# --- FULL HOUSE ---
	if values.has(3) and values.has(2):
		combinations.append("Full house")

	# --- 3 OF A KIND ---
	if values.has(3) and not values.has(2):
		combinations.append("3 of a kind")

	 # --- LARGE STRAIGHT (1-5 ou 2-6) ---
	var large1 = [1,2,3,4,5]
	var large2 = [2,3,4,5,6]
	if sorted_dice == large1 or sorted_dice == large2:
		combinations.append("Large straight")

	# --- SMALL STRAIGHT (4 dés consécutifs dans les 5) ---
	var unique = sorted_dice.duplicate()
	unique = unique.uniq()
	var cons = 1
	for i in range(1, unique.size()):
		if unique[i] == unique[i-1] + 1:
			cons += 1
		else:
			cons = 1
			
		if cons >= 4:
			combinations.append("Small straight")
			break
	return combinations
