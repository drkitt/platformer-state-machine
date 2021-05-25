# Contains code for horizontal movement that's shared by the grounded and 
# aerial states. "Prefer composition over inheritance," y'know?

extends Reference
class_name PlayerHorizontalMovement

# Constants
# If the player's horizontal input is less than this proportion of the maximum 
	# input in either direction, the player comes to a stop
const DEADZONE: float = 0.2
# Member variables
# How quickly the player gains speed while holding a directional button, 
	# measured in pixels per second per second
var acceleration: float
# The limit to how fast the player can go, measured in pixels per second
var top_speed: float
# How quickly the player loses speed when not holding a directional button, 
	# measured in pixels per second per second
var deceleration: float


# Constructor :) Basically just exists to enforce that calc_physics_properties
	# is called at least once before any movement happens
# Parameters:
	# top_speed: Maximum pixels per frame traversed on the ground
	# time_to_top_speed: How many frames it takes to accelerate to top speed
	# time_to_stop: How many frames it takes to stop moving after releasing a 
		# directional button
func _init(top_speed: float, time_to_top_speed: float, time_to_stop: float):
	calc_physics_properties(top_speed, time_to_top_speed, time_to_stop)


# Calculates an object's speed based on the player's current input
# Parameters:
	# current_speed: The current horizontal speed (in pixels per second) of
		# whatever object is calling this method
	# delta: The game's time step. Useful for defining acceleration in terms of
		# pixels per second per second.
# Returns: What the speed will be after delta seconds passes
func move(current_speed: float, delta: float) -> float:
	# Local variables
	# The value to return
	var new_speed: float
	# A number in [-1, +1] representing the direction the player is inputting
	var walk = Input.get_action_strength("ui_right") \
			- Input.get_action_strength("ui_left")

	# Handle movement along the direction of input	
	if abs(walk) > DEADZONE:
		# Look at the player gooooooo!!!!!
		new_speed = current_speed + acceleration * walk * delta
	# Handle friction
	else:
		new_speed = move_toward(current_speed, 0, deceleration * delta)
		
	# Give the player an extra boost if the input direction is different 
		# from the movement direction. Used to facilitate sharp turns
	if sign(walk) != sign(current_speed) and sign(walk) != 0:
		# (basically, apply friction until the movement aligns with the input)
		new_speed += deceleration * walk * delta
		
	# Clamp to the maximum speed
	new_speed = clamp(new_speed, -top_speed, top_speed)
	
	return new_speed
	
# Derives the properties used for physics calculations, using a few properties
	# that are easy(er) for a human to configure.
	# This is all done in a single method because some of these properties
	# depend on each other, so enforcing that they must all be updated at once
	# avoids a bunch of wacky edge cases.
# Parameters:
	# top_speed: Maximum pixels per frame traversed on the ground
	# time_to_top_speed: How many frames it takes to accelerate to top speed
	# time_to_stop: How many frames it takes to stop moving after releasing a 
		# directional button
func calc_physics_properties(top_speed: float, time_to_top_speed: float, 
		time_to_stop: float):
	# Preconditions:
	# The speed is non-negative
	assert(top_speed >= 0)
	# The time values are positive
		# (can't have things happening instantly or in the past)
	assert(time_to_top_speed > 0)
	assert(time_to_stop > 0)
	
	# This derivation's really hard. You need to take MATH 2150 three times to 
		# get it
	self.top_speed = top_speed
	
	# ???? I have no idea what's going on
	self.acceleration = top_speed / time_to_top_speed
	
	# Yeah doing three pages of calculus was fun but real gamers do a tiny bit 
		# of dimensional analysis and then spend more time thinking of snarky 
		# comments
	self.deceleration = top_speed / time_to_stop

	# Postconditions:
	# The derived properties are all non-negative
	assert(self.top_speed >= 0)
	assert(self.acceleration >= 0)
	assert(self.deceleration >= 0)
