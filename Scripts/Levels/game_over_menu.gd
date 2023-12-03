extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_start_mouse_entered():
	AudioManager.play_sound(AudioManager.MENU_HOVER)

func _on_quit_mouse_entered():
	AudioManager.play_sound(AudioManager.MENU_HOVER)

func _on_start_button_up():
	AudioManager.play_sound(AudioManager.MENU_CLICK)
	get_tree().change_scene_to_file("res://LevelGen/main.tscn")

func _on_quit_button_up():
	AudioManager.play_sound(AudioManager.MENU_CLICK)
	get_tree().change_scene_to_file("res://Scenes/Levels/main_menu.tscn")
