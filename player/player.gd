extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: int = 1000
@export var max_horizontal_speed = 300
@export var jump_velocity: int = -300
@export var max_jump_horizontal: int = 300
@export var jump_horizontal_speed: int = 1000
@export var friction: int = 1800


enum State { Idle, Run, Jump }

var current_state: State;

func _ready() -> void:
	current_state = State.Idle;

func _physics_process(delta: float) -> void:
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	player_animations()
	
	move_and_slide()

func player_jump(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
		current_state = State.Jump
	
	if !is_on_floor() && current_state == State.Jump:
		var direction = get_direction()
		velocity.x += direction * jump_horizontal_speed * delta
		velocity.x = clamp(velocity.x, -max_jump_horizontal, max_jump_horizontal)

func player_run(delta: float) -> void:
	if !is_on_floor():
		return
	var direction = get_direction()
	
	if direction:
		velocity.x += speed * direction * delta
		velocity.x = clamp(velocity.x, -max_horizontal_speed, max_horizontal_speed)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	
	if direction != 0:
		current_state = State.Run
		animated_sprite_2d.flip_h = false if direction > 0 else true

func player_falling(delta: float) -> void:
	if !is_on_floor():
		velocity += get_gravity() * delta

func player_idle(_d: float) -> void:
	if is_on_floor():
		current_state = State.Idle

func player_animations() -> void: 
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	elif current_state  == State.Run:
		animated_sprite_2d.play("run")
	elif current_state == State.Jump:
		animated_sprite_2d.play("jump")
	else:
		animated_sprite_2d.play("default")

func get_direction() -> float:
	var direction: float = Input.get_axis("move_left", "move_right")
	return direction;
