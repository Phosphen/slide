extends Node2D

@onready var parallax_background: ParallaxBackground = $ParallaxBackground
@onready var spinning_player: AnimatedSprite2D = $SpinningPlayer

const FALL_SPEED = 20

func _ready():
	pass # Replace with function body.

func _process(delta):
	parallax_background.scroll_offset = parallax_background.scroll_offset + Vector2(0, -FALL_SPEED * 0.25)
	spinning_player.position += Vector2(0, delta * FALL_SPEED)
