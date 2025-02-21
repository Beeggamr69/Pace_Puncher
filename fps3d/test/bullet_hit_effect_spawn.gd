extends Marker3D

const BULLET_HIT_EFFECT = preload("res://effects/bullet_hit_effect.tscn")
var spawn_rate = 3.0
var spawn_time = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	spawn_time -= delta
	if spawn_time < 0.0:
		spawn_time = spawn_rate
		var effect_instance = BULLET_HIT_EFFECT.instantiate()
		effect_instance.global_transform = global_transform
		get_tree().get_root().add_child(effect_instance)
		
