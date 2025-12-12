extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_data(data):
	pass
	
func init_card(power_up):
	$BackgroundCard/BackgroundTitle/TitleLabel.text = str(power_up["name"])
	$BackgroundCard/DescriptionLabel.text = str(power_up["description"])
