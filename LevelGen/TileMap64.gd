extends TileMap

var wall_index = 0
@export var normal_wall_weight = 70  # 70% chance to be a normal wall
@export var jump_wall_weight = 15    # 15% chance to be a jump wall
@export var fly_wall_weight = 15     # 15% chance to be a fly wall

func _ready():	
	_spawn_next_batch()

func _spawn_next_batch():
	for i in range(10):
		_spawn_walls(wall_index + i)
	wall_index += 10

func _spawn_walls(index):
	var rand_value = randi() % 100  # Get a random value between 0 and 99
	var wall_type = 1
	if rand_value < normal_wall_weight:
		wall_type = 1	
	elif rand_value < normal_wall_weight + jump_wall_weight:
		wall_type = 4
	else:
		wall_type = 5
	
	# left-right inner walls (aka gameplay walls)
	set_cell(0, Vector2i(0, index * -1), 0, Vector2i(0, 0), wall_type)
	set_cell(0, Vector2i(6, index * -1), 0, Vector2i(0, 0), wall_type)
	
	# left-right outer walls (aka just fillers/never reachable)
	set_cell(0, Vector2i(-1, index * -1), 2, Vector2i(4, 0))
	set_cell(0, Vector2i(7, index * -1), 2, Vector2i(4, 0))

func _on_player_reached_top():
	# todo: clear lower batch
	_spawn_next_batch()

