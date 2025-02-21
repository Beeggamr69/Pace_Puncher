extends BulletEmitter

@onready var ray_cast_3d = $RayCast3D
const BULLET_HIT_EFFECT = preload("res://effects/bullet_hit_effect.tscn")

# create an editor visible var so hand weapons can make a visual impact
@export var only_hit_environment = false # for machete and other nonprojectile

# override the superclass function
func set_bodies_to_exclude (bodies: Array):
	# run the code in the superclass's function
	super(bodies)
	for body in bodies:
		# add exceptions to raycast
		ray_cast_3d.add_exception(body)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func fire():
	ray_cast_3d.enabled = true
	ray_cast_3d.force_raycast_update()
	if ray_cast_3d.is_colliding():
		var can_hurt = ray_cast_3d.get_collider().has_method("hurt")
		if can_hurt and only_hit_environment:
			pass
		elif can_hurt:
			var damage_data = DamageData.new() # damge
			damage_data.amount = damage
			damage_data.hit_pos = ray_cast_3d.get_collision_point()
			ray_cast_3d.get_collider().hurt(damage_data)
		else:
			var hit_effect_inst : Node3D = BULLET_HIT_EFFECT.instantiate()
			get_tree().get_root().add_child(hit_effect_inst)
			var hit_pos : Vector3 = ray_cast_3d.get_collision_point()
			var hit_normal : Vector3 = ray_cast_3d.get_collision_normal()
			# position the hit effect so it is aligned with the face normal of the object
			var look_at_pos : Vector3 = hit_pos + hit_normal
			hit_effect_inst.global_position = hit_pos
			# check if the face is up and change it so no weirdness
			if hit_normal.is_equal_approx(Vector3.UP) or hit_normal.is_equal_approx(Vector3.DOWN):
				hit_effect_inst.look_at(look_at_pos, Vector3.RIGHT)
			else:
				hit_effect_inst.look_at(look_at_pos)
	
	ray_cast_3d.enabled = false		
	super()
