extends Node2D

@onready var parallax_background: ParallaxBackground = $ParallaxBackground
@onready var spinning_player: AnimatedSprite2D = $SpinningPlayer

const FALL_SPEED = 20

func _ready():
	AudioManager.play_music(AudioManager.BEAKGROUND_MUSIC_Game_Over_Theme)

func _process(delta):
	parallax_background.scroll_offset = parallax_background.scroll_offset + Vector2(0, -FALL_SPEED * 0.25)
	spinning_player.position += Vector2(0, delta * FALL_SPEED)
