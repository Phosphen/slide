extends CharacterBody2D

signal reached_top
const TOP_HEIGHT = 100

#Data
var is_wall_bouncing = false
var is_jumping = false

@export var movement_data : MovementData
@export var stats : Stats
@export var wall_bounce_strength = Vector2(30, 30) 
@export var rotation_speed = 360
@export var high_jump_treshold = 300.0

#Refrences
@onready var animator : AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_animator : AnimationPlayer = $HitAnimationPlayer

@export var camera : Camera2D

func _ready():
	stats.health = stats.max_health
	EventManager.update_bullet_ui.emit()

func _process(delta):
	print("x ", velocity.x)
	if is_jumping:
		# Rotate the character
		print("rotating ", velocity.y)
		$AnimatedSprite2D.rotation_degrees += rotation_speed * delta
	else:
		# Reset rotation and jumping state when falling down or landing
		$AnimatedSprite2D.rotation_degrees = 0
	
	if ((position.y as int) % TOP_HEIGHT) == 0.0:
		reached_top.emit()

func _physics_process(delta):
	var input_vector = Input.get_axis("move_left", "move_right")
	if input_vector != 0 :
		apply_acceleration(input_vector, delta)
	elif is_on_floor():
		apply_friction(delta)
	
	apply_gravity(delta)
		
	if is_on_floor() and is_jumping:
		is_jumping = false
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
		
	if Input.is_action_just_pressed("jump") and is_on_floor() and abs(velocity.x) > high_jump_treshold:
		jump()
		is_jumping = true
	
	if is_on_wall():
		wall_bounce(input_vector)
	
	move_and_slide()
	animate(input_vector)
		

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

func wall_bounce(input_vector):
	velocity.x = -velocity.x + wall_bounce_strength.x * -sign(input_vector)
#	velocity.x = -velocity.x + wall_bounce_strength.x
	velocity.y = velocity.y - wall_bounce_strength.y 

	# Indicate that we are now bouncing off the wall
	is_wall_bouncing = true


func small_shake():
	camera.small_shake()

func animate(input_vector):
	if input_vector != 0:
		animator.flip_h = input_vector < 0
	
	if is_on_floor():
		if input_vector != 0:
			animator.play("run")
		else:
			animator.play("idle")
	else:
		animator.play("jump")

func _on_hurtbox_area_entered(_area):
	hit_animator.play("Hit")
	EventManager.update_health_ui.emit()
	if stats.health <= 0:
		die()
	else:
		AudioManager.play_sound(AudioManager.HURT)
		EventManager.frame_freeze.emit()

func die():
	AudioManager.play_sound(AudioManager.DEATH)
	EventManager.player_died.emit()
	queue_free()
