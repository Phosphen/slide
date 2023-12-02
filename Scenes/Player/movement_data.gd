extends Resource
class_name MovementData

#Data
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var max_speed : float
@export var acceleration : float
@export var friction : float
@export var gravity_scale : float
@export var jump_strength : float
@export var high_jump_multiplier : float
@export var knockback_force : float
