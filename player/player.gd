extends BaseActor
class_name MainPlayer

var bullet = preload("uid://bcsot1titguwh")
@onready var muzzle: Marker2D = $Marker2D

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

@export var coyote_timer_value = 0.125
@export var jump_buffer_time_value = 0.1

# high friction to stop ASAP
@export var friction = 3000

# player state

# jump_buffer_timer
var jump_buffer_timer: Timer
var coyote_timer: Timer;

var state_machine: StateMachine
var animation_manager: StateAnimationManager
var base_muzzle_position: Vector2;

func _ready() -> void:
	base_muzzle_position = muzzle.position;
	# Engine.time_scale = 0.4
	init_specs();
	# set animation manager and state machine
	for child in get_children():
		if(state_machine == null && child is StateMachine):
			state_machine = child
		if(animation_manager == null && child is StateAnimationManager):
			animation_manager = child
	
	state_machine.init(self, animation_manager)

func init_specs() -> void: 
	initialise_coyote_timer();
	initialise_jump_buffer();

func initialise_coyote_timer() -> void:
	coyote_timer = Timer.new();
	coyote_timer.one_shot = true;
	coyote_timer.wait_time = coyote_timer_value;
	add_child(coyote_timer);

func initialise_jump_buffer() -> void:
	jump_buffer_timer = Timer.new();
	jump_buffer_timer.one_shot = true;
	jump_buffer_timer.wait_time = jump_buffer_time_value;
	add_child(jump_buffer_timer);

func player_is_shooting() -> bool:
	return Input.is_action_pressed("shoot")

func get_direction() -> float:
	var direction: float = Input.get_axis("move_left", "move_right")
	return direction;
