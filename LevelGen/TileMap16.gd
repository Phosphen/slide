extends TileMap

var platform_index = 0
const distance_between_platforms = 6
# Probability of spawning a double-width platform
var double_width_probability = 0.5  # 20% chance

func _ready():
	#_spawn_start_platforms()
	_spawn_next_batch()

func _spawn_start_platforms():
	for i in range(3):
		_spawn_static_platform(platform_index + i)
	platform_index += 3

func _spawn_next_batch():
	for i in range(5):
		_spawn_platform(platform_index + i)
	platform_index += 5

# xRange wall to wall: 5 <-> 24
func _spawn_platform(index):
	index *= distance_between_platforms
	
	# Determine if this platform should be double-width
	var is_double_width = randf() < double_width_probability
	if is_double_width:
		var randomX = randi_range(9, 20)
		set_cell(0, Vector2i(randomX - 0, index * -1), 2, Vector2i(0, 0), 4)
	else:
		var randomX = randi_range(7, 22)
		set_cell(0, Vector2i(randomX - 0, index * -1), 2, Vector2i(0, 0), 2)

func _spawn_static_platform(index):
	index *= distance_between_platforms
	
	var randomX = randi_range(7, 22)
	set_cell(0, Vector2i(randomX - 0, index * -1), 2, Vector2i(0, 0), 1)

func _on_player_reached_top():
	# todo: clear lower batch
	_spawn_next_batch()
	var player = $"../Player"
	var player_posY = local_to_map(player.position).y
	print("Player: ", player_posY)
	var cells = get_used_cells(0)
	
	for cell in cells:
		if cell.y > (player_posY + 16):
			# delete cell
			set_cell(0, cell, -1, Vector2i(-1, -1), -1)
			
