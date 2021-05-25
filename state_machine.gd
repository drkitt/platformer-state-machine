# Allows another node containing this one to implement the state pattern

extends Node
class_name StateMachine


# Instance variables
# The machine's start state
export(NodePath) var start_state
# The machine's current state
var current_state: State
# Tells what state to transition to when a state returns a string
var states: Dictionary
# The name of the current state (for debugging purposes)
var current_state_name: String


# Initializes the state machine
func _ready() -> void:
	# Preconditions:
	# There's a start state
	assert(start_state != null)

	# Initialize everything
	self.current_state = get_node(start_state)
	current_state.enter(self)
	current_state_name = current_state.name

	# Invariants:
	# There is a current state
	assert (current_state != null)


# Called every physics timestep. Updates the current state and transitions if 
# necessary.
# Parameters:
#	- delta: GameTime gameTime :)
func _physics_process(delta: float) -> void:
	# Preconditions:
	# The container exists
	var container = get_parent()
	assert(container != null)

	# Invariants:
	# There is a current state
	assert (current_state != null)

	# If the current state's update returns a non-empty string, then it's
	# trying to transition to another state
	var new_state: String = current_state.update(container, delta)
	if new_state.casecmp_to("") != 0:
		transitionTo(container, new_state)

	# Invariants:
	# There is a current state
	assert (current_state != null)


# Unloads the current state and loads a new one
# Parameters:
#	- new_state_name: Name of the state to transition to
func transitionTo(container: Object, new_state_name: String) -> void:
	# Invariants:
	# There is a current state
	assert (current_state != null)

	# Actually do the transition
	var new_state: State = get_state(new_state_name)
	if not (new_state == null):
		current_state.exit(container)
		current_state = new_state
		current_state.enter(container)
		current_state_name = new_state_name
	else:
		# If the transition is invalid, warn the programmer and stay in the
			# current state
		push_warning(
			"State machine couldn't transition from the state named \"" +
			current_state_name + "\" (no state found with name \"" +
			new_state_name + "\")")

	# Invariants:
	# There is a current state
	assert (current_state != null)


# Gets a state based on name
# Parameters:
#	- state_name: The name of the state to get (i.e. its type in the dictionary)
# Returns: The state corresponding to state_name if it exists (initializing as
#	neccesary), null otherwise
func get_state(state_name: String) -> State:
	# Invariants:
	# There is a current state
	assert (current_state != null)

	# Basically, return the specified state or return null if there's no such 
	# state
	var state = get_node(NodePath(state_name))
	# Postcodition: I agree with the above comment
	assert(state == null or state is State)
	return state
