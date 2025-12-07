extends Control

var line_scene = preload("res://scenes/LigneScore.tscn")

@onready var container_liste = $PanelContainer/ListeDesMains

func _ready():
	visible = false
	generate_list()
	
func generate_list():
	var level_info_node = get_node("../LevelInformation")
	var combinations = level_info_node.level_information["combinations"]
	
	for combination_info in combinations:

		var new_line = line_scene.instantiate()

		container_liste.add_child(new_line)

		new_line.mettre_a_jour_infos(combination_info["name"], combination_info["tokens"], combination_info["mult"])
