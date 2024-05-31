extends Control

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")

func _on_animated_logo_animation_finished():
	$Timer.start()
