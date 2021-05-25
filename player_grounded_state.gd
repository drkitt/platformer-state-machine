# This state is how the player starts. They're (probably) on the ground and 
# able to move and stuff

extends State
class_name PlayerGroundedState

# Constants
# When the absolute value of the horizontal speed is less than this, play the 
# idle animation
const IDLE_CUTOFF: float = 10.0

# Called on transition to this state
# Parameters:
#	- container: Object that contains this state's state machine
func enter(_container: Object):
	pass

# Basically a _process method with a different name
# Parameters:
#	 - container: Object that contains this state's state machine
#	 delta_ The game's time step
# Returns: The name of the state to transition to, or an empty string to stay
#	 in the current state
func update(container: Object, delta: float) -> String:
	# Invariants:
	# The container has a horizontal movement object and a public velocity
	assert(container.has_method("get_horizontal_movement"))
	assert(container.has_method("set_velocity"))
	assert(container.has_method("get_velocity"))

	# Local variables
	# The player's velocity after this method updates it
	var new_velocity: Vector2 = container.get_velocity()
	# The container's animation player
	var anim := container.get_node("AnimationPlayer") as AnimationPlayer
	
	# Handle horizontal movement
	new_velocity.x = container.get_horizontal_movement().move(new_velocity.x, delta)
	
	# Finally, assign the player's velocity
	container.set_velocity(new_velocity)
	
	# Handle animation
	var h_strength = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	# The != operator acts as a xor here
	if Input.is_action_pressed("ui_left") != Input.is_action_pressed("ui_right"):
		# Make the sprite face left or right based on the movement direction
		if container.has_method("set_h_flip"): 
			container.set_h_flip(h_strength < 0)
		# Also, run!
		if anim != null:
			anim.play("Run", -1, 1.5)
	elif h_strength == 0:
		if anim != null:
			anim.play("Idle")

	# Detect a jump input and transition to a jumping state! Exciting, right?
	if Input.is_action_just_pressed("ui_accept"):
		return "air"
	# Out-of-scope todo: When using this to implement a level with platforms  
	# that the player can fall off of, there should also be a transition to a 
	# falling state that's triggered by container.is_on_floor() being false.

	# Invariants:
	# The container has a horizontal movement object and a public velocity
	assert(container.has_method("get_horizontal_movement"))
	assert(container.has_method("set_velocity"))
	assert(container.has_method("get_velocity"))

	return ""

# Called on transition from this state
# Parameters:
#	- container: Object that contains this state's state machine
func exit(_container: Object) -> void:
	pass
