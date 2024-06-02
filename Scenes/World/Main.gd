extends Node

# Probability of spawning a double-width platform
var double_width_probability = 0.2  # 20% chance

var ground_instances = []
var wall_instances = []
var spawned_platforms = []

var main_music_started = false

@onready var pause_menu = $Camera2D/PauseMenu

func _ready():
	AudioManager.play_music(AudioManager.BEAKGROUND_MUSIC_Cave_Theme)
	#last_platform_position = Vector2(screen_width * 0.5, -DISTANCE_BETWEEN_PLATFORMS)
	pass

func _exit_tree():
	AudioManager.stop_music()

func _free_lowest_walls():
	#if (wall_index < 30):
		#return
	var wall1 = wall_instances.pop_at(0)
	var wall2 = wall_instances.pop_at(0)
	wall1.queue_free()
	wall2.queue_free()
	
func go_to_game_over_screen():
		get_tree().change_scene_to_file("res://Scenes/Menu/game_over.tscn")
	
func _on_player_falling_to_death():
	AudioManager.stop_music()
	for floor_instance in ground_instances:
		floor_instance.queue_free()
		
	for platform in spawned_platforms:
		platform.queue_free()
		platform.freeze = false
		platform.sleeping = false
		
	spawned_platforms.clear()
	ground_instances.clear()

	# in some cases an error is thrown,
	# when "change_scene_to_file" is called
	# in the physics process, so we do it this way...
	call_deferred("go_to_game_over_screen")


func _on_start_music_area_2d_area_entered(area):
	if main_music_started:
		return
	main_music_started = true
	AudioManager.stop_music()
	AudioManager.play_music(AudioManager.BEAKGROUND_MUSIC_SirUp_Main_Theme)
