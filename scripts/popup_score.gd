extends Control

func _ready() -> void:
	visible = false

func change_combinations_visibility(dices: Array):

	var level_informations = get_node("../LevelInformation")
	var valid_combinations = level_informations.detect_combination(dices)

	$Dyams_Button.disabled = true
	$Fourkind_Button.disabled = true
	$FullHouse_Button.disabled = true
	$LargeS_Button.disabled = true
	$SmallS_Button.disabled = true
	$Threekind_Button.disabled = true
	$TwoPairs_Button.disabled = true
	$Pair_Button.disabled = true
	$Chance_Button.disabled = true

	for comb_name in valid_combinations:
		match comb_name:
			"D-yams":
				$Dyams_Button.disabled = false
			"4 of a kind":
				$Fourkind_Button.disabled = false
			"Full house":
				$FullHouse_Button.disabled = false
			"Large straight":
				$LargeS_Button.disabled = false
			"Small straight":
				$SmallS_Button.disabled = false
			"3 of a kind":
				$Threekind_Button.disabled = false
			"Double pair":
				$TwoPairs_Button.disabled = false
			"Pair":
				$Pair_Button.disabled = false
			"Chance":
				$Chance_Button.disabled = false
