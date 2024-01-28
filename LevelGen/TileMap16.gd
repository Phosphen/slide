extends TileMap

var platform_index = 0
const distance_between_platforms = 6
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#_spawn_next_batch()

func _spawn_next_batch():
	for i in range(20):
		_spawn_platform(platform_index + i)
	platform_index += 20

# xRange wall to wall: 5 <-> 24
func _spawn_platform(index):
	var randomX = randi_range(7, 22)
	index *= distance_between_platforms
	set_cell(0, Vector2i(randomX - 2, index * -1), 0, Vector2i(64, 0))
	set_cell(0, Vector2i(randomX - 1, index * -1), 0, Vector2i(65, 0))
	set_cell(0, Vector2i(randomX - 0, index * -1), 0, Vector2i(66, 0))
	set_cell(0, Vector2i(randomX + 1, index * -1), 0, Vector2i(67, 0))
	set_cell(0, Vector2i(randomX + 2, index * -1), 0, Vector2i(68, 0))

func _on_player_reached_top():
	# todo: clear lower batch
	_spawn_next_batch()
