extends CSGBox3D

func _physics_process(delta: float) -> void:
	var num = randf_range(-100, 100)
	position.y = num * tan(Time.get_ticks_msec() * 0.001) * 5.0
