extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	event_bus.connect("send_power_up_chosen", Callable(self, "_add_power_up_card"))
	$Background.visible = true


func _add_power_up_card(power_up):
	var card_scene := preload("res://scenes/card.tscn")
	var card_instance = card_scene.instantiate()
	card_instance.init_card(power_up)
	$CardContainer.add_child(card_instance)
