extends Node3D

func _ready()-> void:
	$AnimationPlayer.play("animation")
	$AudioStreamPlayer.play()
