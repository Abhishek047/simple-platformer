extends PlayerState

class_name RunPlayerState

func onEnter():
	animation_manager.onPlay(animation_name)
	pass

func updatePhysics(delta: float) -> void:
	var direction = get_direction()
	var acceleration = player.acceleration;
	if direction != 0 and sign(player.velocity.x) != direction:
		acceleration = player.air_turn_acceleration

	if direction == 0:
		state_machine.change_state('idleplayerstate')
		return;
	
	player.velocity.x = move_toward(player.velocity.x, player.max_ground_speed * direction, player.acceleration * delta * abs(direction))

func handleInput(input: InputEvent) -> void:
	if input.is_action_pressed("jump"):
		state_machine.change_state('jumpplayerstate')


func get_direction() -> float:
	var direction: float = Input.get_axis("move_left", "move_right")
	return direction;
