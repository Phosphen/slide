extends Node

@export var MARGIN = 256
@export var MAX_OFFSET = 100
@export var DISTANCE_BETWEEN_PLATFORMS = 10

@export var platform_scene: PackedScene
@export var wall_scene: PackedScene
#var platform_scene = preload("res://LevelGen/brick_scene_inv.tscn")

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
	last_platform_position = Vector2(screen_width * 0.5, screen_size.y)
	wall_index = 0
	_spawn_floor()
	_spawn_level_batch()
#	AudioManager.play_music(AudioManager.BEAKGROUND_MUSIC_3)


func _spawn_floor():
	for i in range(4):
		var floor_instance = wall_scene.instantiate()
		floor_instance.rotation_degrees = 90.0
		var sprite_size = _get_sprite_size(floor_instance)
		floor_instance.position = Vector2(MARGIN + i * sprite_size.y, screen_size.y)
		add_child(floor_instance)

func _spawn_level_batch():
	for i in range(10):
		_spawn_walls(wall_index + i)
	for i in range(3, 20):
		_spawn_platform(i)
	wall_index += 10

func _spawn_platform(index):
	var platform = platform_scene.instantiate()
	var sprite_size = _get_sprite_size(platform)

	add_child(platform)

	var from = last_platform_position.x - sprite_size.x * 0.5 - MAX_OFFSET
	var to = last_platform_position.x + sprite_size.x * 0.5 + MAX_OFFSET
	# make sure there are no overlaps with the walls
	from = max(from - sprite_size.x * 0.5, MARGIN + wall_width * 0.5 + sprite_size.x * 0.5)
	to = min(to + sprite_size.x * 0.5, screen_width - MARGIN - wall_width * 0.5 - sprite_size.x * 0.5)
	
	from = clampf(from, MARGIN, screen_width - MARGIN)
	to = clampf(to, MARGIN, screen_width - MARGIN)
	var x_pos = randf_range(from, to)
	var y_pos = last_platform_position.y - sprite_size.y * 0.5 - DISTANCE_BETWEEN_PLATFORMS * index;

	platform.position = Vector2(x_pos, y_pos)
	last_platform_position = platform.position
#	print("_spawn_platform ", x_pos , " ", y_pos)

func _spawn_walls(index):
	var wallLeft = wall_scene.instantiate()
	var wallRight = wall_scene.instantiate()
	var sprite_size = _get_sprite_size(wallLeft)
	
	wall_width = sprite_size.x
	
	# Y component is aka width in this context, because the sprite is rotated
	var posLeft = Vector2(MARGIN, screen_size.y - index * sprite_size.y)
	var posRight = Vector2(screen_width - MARGIN, screen_size.y - index * sprite_size.y)
	add_child(wallLeft)
	add_child(wallRight)
	wallLeft.position = posLeft
	wallRight.position = posRight

func _get_sprite_size(node_with_sprite):
	var sprite_node = node_with_sprite.get_child(0)
	var sprite_w = sprite_node.texture.get_width()
	var sprite_h = sprite_node.texture.get_height()
	return Vector2(sprite_w, sprite_h)

func _on_player_reached_top():
	_spawn_level_batch()
