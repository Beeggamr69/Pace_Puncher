extends Node3D
# this is an example of composition where a component can be added to a class to provide functionality
# this is a different approach than creating a base class and inheriting functionality

@export var max_health = 100
@onready var current_health = max_health
@export var gib_at = -10 #how much over the top does the death need to be to splatter
@export var verbose = false  # debugging

signal died
signal healed
signal damaged
signal gibbed
signal health_changed(current_health, max_health)

# Called when the node enters the scene tree for the first time.
func _ready():
	health_changed.emit(current_health, max_health)
	if verbose:
		print("starting health: %s/%s" % [current_health, max_health])


func hurt(damage_data : DamageData):
	# if the player is dead just return
	if current_health < 0:
		return

# otherwise damge according to damage data
	current_health -= damage_data.amount
# if they are hurt extremely, then gib
	if current_health < gib_at:
		gibbed.emit()
	# dead
	if current_health < 0:
		died.emit()
	else:
		damaged.emit()
	#update health
	health_changed.emit(current_health, max_health)
	
	if verbose:
		print("Damaged for %s, health: %s/%s" % [damage_data.amount, current_health, max_health])
	
# heal function
func heal(amount : int):
	if current_health < 0:
		return
	
	current_health = clamp(current_health + amount, 0, max_health)
	healed.emit()
	health_changed.emit(current_health, max_health)
	if verbose:
		print("Healed for %s, health: %s/%s" % [amount, current_health, max_health])


# a function for testing things when the character is hurt 
# (set timers to autostart and connect timeout signals to test damge and heal functions)
func test_damage():
	var d = DamageData.new()
	d.amount = 30
	hurt(d)
