class_name  Projectile
extends Node3D

@onready var collision_ray_cast_3d = $"Collision RayCast3D"

@export var speed = 30
# vars to wait to show the projectile and delete it after some time
@export var show_after_time := 0.1
# the particle trail needs to fade before the projectile deletes itself
@export var delete_on_hit_after_time := -1.0

const MAX_PROJECTILE_LIFESPAN := 18.00
var bodies_to_exclude = []
var damage = 1

var last_pos : Vector3

func _ready():
	hide()
	await get_tree().create_timer(show_after_time).timeout
	show()
	await get_tree().create_timer(MAX_PROJECTILE_LIFESPAN).timeout
	queue_free()
	
	
func set_bodies_to_exclude(bte : Array):
	bodies_to_exclude = bte
	for b in bodies_to_exclude:
		collision_ray_cast_3d.add_exception(b)


func _physics_process(delta):
	process_movement(delta)
	check_collisions()

# movement super 
func process_movement(delta):
	last_pos = global_position
	global_position += -global_transform.basis.z * speed * delta
	
	
func check_collisions():
	# raycast from last pos to current pos
	collision_ray_cast_3d.global_position = last_pos
	collision_ray_cast_3d.target_position = collision_ray_cast_3d.to_local(global_position)
	# turn raycast on
	collision_ray_cast_3d.enabled = true
	collision_ray_cast_3d.force_raycast_update()
	var is_colliding = collision_ray_cast_3d.is_colliding()
	var hit_pos = collision_ray_cast_3d.get_collision_point()
	var hit_normal = collision_ray_cast_3d.get_collision_normal()
	var hit_collider = collision_ray_cast_3d.get_collider()
	collision_ray_cast_3d.enabled = false
	
	if is_colliding:
		on_hit(hit_collider, hit_pos, hit_normal)
		
	
func on_hit(hit_collider : Node3D, hit_pos : Vector3, hit_normal : Vector3):
	global_position = hit_pos
	if hit_collider.has_method("hurt"):
		damage_target(hit_collider, hit_pos, hit_normal)
	destroy()
		

# this does all the damage stuff
func damage_target(hit_collider : Node3D, hit_pos : Vector3, hit_normal : Vector3):
	var damage_data = DamageData.new()
	damage_data.amount = damage
	damage_data.hit_pos = hit_pos
	hit_collider.hurt(damage_data)

# destroy the projectile after a moment, or right away
func destroy():
	if delete_on_hit_after_time > 0:
		$Graphics.hide()
		set_process(false)
		set_physics_process(false)
		await get_tree().create_timer(delete_on_hit_after_time).timeout
		queue_free()
	else:
		queue_free()
