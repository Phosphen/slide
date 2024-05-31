extends Node2D

func instantiate_first_scene():
	get_tree().change_scene_to_file("res://Scenes/Menu/splash_screen.tscn")

func _ready():
	call_deferred("instantiate_first_scene")
