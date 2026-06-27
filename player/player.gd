extends BaseActor
class_name MainPlayer

@export var jump_height: int = 350
@export var up_gravity: int = 800
@export var max_ground_speed = 270
@export var max_air_speed = 270
@export var down_gravity: int = 1500
@export var acceleration: int = 1200
@export var air_acceleration: int = 400
@export var friction: int = 2000
@export var air_friction: int = 700

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
