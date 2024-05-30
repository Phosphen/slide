extends Node

#Music
const BEAKGROUND_MUSIC_SirUp_Main_Theme : AudioStreamMP3 = preload("res://Assets/Sounds/SirUp_Main_Theme_Alpha_3.mp3")
const BEAKGROUND_MUSIC_Game_Over_Theme : AudioStreamMP3 = preload("res://Assets/Sounds/Music_game_over.mp3")


#Sounds
const MENU_CLICK : AudioStreamWAV = preload("res://Assets/Sounds/Menu Click.wav")
const MENU_HOVER : AudioStreamWAV = preload("res://Assets/Sounds/Menu Hover.wav")
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
			
			
func stop_music(music):
	for player in music_players:
		if player.playing and player.stream == music:
			player.stop()
			break
