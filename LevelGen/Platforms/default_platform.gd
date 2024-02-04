extends RigidBody2D

func _on_timer_timeout():
	# make the brick fall down
	sleeping = false
	freeze = false
	# self destroy after new timer
	var timer = Timer.new()
	self.add_child(timer)
	timer.connect("timeout", queue_free)
	timer.set_wait_time(3)
	timer.start()
