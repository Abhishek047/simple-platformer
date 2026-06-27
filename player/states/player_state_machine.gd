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

func init(actor: BaseActor, animation_manager: StateAnimationManager):
	super.init(actor, animation_manager)
	player = actor as MainPlayer
	player_animation_manager = animation_manager

func _physics_process(delta):
	var direction = get_direction()
	# Global transitions
	if not player.is_on_floor():
		if player.velocity.y <= 0:
			player.velocity.y += player.up_gravity * delta
		else:
			player.velocity.y += player.down_gravity * delta
		if current_state.name.to_lower() != STATES_NAMES.FALL && player.velocity.y >= 0:
			change_state(STATES_NAMES.FALL)
	super._physics_process(delta)
	
	if direction != 0:
		player_animation_manager.flip_animation_horizontal(false if direction > 0 else true)
	

func get_direction() -> float:
	var direction: float = Input.get_axis("move_left", "move_right")
	return direction;

func _input(event):
	# handle dead player here to return
	super._input(event);
