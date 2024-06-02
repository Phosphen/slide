extends Node

#Music
const BEAKGROUND_MUSIC_SirUp_Main_Theme : AudioStreamMP3 = preload("res://Assets/Sounds/SirUp_Main_Theme_Alpha_3.mp3")
const BEAKGROUND_MUSIC_Game_Over_Theme : AudioStreamMP3 = preload("res://Assets/Sounds/Music_game_over.mp3")
const BEAKGROUND_MUSIC_Cave_Theme : AudioStreamMP3 = preload("res://Assets/Sounds/Cave_Theme.mp3")

#Sounds
const MENU_CLICK : AudioStreamWAV = preload("res://Assets/Sounds/Menu Click.wav")
const MENU_HOVER : AudioStreamWAV = preload("res://Assets/Sounds/Menu Hover.wav")
const JUMP_WTF : AudioStreamWAV = preload("res://Assets/Sounds/Vocal_WTF.wav")
const JUMP: AudioStreamWAV = preload("res://Assets/Sounds/Jump.wav")

#Refrences
@onready var music_player : AudioStreamPlayer = $Music
@onready var sound_players = $Sounds.get_children()

var loop_music = false

func play_music(music: AudioStream, loop: bool = true):
	loop_music = loop
	music_player.stop()
	music_player.stream = music
	music_player.play()

func stop_music():
	music_player.stop()

func play_sound(sound):
	for player in sound_players:
		if not player.playing:
			player.stream = sound
			player.play()
			break

func _on_music_finished():
	if loop_music:
		music_player.play()
