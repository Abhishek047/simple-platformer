extends BaseActor
class_name MainPlayer

# jump height
@export var jump_height = 360
#gravity
@export var up_gravity = 900
@export var down_gravity = 1100

# max speed clamps
@export var max_ground_speed = 190
@export var max_air_speed = 200
@export var max_fall_speed = 700

@export var acceleration = 2500
@export var air_turn_acceleration = 3000

#fast turning
@export var air_acceleration = 1200
@export var turn_acceleration = 5000

# high friction to stop ASAP
@export var friction = 3000

# player state
# jump_buffer_timer
var jump_buffer_timer: Timer

var state_machine: StateMachine
var animation_manager: StateAnimationManager


func _ready() -> void:
	# Engine.time_scale = 0.4
	initialise_jump_buffer();
	# set animation manager and state machine
	for child in get_children():
		if(state_machine == null && child is StateMachine):
			state_machine = child
		if(animation_manager == null && child is StateAnimationManager):
			animation_manager = child
	
	state_machine.init(self, animation_manager)

func initialise_jump_buffer() -> void:
	jump_buffer_timer = Timer.new();
	jump_buffer_timer.one_shot = true;
	jump_buffer_timer.wait_time = 0.125;
	jump_buffer_timer.timeout.connect(handle_jump_timeout_complete)
	add_child(jump_buffer_timer);

func handle_jump_timeout_complete() -> void:
	print("Timeout complete")
