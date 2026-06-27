extends BaseActor
class_name MainPlayer

@export var jump_height: int = 350
@export var up_gravity: int = 1500
@export var down_gravity: int = 1000

var state_machine: StateMachine
var animation_manager: StateAnimationManager

func _ready() -> void:
	# set animation manager and state machine
	for child in get_children():
		if(state_machine == null && child is StateMachine):
			state_machine = child
		if(animation_manager == null && child is StateAnimationManager):
			animation_manager = child
	
	state_machine.init(self, animation_manager)
