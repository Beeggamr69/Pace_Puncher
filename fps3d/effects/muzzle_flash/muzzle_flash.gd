extends Node3D

@export var flash_time := 0.05 #colon assigns the type at the same time as the 

var timer : Timer

# setup the timer
func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = flash_time
	timer.one_shot = true
	timer.timeout.connect(end_flash)
	hide()


# show the flash
func flash():
	show()
	rotation.z = randf_range(0.0, TAU)
	timer.start()
	
	
# end and cleanup the flash
func end_flash():
	hide()
