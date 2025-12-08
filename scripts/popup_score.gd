extends Control

signal combination(combination_name)

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
				
func emit_combination(combination_name: String):
	emit_signal('combination', combination_name)


func _on_dyams_button_button_up() -> void:
	emit_combination("D-yams")


func _on_fourkind_button_button_up() -> void:
	emit_combination("4 of a kind")


func _on_full_house_button_button_up() -> void:
	emit_combination("Full house")


func _on_large_s_button_button_up() -> void:
	emit_combination("Large straight")


func _on_small_s_button_button_up() -> void:
	emit_combination("Small straight")


func _on_threekind_button_button_up() -> void:
	emit_combination("3 of a kind")


func _on_two_pairs_button_button_up() -> void:
	emit_combination("Double pair")


func _on_pair_button_button_up() -> void:
	emit_combination("Pair")


func _on_chance_button_button_up() -> void:
	emit_combination("Chance")
