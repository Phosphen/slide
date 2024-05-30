extends Node2D

@onready var dust_vfx : GPUParticles2D = $dust_vfx
@onready var landing_vfx : GPUParticles2D = $landing_vfx

func emit_dust_particles():
	dust_vfx.emitting = true

func emit_landing_particles():
	landing_vfx.emitting = true
