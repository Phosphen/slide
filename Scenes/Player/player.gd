extends CharacterBody2D

signal reached_top
signal falling_to_death

var rip: bool = false
var max_reached_height: float = 0.0
var last_trigger_height: float = 0.0  # To track the last height at which the event was triggered
var last_velocity: Vector2 = Vector2.ZERO
var was_on_ground: bool = true
var is_wall_bouncing = false
var is_jumping = false
var is_in_air = false
var played_rot_jump = false
var fall_time = 0.0  # Time the player has been falling

@export var TOP_HEIGHT = 100
@export var movement_data : MovementData
@export var wall_bounce_strength = Vector2(30, 30) 
@export var rotation_speed = 360
@export var high_jump_treshold = 300.0
@export var max_fall_time = 1.5  # Maximum time player can fall before game over
@export var max_fall_speed: float = 600.0  # Max speed in any direction
@export var camera : Camera2D
@export var landing_particles_velocity_threshold : float = 350

@onready var animator : AnimatedSprite2D = $AnimatedSprite2D
@onready var vfx = $PlayerParticles
@onready var jump_anticipation_timer : Timer = $jump_anticipation_timer
@onready var coyote_timer: Timer = $coyote_timer

func _ready():
	pass

func _process(_delta):
	if position.y < max_reached_height:
		max_reached_height = position.y
		GameEnvironment.update_reached_hight(abs(max_reached_height / 100))

	# Calculate the height difference since the last trigger
	var height_difference = max_reached_height - last_trigger_height

	if height_difference <= -TOP_HEIGHT:
		reached_top.emit()
		last_trigger_height = max_reached_height
	
		
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
	if rip:
		return
		
	falling_to_death.emit()
	rip = true

func _physics_process(delta):
	var input_vector = Input.get_axis("move_left", "move_right")
	
	if input_vector != 0 :
		apply_acceleration(input_vector, delta)
	elif is_on_floor():
		apply_friction(delta)
	
	apply_gravity(delta)
	
	if was_on_ground:
		coyote_timer.start()
	
	# spawn landing vfx on landing
	if is_on_floor():
		was_on_ground = true
		if is_in_air:
			is_in_air = false
			is_jumping = false
			played_rot_jump = false
			if last_velocity.y > landing_particles_velocity_threshold:
				vfx.emit_landing_particles()
	else:
		is_in_air = true
		was_on_ground = false

	if Input.is_action_just_pressed("jump"):
		jump_anticipation_timer.start()

	# spawn dust vfx
	if Input.is_action_just_pressed("jump") and is_on_floor():
		vfx.emit_dust_particles()
	
	var is_on_floor_proxy = is_on_floor() or !coyote_timer.is_stopped()
	var wants_to_jump = (Input.is_action_just_pressed("jump") or !jump_anticipation_timer.is_stopped())
	if wants_to_jump and (is_on_floor_proxy or is_on_special_wall("jump")):
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
	if is_on_and_facing_wall() and is_on_floor() and input_vector == current_player_direction:
		velocity.x = -sign(velocity.x) * wall_bounce_strength.x
		var collider = $WallChecker.get_collider()
		var character_position = global_position
		var collider_position = collider.global_position
		# Determine the direction of the wall
		var direction = -1 if collider_position.x > character_position.x else 1
		# Apply force in the opposite direction
		velocity.x += direction * wall_bounce_strength.x * 100

	if is_on_special_wall("fly") and Input.is_action_pressed("jump"):
		velocity.y -= wall_bounce_strength.y
	
	# Clamp the falling speed
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed
	
	last_velocity = velocity
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



func wall_bounce(_input_vector):
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
	GameEnvironment.player_died.emit()
	queue_free()
