extends Node3D
# an attempt to make a general purpose character mover for all characters
# this is an example of composition where a component can be added to a class to provide functionality
# this is a different approach than creating a base class and inheriting functionality


@export var jump_force = 15.0
@export var gravity = 30.0

@export var max_speed = 15.0
@export var move_accel = 4.0
@export var stop_drag = 0.9

var character_body : CharacterBody3D
var move_drag = 0.0
var move_dir : Vector3

# set things up
func _ready():
	character_body = get_parent()
	# drag increases as acceleration apporaches max speed
	move_drag = float(move_accel / max_speed)


func set_move_dir(new_move_dir : Vector3):
	# set the local var to the passed in value
	move_dir = new_move_dir
	
	
func jump():
	if character_body.is_on_floor():
		character_body.velocity.y = jump_force

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# set the up velocity to 0 if the character hits the ceiling
	if character_body.velocity.y > 0.0 and character_body.is_on_ceiling():
		character_body.velocity.y = 0
	# if the character is in the air, apply gravity
	if not character_body.is_on_floor():
		character_body.velocity.y -= gravity * delta

	var drag = move_drag
	if move_dir.is_zero_approx():
		drag = stop_drag
		
	var flat_vel = character_body.velocity
	flat_vel.y  = 0.0
	# flatten vel as it nears max speed
	character_body.velocity += move_accel * move_dir - flat_vel * drag
	
	character_body.move_and_slide()
