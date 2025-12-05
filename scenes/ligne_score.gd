extends HBoxContainer

@onready var label_nom = $NomMain
@onready var label_valeur = $ZoneScore/FondBleu/Label
@onready var label_multi = $ZoneScore/FondRouge/Label

func mettre_a_jour_infos(nom_de_la_main: String, score: int, multi: int):
	label_nom.text = nom_de_la_main
	label_valeur.text = str(score)
	label_multi.text = str(multi)
