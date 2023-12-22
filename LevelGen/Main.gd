extends Node

@export var MARGIN = 240
@export var MAX_OFFSET = 100
@export var DISTANCE_BETWEEN_PLATFORMS = 70

@export var platform_scene: PackedScene
@export var wall_scene: PackedScene
@export var ground_scene: PackedScene

@export var normal_wall_weight = 70  # 70% chance to be a normal wall
@export var jump_wall_weight = 15    # 15% chance to be a jump wall
@export var fly_wall_weight = 15     # 15% chance to be a fly wall
@export var wall_min_batch_size = 3  
var last_wall_type = ""
var current_wall_batch_count = 0

# Probability of spawning a double-width platform
var double_width_probability = 0.2  # 20% chance

var last_platform_position
var screen_size
var screen_width
var middle
var wall_index

var wall_width:float = 0.0

func _ready():
#	screen_size = get_viewport().size
	screen_size = Vector2(800, 600)
	screen_width = screen_size.x  # Adjust based on your game's resolution
	last_platform_position = Vector2(screen_width * 0.5, -DISTANCE_BETWEEN_PLATFORMS)
	wall_index = 0
	_spawn_floor()
	_spawn_level_batch()
#	AudioManager.play_music(AudioManager.BEAKGROUND_MUSIC_3)


func _spawn_floor():
	for i in range(5):
		var floor_instance = ground_scene.instantiate()
		floor_instance.set_name("Ground")
		var sprite_size = _get_sprite_size(floor_instance)

		floor_instance.position = Vector2(MARGIN + i * sprite_size.x, 0)
		add_child(floor_instance, true)

func _spawn_level_batch():
	for i in range(10):
		_spawn_walls(wall_index + i)
	for i in range(20):
		_spawn_platform(i)
	wall_index += 10

func _spawn_platform(index):
	var platform = platform_scene.instantiate()
	platform.set_name("Platform")
	var sprite_size = _get_sprite_size(platform)

	# Determine if this platform should be double-width
	var is_double_width = randf() < double_width_probability
	if is_double_width:
		# Adjust the sprite size for double width (e.g., double the x size)
		sprite_size.x *= 2
		# If the platform has a sprite node, adjust its scale or texture size
		var sprite = platform.get_node("Sprite2D")
		if sprite:
			sprite.scale.x *= 2

	add_child(platform, true)

	var from = last_platform_position.x - sprite_size.x * 0.5 - MAX_OFFSET
	var to = last_platform_position.x + sprite_size.x * 0.5 + MAX_OFFSET
# make sure there are no overlaps with the walls
	from = max(from - sprite_size.x * 0.5, MARGIN + wall_width * 0.5 + sprite_size.x * 0.5)
	to = min(to + sprite_size.x * 0.5, screen_width - MARGIN - wall_width * 0.5 - sprite_size.x * 0.5)
	
	from = clampf(from, MARGIN, screen_width - MARGIN)
	to = clampf(to, MARGIN, screen_width - MARGIN)
	var x_pos = randf_range(from, to)
	var y_pos = last_platform_position.y - sprite_size.y * 0.5 - DISTANCE_BETWEEN_PLATFORMS;

	platform.position = Vector2(x_pos, y_pos)
	last_platform_position = platform.position

func _spawn_walls(index):
	var wallLeft = get_random_wall()
	var wallRight = get_random_wall()
	wallLeft.set_name("Wall")
	wallRight.set_name("Wall")
		
	var sprite_size = _get_sprite_size(wallLeft)
	
	wall_width = sprite_size.x
	
	# Y component is aka width in this context, because the sprite is rotated
	var posLeft = Vector2(MARGIN, -1 * index * sprite_size.y)
	var posRight = Vector2(screen_width - MARGIN, -1 * index * sprite_size.y)
	add_child(wallLeft, true)
	add_child(wallRight, true)
	wallLeft.position = posLeft
	wallRight.position = posRight

func create_normal_wall():
	current_wall_batch_count += 1
	var wall = wall_scene.instantiate()
	wall.set_meta("wall_type", "normal") 
	return wall

func create_jump_wall():
	current_wall_batch_count += 1
	var jump_scene = wall_scene.instantiate()
	jump_scene.get_node("Sprite2D").modulate = Color(0.5, 0.5, 1, 1)
	jump_scene.set_meta("wall_type", "jump") 
	return jump_scene

func create_fly_wall():
	current_wall_batch_count += 1
	var fly_scene = wall_scene.instantiate()
	fly_scene.get_node("Sprite2D").modulate = Color(0.2, 0.27, 1.0, 1)
	fly_scene.set_meta("wall_type", "fly") 
	return fly_scene
	
func get_random_wall():
	if current_wall_batch_count >= wall_min_batch_size:
		last_wall_type = ""
		current_wall_batch_count = 0

	if last_wall_type != "":
		if last_wall_type == "jump":
			return create_jump_wall()
		elif last_wall_type == "fly":
			return create_fly_wall()
		elif last_wall_type == "normal":
			return create_normal_wall()
			
	var rand_value = randi() % 100  # Get a random value between 0 and 99
	if rand_value < normal_wall_weight:
		last_wall_type = "normal"
		return create_normal_wall()
	elif rand_value < normal_wall_weight + jump_wall_weight:
		last_wall_type = "jump"
		return create_jump_wall()
	else:
		last_wall_type = "fly"
		return create_fly_wall()
	
func _get_sprite_size(node_with_sprite):
	var sprite_node = node_with_sprite.get_child(0)
	var sprite_w = sprite_node.texture.get_width()
	var sprite_h = sprite_node.texture.get_height()
	return Vector2(sprite_w, sprite_h)

func _on_player_reached_top():
	_spawn_level_batch()
