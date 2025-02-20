extends CharacterBody3D

@onready var head_node= $Head
@onready var rope_node = $Head/Rope
@onready var hook_node = $Head/Hook
@onready var camera := $Camera
@onready var hook_raycast: RayCast3D = $"Camera/Hook Raycast"
@onready var crosshair: TextureRect = $HUD/Crosshair

@export var movement_speed := 2.0
@export var friction_ground := 0.8
@export var friction_air := 0.85
@export var jump_force := 10.0
@export var gravity := 0.5
@export var mouse_sensetivity := 1.0
@onready var hook_controller: HookController = $HookController


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	
func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensetivity
		head_node.rotation_degrees.x -= event.realative.y * mouse_sensetivity
		head_node.rotation_degrees.x =  clamp(head_node.rotation_degrees.x, -90,90)

func _physics_process(delta: float) -> void:
	# Horizontal movement
	var movement_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	var movement_vector: Vector3 = (transform.basis * Vector3(movement_direction.x, 0, -movement_direction.y)).normalized()
	
	velocity += movement_vector * movement_speed * delta * 60
	
	match is_on_floor():
		true: velocity *= Vector3(friction_ground, 1, friction_ground)
		false: velocity *= Vector3(friction_air, 1, friction_air)
	
	# Gravity & Jumping
	if not is_on_floor():
		velocity.y -= gravity
	
	elif Input.is_action_pressed("jump"):
		velocity.y = jump_force
	
	move_and_slide()
	
	
	
	func make_rope() -> void:
		rope_node.look_at(hook_node.global position)
	
	# UI
	crosshair.texture = HOOK_AVAILIBLE_TEXTURE if hook_raycast.is_colliding() and not hook_controller.is_hook_launched else HOOK_NOT_AVAILIBLE_TEXTURE


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation_degrees.y -= event.relative.x * 0.06 * mouse_sensetivity
		
		camera.rotation_degrees.x -= event.relative.y * 0.06 * mouse_sensetivity
		
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
