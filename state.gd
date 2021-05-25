# Defines a base class for any state of a state machine

extends Node
class_name State


# Called on transition to this state
# Parameters:
#	- container: Object that contains this state's state machine
func _enter(_container: Object) -> void:
	pass


# Can process input, start a transition, and even change the container's state.
# Wow! That's up to the derived classes, though.
#
# Parameters:
#	- container: Object that contains this state's state machine
#	- delta: The game's time step
# Returns: The name of the state to transition to, or an empty string to stay
#	in the current state
func _update(_container: Object, _delta: float) -> String:
	return ""


# Called on transition from this state
# Parameters:
#	- container: Object that contains this state's state machine
func _exit(_container: Object) -> void:
	pass
