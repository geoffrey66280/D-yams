extends HBoxContainer

@onready var label_name = $NomMain
@onready var label_value = $ZoneScore/FondBleu/Label
@onready var label_multi = $ZoneScore/FondRouge/Label

func mettre_a_jour_infos(combination_name: String, score: int, multi: int):
	label_name.text = combination_name
	label_value.text = str(score)
	label_multi.text = str(multi)
