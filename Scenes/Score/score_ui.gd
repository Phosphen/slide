extends CanvasLayer

@onready var score_label = $VContainer/Score

func _ready():
	score_label.text="0m"

func _on_player_reached_height(max_reached_height):
	score_label.text = "%.0fm" % (max_reached_height / 100)
