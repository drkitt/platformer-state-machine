# This state is for when the player is in the air

extends State
class_name PlayerAerialState

# Called on transition to this state
# Parameters:
	# - container: Object that contains this state's state machine
func enter(container: Object) -> void:
	# Preconditions: 
	# The player has jumping movement object and a public velocity
	assert(container.has_method("set_velocity"))
	assert(container.has_method("get_velocity"))
	assert(container.has_method("get_jumping_movement"))
	
	# Play the jump animation
	var anim := container.get_node("AnimationPlayer") as AnimationPlayer
	if anim != null:
		anim.play("Jump")
	
	# Give initial speed
	var velocity: Vector2 = container.get_velocity()
	velocity.y += container.get_jumping_movement().get_initial_jump_speed()
	container.set_velocity(velocity)


# Basically a _process method with a different name. Called whenever the state 
# machine updates.
#
# Parameters:
#	- container: Object that contains this state's state machine
#	- delta: The game's time step
# 
# Returns: The name of the state to transition to, or an empty string to stay
#	in the current state
func update(container: Object, delta: float) -> String:
	# Invariants:
	# The container has a horizontal movement object and a public velocity
	assert(container.has_method("get_horizontal_movement"))
	assert(container.has_method("set_velocity"))
	assert(container.has_method("get_velocity"))
	
	# The next state to transition to
	var toReturn = ""
	
	# Handle movement
	var new_velocity = Vector2(
			container.get_horizontal_movement().move(container.get_velocity().x, delta),
			container.get_jumping_movement().move(container.get_velocity().y, delta))
	# I can't believe I forgot about short hopping!
	if Input.is_action_just_released("ui_accept") and new_velocity.y < 0:
		new_velocity.y /= 3
	container.set_velocity(new_velocity)
		
	# Play the falling animation when applicable
	var anim := container.get_node("AnimationPlayer") as AnimationPlayer
	if anim != null and new_velocity.y >= 0:
		anim.play("Fall")
		
	# Flip the sprite
	var h_strength = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		# Make the sprite face left or right based on the movement direction
		if container.has_method("set_h_flip"): 
			container.set_h_flip(h_strength < 0)
		
	# Transition to the grounded state when the container hits the ground
	if container.has_method("is_on_floor"):
		# (I'm not brave enough for lazy boolean evaluation)
		if container.is_on_floor(): 
			toReturn = "default"
	
	# Invariants:
	# The container has a horizontal movement object and a public velocity
	assert(container.has_method("get_horizontal_movement"))
	assert(container.has_method("set_velocity"))
	assert(container.has_method("get_velocity"))
	
	return toReturn


# Called on transition from this state
# Parameters:
#	- container: Object that contains this state's state machine
func exit(_container: Object) -> void:
	pass

