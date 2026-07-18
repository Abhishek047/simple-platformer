extends PlayerState

class_name ShootRunPlayerState
var landed_from_fall: bool = false
var cooldown_timer: Timer
var can_shoot: bool;

func _ready() -> void:
	cooldown_timer = Timer.new();
	cooldown_timer.wait_time = 0.2;
	cooldown_timer.one_shot = true;
	add_child(cooldown_timer)
	can_shoot = true
	cooldown_timer.timeout.connect(_on_cooldown_finished)

func onEnter():
	animation_manager.onPlay('run-shoot');
	landed_from_fall = state_machine.last_state == "fallplayerstate"
	pass

func updatePhysics(delta: float) -> void:
	var direction = player.get_direction()
	var acceleration: float = player.acceleration
	
	if landed_from_fall:
		acceleration = player.acceleration * 0.4;
	
	if can_shoot:
		add_bullet()
	
	if direction != 0 and sign(player.velocity.x) != direction:
		acceleration = player.air_turn_acceleration
	
	if Input.is_action_just_released("shoot"):
		state_machine.change_state('runplayerstate')
	
	if direction == 0:
		state_machine.change_state('idleplayerstate')
		return;
	
	player.velocity.x = move_toward(player.velocity.x, player.max_ground_speed * 0.85 * direction, player.acceleration * delta * abs(direction))
	if abs(player.velocity.x) >= player.max_ground_speed * 0.9:
		landed_from_fall = false

func add_bullet() -> void:
	if(player.get_direction() > 0):
		player.muzzle.position.x = player.base_muzzle_position.x
	else:
		player.muzzle.position.x = -player.base_muzzle_position.x
	var bullet_instance = player.bullet.instantiate() as Node2D;
	bullet_instance.global_position = player.muzzle.global_position
	bullet_instance.direction = player.get_direction()
	get_tree().current_scene.add_child(bullet_instance)
	cooldown_timer.start();
	can_shoot = false

func _on_cooldown_finished() -> void:
		can_shoot = true

func handleInput(input: InputEvent) -> void:
	if input.is_action_pressed("jump"):
		state_machine.change_state('jumpplayerstate')

func onExit():
	pass
