extends Area3D

#func _process(delta):
	#var num = randf_range(-10, 10)
	#rotate_z(.1)



func _on_body_entered(body: Node3D) -> void:
	$thecube.play()


func _on_thecube_finished() -> void:
	queue_free()
