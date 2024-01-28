extends TileMap

var wall_index = 0

func _ready():	
	_spawn_next_batch()

func _spawn_next_batch():
	for i in range(10):
		_spawn_walls(wall_index + i)
	wall_index += 10

func _spawn_walls(index):
	set_cell(0, Vector2i(0, index * -1), 2, Vector2i(0, 0))
	set_cell(0, Vector2i(6, index * -1), 2, Vector2i(0, 0))
	
	set_cell(0, Vector2i(-1, index * -1), 2, Vector2i(4, 0))
	set_cell(0, Vector2i(7, index * -1), 2, Vector2i(4, 0))


func _on_player_reached_top():
	# todo: clear lower batch
	_spawn_next_batch()
