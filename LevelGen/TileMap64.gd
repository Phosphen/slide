extends TileMap

var wall_index = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	_spawn_level_batch()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _spawn_level_batch():
	for i in range(10):
		_spawn_walls(wall_index + i)
	for i in range(20):
		_spawn_platform(i)
	#wall_index += 10
	
func _spawn_walls(index):
	set_cell(0, Vector2i(0, index * -1), 2, Vector2i(0, 0))
	set_cell(0, Vector2i(6, index * -1), 2, Vector2i(0, 0))
	
	set_cell(0, Vector2i(-1, index * -1), 2, Vector2i(4, 0))
	set_cell(0, Vector2i(7, index * -1), 2, Vector2i(4, 0))
	pass

func _spawn_platform(index):
	pass
