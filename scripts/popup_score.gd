extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_combinations_visibility(dices: Array):
	var level_infomartions = get_node("../LevelInformation")
	var valid_combinations = level_infomartions.detect_combination(dices)
	$Dyams_Button.disabled = true
	$Fourkind_Button.disabled = true
	$LargeS_Button.disabled = true
	$SmallS_Button.disabled = true
	$Threekind_Button.disabled = true
	$TwoPairs_Button.disabled = true
	$Pair_Button.disabled = true
	$FullHouse_Button.disabled = true
	for comb_name in valid_combinations:
		if comb_name == "D-yams":
			$Dyams_Button.disabled = false
		elif comb_name == "4 of a kind":
			$Fourkind_Button.disabled = false
		elif comb_name == "Full house":
			$LargeS_Button.disabled = false
		elif comb_name == "Large straight":
			$SmallS_Button.disabled = false
		elif comb_name == "Small straight":
			$Threekind_Button.disabled = false
		elif comb_name == "3 of a kind":
			$TwoPairs_Button.disabled = false
		elif comb_name == "Double pair":
			$Pair_Button.disabled = false
		elif comb_name == "Pair":
			$Chance_Button.disabled = false
