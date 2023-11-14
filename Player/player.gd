extends CharacterBody2D

#Data
var bullets_amount : int = 30
var is_wall_bouncing = false

@export var movement_data : MovementData
@export var stats : Stats
@export var wall_bounce_strength = Vector2(30, 30) 

#Refrences
@onready var animator : AnimatedSprite2D = $AnimatedSprite2D
@onready var guns_animator : AnimationPlayer = $ShootingAnimationPlayer
@onready var hit_animator : AnimationPlayer = $HitAnimationPlayer
@onready var hand : Node2D = $Hand
@onready var pistol : Sprite2D = $Hand/Pivot/Pistol
@onready var pistol_bullet_marker : Marker2D = $Hand/Pivot/Pistol/PistolBulletMarker

@export var camera : Camera2D

func _ready():
	stats.health = stats.max_health
	EventManager.bullets_amount = bullets_amount
	EventManager.update_bullet_ui.emit()

func _physics_process(delta):
	var input_vector = Input.get_axis("move_left", "move_right")
	if input_vector != 0 :
		apply_acceleration(input_vector, delta)
	elif is_on_floor():
		apply_friction(delta)
	
	apply_gravity(delta)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
	
	# if Input.is_action_just_pressed("shoot"):
	# 	if bullets_amount > 0:
	# 		guns_animator.play("Shoot")
	
	
	if is_on_wall():
		wall_bounce(input_vector)
	
	move_and_slide()
	animate(input_vector)
		

func apply_acceleration(input_vector, delta):
	velocity.x = lerp(velocity.x, movement_data.max_speed * input_vector, movement_data.acceleration * delta)

#func apply_friction(delta):
#	if velocity.x != 0:
#		velocity.x = lerp(velocity.x, 0.0, movement_data.friction * delta)

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
	var mouse_position : Vector2 = (get_global_mouse_position() - global_position).normalized()
	if mouse_position.x > 0 and animator.flip_h:
		animator.flip_h = false
	elif mouse_position.x < 0 and not animator.flip_h:
		animator.flip_h = true
	
	hand.rotation = mouse_position.angle()
	if hand.scale.y == 1 and mouse_position.x < 0:
		hand.scale.y = -1
	elif hand.scale.y == -1 and mouse_position.x > 0:
		hand.scale.y = 1
	
	if is_on_floor():
		if input_vector != 0:
			animator.play("Run")
		else:
			animator.play("Idle")
	else:
		if velocity.y > 0:
				animator.play("Fall")
		else:
				animator.play("Jump")

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