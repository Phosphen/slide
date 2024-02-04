extends TileMap

var platform_index = 0
const distance_between_platforms = 6
# Probability of spawning a double-width platform
var double_width_probability = 0.5  # 20% chance

func _ready():
	_spawn_next_batch()

func _spawn_next_batch():
	for i in range(20):
		_spawn_platform(platform_index + i)
	platform_index += 20

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

func _on_player_reached_top():
	# todo: clear lower batch
	_spawn_next_batch()
