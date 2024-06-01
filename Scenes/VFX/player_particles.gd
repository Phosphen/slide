extends Node2D

@onready var jump_vfx : GPUParticles2D = $jump_vfx
@onready var landing_vfx : GPUParticles2D = $landing_vfx

func emit_jump_particles():
	jump_vfx.emitting = true

func emit_landing_particles():
	landing_vfx.emitting = true
