extends CanvasLayer

var score_ui_count

func _ready():
	score_ui_count = get_node("./MarginContainer/HContainer/Score") as Label
	score_ui_count.text="0"

func _on_player_reached_height(max_reached_height):
	score_ui_count.text = "%.0f" % (max_reached_height / 100)
