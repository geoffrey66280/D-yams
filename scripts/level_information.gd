extends Control

var actual_lvl = 1
var bosses = {
	1: "The great barbarian",
	2: "The ultimate goat",
	3: "Heat the hitter"
}

var scores = {
	1: "100",
	2: "300",
	3: "500"
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var boss_name = $BossName
	var score = $Score
	var reward = $Reward
	var player_score = $PlayerScore
	print(bosses[actual_lvl])
	boss_name.text = bosses[actual_lvl]
	score.text = "Goal\n" + scores[actual_lvl]
	reward.text = "reward : " + str(actual_lvl)
	player_score.text = "score: 0"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
