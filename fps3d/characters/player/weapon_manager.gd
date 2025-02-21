extends Node3D

@onready var weapons = $Weapons.get_children()
var weapons_unlocked = []
var current_slot = 0
var current_weapon = null



# Called when the node enters the scene tree for the first time.
func _ready():
	for weapon in weapons:
		if weapon.has_method("set_bodies_to_exclude"):
			weapon.set_bodies_to_exclude([get_parent().get_parent()]) # set to exclude player
	disable_all_weapons() # no weapons at start
	for i in range(weapons.size()): # i is just a builtin throwaway variable stands for item
		#TODO for testing this is set to true, for game set to false
		weapons_unlocked.append(true)
	switch_to_weapon_slot(0)


func attack(input_just_pressed: bool, input_held: bool):
	if current_weapon is Weapon:
		current_weapon.attack(input_just_pressed, input_held)
# 
func disable_all_weapons():
	# for each item in the weapons array, if it can be activated, deactivate it
	for weapon in weapons:
		if weapon.has_method("set_active"):
			weapon.set_active(false)
		else:
			weapon.hide()	

# 
func switch_to_previous_weapon():
	#  step through the weapons list until it finds an active weapon
	for i in range(weapons.size()):
		var wrapped_ind = wrapi(current_slot - 1 - i, 0, weapons.size()) ###
		if switch_to_weapon_slot(wrapped_ind):
			break
# 
func switch_to_next_weapon():
		#  step through the weapons list until it finds an active weapon
	for i in range(weapons.size()):
		var wrapped_ind = wrapi(current_slot + 1 + i, 0, weapons.size()) ###
		if switch_to_weapon_slot(wrapped_ind):
			break

# 
func switch_to_weapon_slot(slot_ind: int) -> bool:
	# if they try to pick a weapon out of range
	if slot_ind >= weapons.size() or slot_ind < 0 :
		return false
	# if they try to pick a weapon that is not unlocked
	if weapons_unlocked.size() == 0 or !weapons_unlocked[slot_ind]:
		return false
	# switch the weapon
	disable_all_weapons()
	current_slot = slot_ind
	current_weapon = weapons[current_slot]
	if current_weapon.has_method("set_active"):
		current_weapon.set_active(true)
	else:
		current_weapon.show()
		
	return true
	
	# for testing weapon animations, using the timer set to autostart
func test_attack_animation():
	for weapon in weapons:
		weapon.get_node("Graphics/AnimationPlayer").play("Attack")
