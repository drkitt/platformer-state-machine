# This script does the platforming stuff
# I almost forgot to celebrate - this is my first Godot script! Wooooooooooo

extends KinematicBody2D

# Exported variabled
# Maximum pixels per frame traversed on the ground
export(float) var top_speed = 450 setget _set_top_speed
# How many frames it takes to accelerate to top speed
export(float) var time_to_top_speed = 59 setget _set_time_to_top_speed
# How many frames it takes to stop moving after releasing a directional button
export(float) var time_to_stop = 7.45198030926 setget _set_time_to_stop
# How many seconds it takes to reach the highest point of the jump
export(float) var time_to_apex = 1 setget _set_time_to_apex
# How many pixels high the player can jump
export(float) var jump_height = 1 setget _set_jump_height
# How many seconds it takes to fall from the highest point of the jump back to 
#	the ground where the jump started
export(float) var time_to_ground = 1 setget _set_time_to_ground

# How fast she's going and in what direction (in pixels per frame)
var _velocity: Vector2 = Vector2(0, 0) setget set_velocity, get_velocity
# Whether to flip the sprite horizontally
var _h_flip: bool = false setget set_h_flip
# Makes the player go "<-" and "->"
var _horizontal_movement: PlayerHorizontalMovement setget , get_horizontal_movement
# Makes the player go "^" and... uh... how do I represent a down arrow
var _jumping_movement: PlayerJumpingMovement setget , get_jumping_movement
# Executes different code based on the player's state
var _state_machine: StateMachine


# Called when the node gets memory allocated for it
func _init() -> void:
	# Initialize components
	_horizontal_movement = PlayerHorizontalMovement.new(top_speed, time_to_top_speed, time_to_stop)
	_jumping_movement = PlayerJumpingMovement.new(time_to_apex, jump_height, time_to_ground)


# Called every physics frame. 'delta' is the elapsed time since the previous
#	frame.
func _physics_process(delta) -> void:
	_velocity = move_and_slide(_velocity, Vector2.UP)


# Sets whether the sprite is flipped horizontally, and flips the sprite if the
# new value is is different from the old one
func set_h_flip(value: bool) -> void:
	if value != _h_flip:
		_h_flip = value
		# Wow syntax is so cool
		($Sprites as Node2D).scale = Vector2(1 - 2*int(value), 1)


# Setter for the velocity, used in the state nodes
func set_velocity(value: Vector2) -> void:
	_velocity = value
	
# Getter for the velocity, used in the state nodes	
func get_velocity() -> Vector2:
	return _velocity

# Gets the object that's used to handle horizontal movement. 
# Used by states that care about that sorta thing
func get_horizontal_movement() -> PlayerHorizontalMovement:
	return _horizontal_movement

# Gets the object that's used to handle jumping movement. 
# Also used by states that care about that sorta thing	
func get_jumping_movement() -> PlayerJumpingMovement:
	return _jumping_movement

# Updates physics properties given a change in the player's top speed
func _set_top_speed(value: float) -> void:
	_horizontal_movement.calc_physics_properties(value, time_to_top_speed, time_to_stop)
	top_speed = value

# Updates physics properties given a change in the player's time to top speed
func _set_time_to_top_speed(value: float) -> void:
	time_to_top_speed = value
	_horizontal_movement.calc_physics_properties(top_speed, time_to_top_speed, time_to_stop)

# Updates physics properties given a change in the player's time to stop
func _set_time_to_stop(value: float) -> void:
	time_to_stop = value
	_horizontal_movement.calc_physics_properties(top_speed, time_to_top_speed, time_to_stop)	

# Updates physics properties given a change in the player's time to apex
func _set_time_to_apex(value: float) -> void:
	time_to_apex = value
	_jumping_movement.calc_physics_properties(time_to_apex, jump_height, time_to_ground)

# Updates physics properties given a change in the player's jump height
func _set_jump_height(value: float) -> void:
	jump_height = value
	_jumping_movement.calc_physics_properties(time_to_apex, jump_height, time_to_ground)

# Updates physics properties given a change in the player's time to ground
func _set_time_to_ground(value: float) -> void:
	time_to_ground = value
	_jumping_movement.calc_physics_properties(time_to_apex, jump_height, time_to_ground)

