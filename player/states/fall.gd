extends PlayerState

class_name FallPlayerState

func onEnter():
	animation_manager.onPlay(animation_name)
	if should_start_coyote():
		player.coyote_timer.start()
	pass

func updatePhysics(delta: float) -> void:
	var direction = get_direction()
	player.velocity.x = move_toward(player.velocity.x, player.max_air_speed * direction, player.acceleration * delta * abs(direction))
	if player.is_on_floor():
		if player.jump_buffer_timer.time_left > 0.0:
			state_machine.change_state('jumpplayerstate');
			return
		if direction != 0:
			state_machine.change_state('runplayerstate')
		else:
			state_machine.change_state('idleplayerstate')

func handleInput(_input: InputEvent) -> void:
	if(_input.is_action_pressed("jump")):
		if should_start_coyote() && player.coyote_timer.time_left > 0.0:
			player.coyote_timer.stop();
			state_machine.change_state('jumpplayerstate');

func onExit():
	player.jump_buffer_timer.stop();
	player.coyote_timer.stop();

func should_start_coyote() -> bool:
	return state_machine.last_state == "idleplayerstate" || state_machine.last_state == "runplayerstate"

func get_direction() -> float:
	var direction: float = Input.get_axis("move_left", "move_right")
	return direction;
