extends CharacterBody2D

const SPEED = 1500;

@export var patrol_points: Node;
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

enum State { Walk , Idle }
var current_state: State;
var direction: Vector2 = Vector2.LEFT;
var patrol_points_location: Array[Vector2]
var current_pos: int;
var can_walk: bool = false;

func _ready() -> void:
	if patrol_points != null:
		for i in patrol_points.get_children().size():
			var point = patrol_points.get_child(i);
			patrol_points_location.append(point.global_position)
			var dx = point.global_position.x - global_position.x
			if direction == Vector2.RIGHT && dx >= 0:
				current_pos = i
			if direction == Vector2.LEFT && dx <= 0: 
				current_pos = i
	else:
		pass
	current_state = State.Idle
	

func _physics_process(delta: float) -> void:
	add_gravity(delta)
	handle_idle(delta)
	handle_walk(delta)
	
	enemy_animations();
	#print("current state: ", State.keys()[current_state])
	move_and_slide()


func handle_idle(delta: float) -> void:
	if !can_walk:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		current_state = State.Idle

func handle_walk(delta: float) -> void:
	if !can_walk:
		return;
	if abs(position.x - patrol_points_location[current_pos].x) > 0.5:
		velocity.x = direction.x * SPEED * delta
		current_state = State.Walk
	else: 
		current_pos += 1;
		current_pos %= patrol_points_location.size()

		if patrol_points_location[current_pos].x > position.x:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.LEFT
		can_walk = false;
		timer.start();
	animated_sprite_2d.flip_h = direction.x > 0

func enemy_animations() -> void: 
	if current_state == State.Idle && !can_walk:
		animated_sprite_2d.play("idle")
	elif current_state == State.Walk && can_walk:
		animated_sprite_2d.play("walk")
	else: 
		animated_sprite_2d.play("idle")

func add_gravity(delta: float) -> void:
	if !is_on_floor():
		velocity += get_gravity() * delta

func start_walk() -> void:
	can_walk = true

func _on_timer_timeout() -> void:
	start_walk()
