extends RigidBody2D

var _is_static = false

func set_static(is_static):
	_is_static = is_static
	
func _on_timer_timeout():
	if _is_static:
		return
		
	# make the brick fall down
	sleeping = false
	freeze = false
	# self destroy after new timer
	var timer = Timer.new()
	self.add_child(timer)
	timer.connect("timeout", queue_free)
	timer.set_wait_time(3)
	timer.start()
