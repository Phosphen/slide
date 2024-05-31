extends CanvasLayer

@onready var score_label = $VContainer/Score

func _ready():
	score_label.text="0m"
	GameEnvironment.new_height_reached.connect(_update_display)

func _update_display(height: int):
	score_label.text = "%.0fm" % height
