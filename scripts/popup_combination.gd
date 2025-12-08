extends Control

var line_scene = preload("res://scenes/LigneScore.tscn")

@onready var container_liste = $PanelContainer/ListeDesMains

func _ready():
	visible = false
	generate_list()
	
func generate_list():
	var level_info_node = get_node("../LevelInformation")
	var combinations = level_info_node.level_information["combinations"]
	
	for combo_name in combinations:
		
		var new_line = line_scene.instantiate()
		container_liste.add_child(new_line)
		
		var combo_data = combinations[combo_name]
		
		new_line.mettre_a_jour_infos(combo_name, combo_data["tokens"], combo_data["mult"])
