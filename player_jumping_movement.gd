# So, the PlayerHorizontalMovement class turned out to 
# be super convenient, and I want to do the same for code chared between 
# the rising and falling states.

extends Reference
class_name PlayerJumpingMovement

# Instance (member?) variables
# The (vertical) speed at the start of the jump
var _initial_speed: float = 1
# How much the vertical speed changes every second on the way up
var _rising_gravity: float = 1
# How much the vertical speed changes every second on the way down
var _falling_gravity: float = 1


# Just like PlayerHorizontalMovement, this contructor basically enforces that 
# the calc_physics_properties method is called at least once before the class 
# is seriously used
#
# Parameters:
#	- time_to_apex: How many seconds it takes to reach the highest point of the 
#	jump
#	- jump_height: How many pixels high the player can jump
#	- time_to_ground: How many seconds it takes to fall from the highest point 
#	of the jump back to the ground where the jump started
func _init(time_to_apex: float, jump_height: float, time_to_ground: float) -> void:
	calc_physics_properties(time_to_apex, jump_height, time_to_ground)


# Calculates an object's speed based on the player's current input
#
# Parameters:
#	- current_speed: The current horizontal speed (in pixels per second) of
#	whatever object is calling this method
#	- delta: The game's time step. Useful for defining acceleration in terms of
#	pixels per second per second.
#
# Returns: What the speed will be after delta seconds passes
func move(current_speed: float, delta: float) -> float:
	# Preconditions:
	# Initial speed points up
	assert(_initial_speed <= 0)
	# Gravity points down
	assert(_rising_gravity >= 0)
	assert(_falling_gravity >= 0)
	
	# The value to return
	var new_speed: float = current_speed
	
	# Check the direction the player is currently moving in and apply rising or 
		# falling gravity accordingly
	if current_speed < 0:
		# They're rising
		new_speed += _rising_gravity * delta
	else:
		# Either they're falling or aren't moving
		new_speed += _falling_gravity * delta

	return new_speed

# Derives the properties used for physics calculations, using a few properties
# that are easy(er) for a human to configure.
#
# Parameters:
#	- time_to_apex: How many seconds it takes to reach the highest point of the jump
#	- jump_height: How many pixels high the player can jump
#	- time_to_ground: How many seconds it takes to fall from the highest point 
#	of the jump back to the ground where the jump started
func calc_physics_properties(time_to_apex: float, jump_height: float, time_to_ground: float) -> void:
	# Preconditions:
	# The time to apex is positive
	assert(time_to_apex > 0)
	# The jump height is non-negative (I guess you can set it to 0 to disable
		# jumping entirely)
	assert(jump_height >= 0)
	
	# Calculate dat stuff
	_initial_speed = -2 * jump_height / time_to_apex
	_rising_gravity = -_initial_speed / time_to_apex
	_falling_gravity = 2 * jump_height / pow(time_to_ground, 2)

	# Postconditions:
	# Initial speed is non-positive
	assert(_initial_speed <= 0)
	# Gravity is non-negative
	assert(_rising_gravity >= 0)
	assert(_falling_gravity >= 0)


# Gets the initial jump speed. Used to get the player off the group before the 
	# physics in the move method take over.
func get_initial_jump_speed() -> float:
	return _initial_speed
