extends Node3D

class_name Weapon

@onready var animation_player : AnimationPlayer = $Graphics/AnimationPlayer
@onready var bullet_emitter : BulletEmitter = $"Bullet Emitter"
@onready var fire_point : Node3D = %FirePoint

@export var automatic = false
@export var damage = 5
@export var ammo =  30
@export var attack_rate = 0.2
var last_attack_time = -9999.0

@export var animation_controlled_attack = false

signal fired
signal out_of_ammo

# Called when the node enters the scene tree for the first time.
func _ready():
	bullet_emitter.set_damage(damage)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func set_bodies_to_exclude (bodies: Array):
	bullet_emitter.set_bodies_to_exclude (bodies)
	

func attack(input_just_pressed : bool, input_held : bool):
	if !automatic and !input_just_pressed:
		return
	if automatic and !input_held:
		return
	
	if ammo == 0:
		print("no ammo")
		if input_just_pressed:
			out_of_ammo.emit()
		return
	
	var curr_time = Time.get_ticks_msec()/1000.0 #seconds
	if curr_time - last_attack_time < attack_rate:
		return  # too soon, can't attack yet
## check ammo above 0, so ammo less weapons like machete wont hit this check or decrement
	if ammo > 0: 
		ammo -= 1
		print(ammo)

	# the animation doesnt control the attack, just go ahead and attack
	if !animation_controlled_attack:
		actually_attack()
	last_attack_time = curr_time
	animation_player.stop()
	animation_player.play("Attack")
	if has_node("Graphics/MuzzleFlash"):
		$Graphics/MuzzleFlash.flash()


# do the attack
func actually_attack():
	bullet_emitter.global_transform = fire_point.global_transform
	bullet_emitter.fire()
	

func set_active(a : bool):
	$Crosshairs.visible = a
	visible = a
	if !a:
		animation_player.play("RESET")
