extends BulletEmitter

const PROJECTILES = [
	preload("res://weapons/projectiles/rocket.tscn")
]
# a list of projectile types
enum PROJECTILE_TYPE {
	ROCKET,
}

# make it choosable in the editor
@export var projectile_type : PROJECTILE_TYPE


func fire():
	var projectile_instance : Projectile = PROJECTILES[projectile_type].instantiate()
	projectile_instance.global_transform = global_transform
	projectile_instance.damage = damage
	get_tree().get_root().add_child(projectile_instance)
	
	projectile_instance.add_to_group("instanced")
	
	# you can delete all instances in a group like this (for instance if you change scenes)
	# get_tree().call_group("instanced", "queue_free")
	
	projectile_instance.set_bodies_to_exclude(bodies_to_exclude)
	# call the super class
	super()
	
