extends PlayerState

class_name FallPlayerState

func onEnter():
	animation_manager.onPlay(animation_name)
	pass

func updatePhysics(delta: float) -> void:
	var direction = get_direction()
	player.velocity.x = move_toward(player.velocity.x, player.max_air_speed * direction, player.acceleration * delta * abs(direction))
	if player.is_on_floor():
		if direction != 0:
			state_machine.change_state('runplayerstate')
		else:
			state_machine.change_state('idleplayerstate')

func get_direction() -> float:
	var direction: float = Input.get_axis("move_left", "move_right")
	return direction;
