extends Control

@onready var parallax_background: ParallaxBackground = $ParallaxBackground

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(_delta):
	parallax_background.scroll_offset = parallax_background.scroll_offset + Vector2(0, 0.5)

func _on_start_mouse_entered():
	AudioManager.play_sound(AudioManager.MENU_HOVER)

func _on_quit_mouse_entered():
	AudioManager.play_sound(AudioManager.MENU_HOVER)

func _on_start_pressed():
	AudioManager.play_sound(AudioManager.MENU_CLICK)
	get_tree().change_scene_to_file("res://Scenes/World/main.tscn")

func _on_quit_button_up():
	AudioManager.play_sound(AudioManager.MENU_CLICK)
	get_tree().quit()
