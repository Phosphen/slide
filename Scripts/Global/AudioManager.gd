extends Node

#Music
const BEAKGROUND_MUSIC_1 : AudioStreamWAV = preload("res://Assets/Sounds/Background_Music.wav")
const BEAKGROUND_MUSIC_2 : AudioStreamWAV = preload("res://Assets/Sounds/Background_Music_2.wav")
const BEAKGROUND_MUSIC_3 : AudioStreamMP3 = preload("res://Assets/Sounds/Background_Music_3.mp3")


#Sounds
const DEATH : AudioStreamWAV = preload("res://Assets/Sounds/Death.wav")
const HURT : AudioStreamWAV = preload("res://Assets/Sounds/Hurt.wav")
const JUMP : AudioStreamWAV = preload("res://Assets/Sounds/Jump.wav")
const SHOOT : AudioStreamWAV = preload("res://Assets/Sounds/Shoot.wav")
const BULLET : AudioStreamWAV = preload("res://Assets/Sounds/Bullet.wav")
const MENU_CLICK : AudioStreamWAV = preload("res://Assets/Sounds/Menu Click.wav")
const MENU_HOVER : AudioStreamWAV = preload("res://Assets/Sounds/Menu Hover.wav")
const SPLASH_CLICK : AudioStreamWAV = preload("res://Assets/Sounds/Splash Click.wav")
const SPLASH_GLITCH : AudioStreamWAV = preload("res://Assets/Sounds/Splash Glitch.wav")
const JUMP_WTF : AudioStreamWAV = preload("res://Assets/Sounds/Vocal_WTF.wav")

#Refrences
@onready var music_players = $Music.get_children()
@onready var sound_players = $Sounds.get_children()

func play_music(music):
	for player in music_players:
		if not player.playing:
			player.stream = music
			player.play()
			break

func play_sound(sound):
	for player in sound_players:
		if not player.playing:
			player.stream = sound
			player.play()
			break
