extends BaseActor
class_name CrabEnemy

const SPEED = 1500;

@export var patrol_points: Node;
@export var attack_cooldown: float = 0.8;
@onready var health_component: HealthComponent = $HealthComponent
@export var projectile_genrator: Marker2D
@export var group_detector: GroupDetector
@export var detectors: Node2D

var death_effect = preload("uid://i6tglufa65cv");
var projectile = preload("uid://cinrfdjdmwfit")


enum State { Walk , Idle, Attack }
var current_state: State;
var patrol_points_location: Array[Vector2]
var current_pos: int;
var can_walk: bool = false;
var state_machine: EnemyStateMachine
var animation_manager: StateAnimationManager
var base_projectile_position: Vector2;
var player_in_range: bool = false;

func _ready() -> void:
	base_projectile_position = projectile_genrator.position;
	for child in get_children():
		if(state_machine == null && child is EnemyStateMachine):
			state_machine = child
		if(animation_manager == null && child is StateAnimationManager):
			animation_manager = child
	state_machine.init(self, animation_manager)
	init_patrol_points()
	init_player_detection()
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


func init_player_detection() -> void:
	group_detector.custom_body_entered.connect(_on_player_detected)
	group_detector.custom_body_exited.connect(_on_player_lost)
	pass

func start_walk() -> void:
	can_walk = true
	state_machine.change_state("crabwalkstate")

func _on_died():
	var effect := death_effect.instantiate() as DeathEffect
	effect.global_position = global_position
	get_tree().current_scene.add_child(effect)
	queue_free()

func _on_player_lost(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		pass

func _on_player_detected(body: Node2D) -> void:
	if body.is_in_group("player") && player_in_range == false:
		player_in_range = true
		state_machine.call_deferred("change_state", "crabalertstate")

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("get_bullet_damage"):
		health_component.hit(area.get_parent().get_bullet_damage())

func flip_detectors() -> void:
	detectors.scale.x = -1 if state_machine.direction.x > 0 else 1

func get_direction() -> float:
	return state_machine.direction.x;
