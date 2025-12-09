extends Resource

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

# récupère 3 powerups pour les proposer au joueur (1 choix possible)
func get_3_random_power_ups(powerups: Array) -> Array:
	var offered: Array = []

	# Créer le pool pondéré
	var pool: Array = []
	for p in powerups:
		var weight = 4 - p.rarity
		for i in range(weight):
			pool.append(p)

	# Tirage unique
	while offered.size() < 3 and pool.size() > 0:
		randomize()
		var index = randi() % pool.size()
		var p = pool[index]
		if p not in offered:
			offered.append(p)
		pool.remove_at(index)  # on enlève l'élément tiré
	return offered
	
	
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
