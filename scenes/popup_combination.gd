extends Control

var ligne_scene = preload("res://scenes/LigneScore.tscn")

@onready var container_liste = $PanelContainer/ListeDesMains

var les_mains = [
	{"nom": "Yams", "score": 100, "mult": 8},
	{"nom": "Carré", "score": 60, "mult": 5},
	{"nom": "Full", "score": 40, "mult": 4},
	{"nom": "Grande Suite", "score": 50, "mult": 5},
	{"nom": "Petite Suite", "score": 30, "mult": 3},
	{"nom": "Brelan", "score": 20, "mult": 3}
]

func _ready():
	visible = false
	generer_la_liste()

func generer_la_liste():
	for main_info in les_mains:

		var nouvelle_ligne = ligne_scene.instantiate()

		container_liste.add_child(nouvelle_ligne)

		nouvelle_ligne.mettre_a_jour_infos(main_info["nom"], main_info["score"], main_info["mult"])
