extends PlayerState

class_name JumpPlayerState

func onEnter():
	player.velocity.y -= player.jump_height
	animation_manager.onPlay(animation_name)
	
	if state_machine.last_state == "fallplayerstate" && !Input.is_action_pressed("jump"):
		# letting this state run and then check if it not press in next frame
		await get_tree().physics_frame;
		print("lowring-speed here")
		player.velocity.y *= 0.56
		state_machine.change_state("fallplayerstate");
	pass

func updatePhysics(delta: float) -> void:
	# if player has a velocity after being in jump state and we release jump button it should reduce the velocity and bring the player back
	if Input.is_action_just_released("jump") && player.velocity.y < 0: 
		print("lowring-speed here-----")
		player.velocity.y *= 0.56
	var direction = get_direction()
	var acceleration = player.air_acceleration
	# Turning around in the air
	if direction != 0 and sign(player.velocity.x) != direction:
		acceleration = player.air_turn_acceleration
	
	player.velocity.x = move_toward(player.velocity.x, player.max_air_speed * direction, acceleration * delta * abs(direction))
	
	if player.is_on_floor():
		if direction != 0:
			state_machine.change_state('runplayerstate')
		else:
			state_machine.change_state('idleplayerstate')


func get_direction() -> float:
	var direction: float = Input.get_axis("move_left", "move_right")
	return direction;
