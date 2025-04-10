extends Area3D

func _process(delta):
	var num = randf_range(-10, 10)
	rotate_y(.1)


func _on_body_entered(body: Node3D) -> void:
	$woinsound.play()
	queue_free()
	
