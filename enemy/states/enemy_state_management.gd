extends StateMachine
class_name EnemyStateMachine

var enemy: BaseActor
var animation_manager: StateAnimationManager;

func _ready() -> void:
	super._ready()

func init(actor: BaseActor, animation_manager: StateAnimationManager):
	super.init(actor, animation_manager)
	enemy = actor as BaseActor
	# link jump buffer timer
	animation_manager = animation_manager

func _physics_process(delta):
	var direction = get_direction()
	# Global transitions
	super._physics_process(delta)
	
	if direction != 0:
		animation_manager.flip_animation_horizontal(false if direction > 0 else true)
	
	enemy.move_and_slide()

func change_state(new_state: String) -> void:
	super.change_state(new_state);
	if(enemy):
		enemy.move_and_slide()

func get_direction() -> float:
	var direction: float = Input.get_axis("move_left", "move_right")
	return direction;

func _input(event):
	super._input(event);
