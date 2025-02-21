extends CharacterBody3D

# the player has some basic functionality but things are handled by
# other scripts that control by composition ( has)
# charactermover
# healthmanager
# weaponmanager

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
#INFO you can click drag a node from the scene , press ctrl and release in the script to auto create vars
@onready var camera_3d = $Camera3D
@onready var character_mover = $CharacterMover
@onready var health_manager = $HealthManager
@onready var weapon_manager = $Camera3D/Weapon_Manager

@export var mouse_sensitivty_h = 0.25
@export var mouse_sensitivty_v = 0.25

#define keys for inventory
const HOTKEYS = {
	KEY_1: 0,
	KEY_2: 1,
	KEY_3: 2,
	KEY_4: 3,
	KEY_5: 4,
	KEY_6: 5,
	KEY_7: 6,
	KEY_8: 7,
	KEY_9: 8,
	KEY_0: 9,
}

var dead = false

func _ready():
	# make sure mouse is owned by the game
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# connect signals
	health_manager.died.connect(kill)

func _input(event):
	# if the player is dead , dont move camera
	if dead:
		return
	# mouse controls camera rotation
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivty_h
		camera_3d.rotation_degrees.x -= event.relative.y * mouse_sensitivty_v
		camera_3d.rotation_degrees.x = clamp(camera_3d.rotation_degrees.x, -90, 90)
	# if the mouse wheel  is rotated, switch weapons
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			weapon_manager.switch_to_previous_weapon()
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			weapon_manager.switch_to_next_weapon()
	# check for number keys and switch to weapon
	if event is InputEventKey and event.is_pressed() and event.keycode in HOTKEYS:
		weapon_manager.switch_to_weapon_slot(HOTKEYS[event.keycode])
		
		
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("fullacreen"):
		# fs is a bool true or false
		var fs = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		# if true
		if fs:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	# if the player is dead skip the movement code
	if dead:
		return
		
	# create a 2d vector based on inputs
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	# convert to a 3d vector based on the base transform direction of the player and normalize (0-1 range)
	var move_dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	character_mover.set_move_dir(move_dir)
	
	if Input.is_action_just_pressed("jump"):
		character_mover.jump()
	
	weapon_manager.attack(Input.is_action_just_pressed("attack"), Input.is_action_pressed("attack"))
	
# 
func _physics_process(delta):
	pass


func kill():
	dead = true
	character_mover.set_move_dir(Vector3.ZERO)
	

func hurt(damage_data : DamageData):
	health_manager.hurt(damage_data)
