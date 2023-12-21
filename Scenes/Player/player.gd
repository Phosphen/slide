extends CharacterBody2D

signal reached_height
signal reached_top
signal falling_to_death
const TOP_HEIGHT = 100

var max_reached_height = 0.0


#Data
var is_wall_bouncing = false
var is_jumping = false
var played_rot_jump = false
var fall_time = 0.0  # Time the player has been falling

@export var movement_data : MovementData
@export var stats : Stats
@export var wall_bounce_strength = Vector2(30, 30) 
@export var rotation_speed = 360
@export var high_jump_treshold = 300.0
@export var max_fall_time = 2.0  # Maximum time player can fall before game over
@export var max_fall_speed: float = 600.0  # Max speed in any direction

#Refrences
@onready var animator : AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_animator : AnimationPlayer = $HitAnimationPlayer

@export var camera : Camera2D

func _ready():
	stats.health = stats.max_health
	EventManager.update_bullet_ui.emit()

func _process(delta):
	if ((position.y as int) % TOP_HEIGHT) == 0.0:
		reached_top.emit()
	#max_reached_height = minf(position.y, max_reached_height)
	#reached_height.emit(abs(max_reached_height))
	
		
func is_on_and_facing_wall():
	return $WallChecker.is_colliding()
	
func is_falling() -> bool:
	# Check if the player is moving downwards
	if velocity.y > 0:
		# Check if the player is not on the ground
		if not is_on_floor():
			return true
	return false
	
func trigger_game_over():
	falling_to_death.emit()
	# Game over logic here, like showing a game over screen or resetting the level
	print("Game Over!")

func _physics_process(delta):
	var input_vector = Input.get_axis("move_left", "move_right")
	if input_vector != 0 :
		apply_acceleration(input_vector, delta)
	elif is_on_floor():
		apply_friction(delta)
	
	apply_gravity(delta)
	
	if is_on_floor() and is_jumping:
		is_jumping = false
		played_rot_jump = false

	
	if Input.is_action_just_pressed("jump") and (is_on_floor() or is_on_special_wall("jump")):
		jump()
		if abs(velocity.x) > high_jump_treshold:
			is_jumping = true
	
	jump_rotation(delta)
   
	# Flip           false   true
	# Direction      left, : right
	# InputVecotr     -1   :   +1
	var current_player_direction = -1 if animator.flip_h == true else 1
	if is_on_and_facing_wall() and is_on_floor() and input_vector != 0 and input_vector != current_player_direction:
		wall_bounce(input_vector)
	
	if is_on_special_wall("fly") and Input.is_action_pressed("jump"):
		velocity.y -= wall_bounce_strength.y
	
	# Clamp the falling speed
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed
	
	move_and_slide()
	animate(input_vector)
	
	if is_falling():  # You need to define this function based on your game logic
		fall_time += delta
		if fall_time > max_fall_time:
			trigger_game_over()
	else:
		fall_time = 0.0
		
func apply_acceleration(input_vector, delta):
	velocity.x = lerp(velocity.x, movement_data.max_speed * input_vector, movement_data.acceleration * delta)

func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += movement_data.gravity * movement_data.gravity_scale * delta

func knockback(vector):
	velocity = velocity.move_toward(vector * movement_data.knockback_force, movement_data.acceleration)

func jump():
	var speed_factor = lerp(1.0, movement_data.high_jump_multiplier, abs(velocity.x) / movement_data.max_speed)
	velocity.y = -movement_data.jump_strength * speed_factor
	AudioManager.play_sound(AudioManager.JUMP)

func jump_rotation(delta):
	if is_jumping:
		$AnimatedSprite2D.rotation_degrees += rotation_speed * delta
		if not played_rot_jump:
			AudioManager.play_sound(AudioManager.JUMP_WTF)
			played_rot_jump = true
	else:
		# Reset rotation and jumping state when falling down or landing
		$AnimatedSprite2D.rotation_degrees = 0



func wall_bounce(input_vector):
	velocity.x = -velocity.x * wall_bounce_strength.x	
#	velocity.x = -velocity.x + wall_bounce_strength.x
#	velocity.y = velocity.y - wall_bounce_strength.y 

	# Indicate that we are now bouncing off the wall
	is_wall_bouncing = true

func is_on_special_wall(wall_type):
	var colliding = $WallChecker.is_colliding()
	var collidingOtherSide = $WallCheckerBack.is_colliding()
	
	if colliding:
		var collider = $WallChecker.get_collider()
		if collider.has_meta("wall_type") and collider.get_meta("wall_type") == wall_type:
			return true
	if collidingOtherSide:
		var colliderOtherSide = $WallCheckerBack.get_collider()
		if colliderOtherSide.has_meta("wall_type") and colliderOtherSide.get_meta("wall_type") == wall_type:
			return true

	return false

func small_shake():
	camera.small_shake()

func animate(input_vector):
	if input_vector != 0:
		animator.flip_h = input_vector < 0
		$WallChecker.rotation_degrees = 90 * -input_vector
	
	if is_on_floor():
		if input_vector != 0:
			animator.play("run")
		elif !velocity.is_zero_approx():
			animator.play("slide")
		else:
			animator.play("idle")
	else:
		animator.play("jump")

func die():
	AudioManager.play_sound(AudioManager.DEATH)
	EventManager.player_died.emit()
	queue_free()
