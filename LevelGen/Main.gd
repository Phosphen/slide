extends Node

# Probability of spawning a double-width platform
var double_width_probability = 0.2  # 20% chance

var ground_instances = []
var wall_instances = []
var spawned_platforms = []

func _ready():
	#last_platform_position = Vector2(screen_width * 0.5, -DISTANCE_BETWEEN_PLATFORMS)
	AudioManager.play_music(AudioManager.BEAKGROUND_MUSIC_SirUp_Main_Theme)

func _free_lowest_walls():
	#if (wall_index < 30):
		#return
	var wall1 = wall_instances.pop_at(0)
	var wall2 = wall_instances.pop_at(0)
	wall1.queue_free()
	wall2.queue_free()

func _on_player_falling_to_death():
	AudioManager.stop_music(AudioManager.BEAKGROUND_MUSIC_SirUp_Main_Theme)
	for floor_instance in ground_instances:
		floor_instance.queue_free()
		
	for platform in spawned_platforms:
		platform.queue_free()
		platform.freeze = false
		platform.sleeping = false
		
	spawned_platforms.clear()
	ground_instances.clear()

	get_tree().change_scene_to_file("res://Scenes/Levels/game_over.tscn")
