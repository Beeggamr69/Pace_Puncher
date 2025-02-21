extends BulletEmitter

@onready var line_of_sight_ray_cast_3d = $LineOfSightRayCast3D
@export var attack_radius := 1.0

@export var offset_by_radius = false

func fire():
	var query_params := PhysicsShapeQueryParameters3D.new()
	query_params.shape = SphereShape3D.new()
	query_params.shape.radius = attack_radius
	query_params.collision_mask = 2 # collision mask layer
	var tr = global_transform # transform
	
	# should it move or not?
	if offset_by_radius:
		tr.origin = to_global(Vector3.FORWARD * attack_radius)
	query_params.transform = tr
	query_params.exclude = bodies_to_exclude # set in the parent class bullet_emitter
	# store the intersections as an array of dictionaries (name value pairs)
	var intersect_results : Array[Dictionary] = get_world_3d().direct_space_state.intersect_shape(query_params)
	for intersect_data in intersect_results:
		var collider : Node3D = intersect_data.collider
		if collider.has_method("hurt") and has_los(collider):
			var damage_data = DamageData.new()
			damage_data.amount = damage
			damage_data.hit_pos = collider.global_position + Vector3.UP
			collider.hurt(damage_data)
	super()
	

# can the player see it / hit it?
func has_los(collider : Node3D) -> bool:
	line_of_sight_ray_cast_3d.enabled = true
	line_of_sight_ray_cast_3d.target_position = line_of_sight_ray_cast_3d.to_local(collider.global_position + Vector3.UP)
	line_of_sight_ray_cast_3d.force_raycast_update()
	var in_los = line_of_sight_ray_cast_3d.is_colliding()
	line_of_sight_ray_cast_3d.enabled = false
	return in_los
