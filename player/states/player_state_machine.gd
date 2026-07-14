extends StateMachine
class_name PlayerStateMachine

const STATES_NAMES := {
	"FALL": "fallplayerstate",
	"RUN": "runplayerstate",
	"IDLE": "idleplayerstate",
	"JUMP": "jumpplayerstate"
}

var player: MainPlayer
var player_animation_manager: StateAnimationManager;

func _ready() -> void:
	super._ready()

func init(actor: BaseActor, animation_manager: StateAnimationManager):
	super.init(actor, animation_manager)
	player = actor as MainPlayer
	# link jump buffer timer
	player_animation_manager = animation_manager

func _physics_process(delta):
	var direction = get_direction()
	# Global transitions
	if not player.is_on_floor():
		if player.velocity.y <= 0:
			player.velocity.y += player.up_gravity * delta
		else:
			player.velocity.y += player.down_gravity * delta
			player.velocity.y = clamp(player.velocity.y, -INF, player.max_fall_speed)
		if current_state.name.to_lower() != STATES_NAMES.FALL && player.velocity.y >= 0:
			change_state(STATES_NAMES.FALL)
	super._physics_process(delta)
	
	if direction != 0:
		player_animation_manager.flip_animation_horizontal(false if direction > 0 else true)
	
	player.move_and_slide()

func change_state(new_state: String) -> void:
	super.change_state(new_state);
	if(player):
		player.move_and_slide()

func get_direction() -> float:
	var direction: float = Input.get_axis("move_left", "move_right")
	return direction;

func _input(event):
	# handle dead player here to return
	if(event.is_action_pressed("jump")):
		player.jump_buffer_timer.start();
	super._input(event);
