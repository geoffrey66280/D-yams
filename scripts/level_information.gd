extends Control

var level_information = {
	"actual_lvl": 1,
	"bosses": {
		1: "The great barbarian",
		2: "The ultimate goat",
		3: "Heat the hitter"
	},
	"scores": {
		1: "100",
		2: "300",
		3: "500"
	}
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var boss_name = $BossName
	var score = $Score
	var reward = $Reward
	var player_score = $PlayerScore
	boss_name.text = level_information["bosses"][1]
	score.text = "Goal\n" + level_information["scores"][level_information["actual_lvl"]]
	reward.text = "reward : " + str(level_information["actual_lvl"])
	player_score.text = "score: 0"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
