extends Node

class_name StateMachine

@export var inital_state: BaseState;
var current_state: BaseState;

var states: Dictionary = {};
var last_state: String = "";

func _ready() -> void:
	# Get all the states that are assigned as children to this state machine
	for child in get_children():
		if child is BaseState:
			states[child.name.to_lower()] = child;
			child.state_machine = self;

func init(actor: BaseActor, animation_manager: StateAnimationManager) -> void:
	# passing actor that is the spirte to all these components
	# initializing the childrens with actors
	# initializing the childrens with animation manager
	for child in get_children():
		if child is BaseState:
			child.initActor(actor);
			child.animation_manager = animation_manager
	if inital_state:
		change_state(inital_state.name.to_lower());

func _process(delta: float) -> void:
	if(current_state):
		current_state.update(delta)
	pass


func _physics_process(delta: float) -> void:
	if(current_state):
		current_state.updatePhysics(delta)

func _input(event: InputEvent) -> void:
	if(current_state):
		current_state.handleInput(event)

func change_state(new_state: String) -> void:
	var new_state_node = states.get(new_state.to_lower())
	if current_state:
		last_state = current_state.name.to_lower();
	
	print("State Change: [", new_state,"]")
	if(!new_state_node):
		print("State not found: [", new_state,"]")
		print("States available: ", states.keys())
		return;
	
	if(current_state && current_state.name):
		current_state.onExit()
	
	current_state = new_state_node
	current_state.onEnter()
