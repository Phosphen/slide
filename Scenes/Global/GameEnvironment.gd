extends Node

signal player_died
signal new_height_reached(hight: int)

var alltime_height : int = 0
var _current_reached_hight : int = 0

const SAVE_PATH : String = "user://alltime_height.save"

func _ready():
	load_reached_height()

func update_reached_hight(height: int):
	_current_reached_hight = height
	new_height_reached.emit(height)
	if height > alltime_height:
		alltime_height = height

func get_reached_height() -> int:
	return _current_reached_hight

func save_reached_height():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_64(alltime_height)

func load_reached_height():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		alltime_height = file.get_64()
	else:
		printerr("file not found: " + SAVE_PATH)
		alltime_height = 0
