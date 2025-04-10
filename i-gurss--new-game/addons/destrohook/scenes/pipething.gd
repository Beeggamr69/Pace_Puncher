extends CSGTorus3D

func _physics_process(delta: float) -> void:
	var num = randf_range(-10, 10)
	rotate_y(.01)
