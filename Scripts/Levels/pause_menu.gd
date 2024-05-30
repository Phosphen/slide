extends Control

# we use the timer, so the "show_game_menu" doesn't fight triggering/releasing the pause state
@onready var timer = $Timer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_mouse_entered():
	AudioManager.play_sound(AudioManager.MENU_HOVER)

func _on_resume_button_up():
	AudioManager.play_sound(AudioManager.MENU_CLICK)
	release_pause()

func _on_main_menu_button_up():
	AudioManager.play_sound(AudioManager.MENU_CLICK)
	release_pause()
	get_tree().change_scene_to_file("res://Scenes/Levels/main_menu.tscn")

func trigger_pause():
	get_tree().paused = true
	visible = true
	
	if timer.is_stopped():
		timer.start()

func release_pause():
	get_tree().paused = false
	visible = false

func _physics_process(_delta):
	if Input.is_action_just_pressed("show_game_menu"):
		if get_tree().paused and timer.is_stopped():
			release_pause()
		else:
			trigger_pause()
