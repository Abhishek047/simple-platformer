extends BaseActor
class_name CrabEnemy

const SPEED = 1500;

@export var patrol_points: Node;
@onready var health_component: HealthComponent = $HealthComponent
var death_effect = preload("uid://i6tglufa65cv");

var patrol_timer_value: int = 2
enum State { Walk , Idle }
var current_state: State;
var patrol_points_location: Array[Vector2]
var current_pos: int;
var can_walk: bool = false;
var patrol_timer: Timer;
var state_machine: EnemyStateMachine
var animation_manager: StateAnimationManager

func _ready() -> void:
	for child in get_children():
		if(state_machine == null && child is EnemyStateMachine):
			state_machine = child
		if(animation_manager == null && child is StateAnimationManager):
			animation_manager = child
	state_machine.init(self, animation_manager)
	init_patrol_points()
	init_patrol_timer()
	state_machine.change_state("crabidlestate")
	health_component.died.connect(_on_died)
	

func init_patrol_points() -> void:
	assert(patrol_points != null, "Enemy is missing PatrolPoints node.")
	
	for i in patrol_points.get_children().size():
		var point = patrol_points.get_child(i);
		patrol_points_location.append(point.global_position)
		var dx = point.global_position.x - global_position.x
		if state_machine.direction == Vector2.RIGHT && dx >= 0:
			current_pos = i
		if state_machine.direction == Vector2.LEFT && dx <= 0: 
			current_pos = i

func init_patrol_timer() -> void:
	patrol_timer = Timer.new();
	patrol_timer.one_shot = true;
	patrol_timer.wait_time = patrol_timer_value;
	patrol_timer.timeout.connect(_on_timer_timeout);
	add_child(patrol_timer);
	patrol_timer.start()

func start_walk() -> void:
	can_walk = true
	state_machine.change_state("crabwalkstate")

func _on_timer_timeout() -> void:
	start_walk()

func _on_died():
	var effect := death_effect.instantiate() as DeathEffect
	effect.global_position = global_position
	get_tree().current_scene.add_child(effect)
	queue_free()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("get_bullet_damage"):
		health_component.hit(area.get_parent().get_bullet_damage())
