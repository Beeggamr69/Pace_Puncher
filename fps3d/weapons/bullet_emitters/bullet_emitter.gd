extends Node3D

class_name BulletEmitter # probably should change this name so not just bullets
#super class will add damge functionality to all children

var bodies_to_exclude = []
var damage = 1


func set_damage (d: int):
	damage = d
	for child in get_children():
		if child is BulletEmitter:
			child.set_damage(d)
	

func set_bodies_to_exclude (bodies: Array):
	bodies_to_exclude = bodies
	for child in get_children():
		if child is BulletEmitter:
			child.set_bodies_to_exclude(bodies)
		

func fire():
	print("fire")
	for child in get_children():
		if child is BulletEmitter:
			child.fire()
