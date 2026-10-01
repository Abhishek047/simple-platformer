extends StateMachine
class_name EnemyStateMachine

var enemy: BaseActor
var state_animation_manager: StateAnimationManager;

func _ready() -> void:
	super._ready()

func init(actor: BaseActor, animation_manager: StateAnimationManager):
	super.init(actor, animation_manager)
	set_direction(Vector2.LEFT)
	enemy = actor as BaseActor
	# link jump buffer timer
	state_animation_manager = animation_manager

func _physics_process(delta):
	
	# Global transitions
	super._physics_process(delta)
	add_gravity(delta)
	if direction != Vector2.ZERO:
		state_animation_manager.flip_animation_horizontal(true if direction.x > 0 else false)
	enemy.move_and_slide()

func change_state(new_state: String) -> void:
	super.change_state(new_state);
	print("Last State [", current_state.name ,"] State Change: [", new_state,"]")
	if(enemy):
		enemy.move_and_slide()

func add_gravity(delta: float) -> void:
	if !enemy.is_on_floor():
		enemy.velocity += enemy.get_gravity() * delta

func set_direction(d: Vector2) -> void:
	direction = d;

func on_direction_changed(_new_direction: Vector2) -> void:
	enemy.flip_detectors()
	pass

func _input(event):
	super._input(event);
