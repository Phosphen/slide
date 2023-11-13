extends CharacterBody2D


const SPEED = 600.0
# 2D Engines negative is up and positive is down
const JUMP_VELOCITY = -500.0
const ACCELERATION = 700
const FRICTION = 700

# # Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):

	apply_gravity(delta)

	handle_jump()
	var input_axis = Input.get_axis("ui_left", "ui_right")
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta) 
	move_and_slide()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_jump():
	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
		if Input.is_action_just_pressed("ui_accept") && (velocity.x > 590 || velocity.x < -590):
			velocity.y = JUMP_VELOCITY * 2.5
	else:
		# for short jumps and prevent flying by push jump multiple times
		if Input.is_action_just_released("ui_accept") and (velocity.y < JUMP_VELOCITY / 2):
			velocity.y = JUMP_VELOCITY / 2

func apply_friction(input_axis, delta):
	if input_axis == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta) 

func handle_acceleration(input_axis, delta):
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, SPEED * input_axis, ACCELERATION * delta)
		print(velocity.x)


