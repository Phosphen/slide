extends Control

@onready var descriptor : Label = $Desciptor
@onready var score : Label = $Score

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if GameEnvironment.alltime_height == GameEnvironment.get_reached_height():
		descriptor.text = "You reached an alltime height!"

	score.text = "%.0fm" % GameEnvironment.get_reached_height()

func _on_start_mouse_entered():
	AudioManager.play_sound(AudioManager.MENU_HOVER)

func _on_quit_mouse_entered():
	AudioManager.play_sound(AudioManager.MENU_HOVER)

func _on_start_button_up():
	AudioManager.play_sound(AudioManager.MENU_CLICK)
	get_tree().change_scene_to_file("res://Scenes/World/main.tscn")

func _on_quit_button_up():
	AudioManager.play_sound(AudioManager.MENU_CLICK)
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")
