extends PlayerState

class_name IdlePlayerState

func onEnter():
	animation_manager.onPlay(animation_name)
	pass

func updatePhysics(delta: float) -> void:
	if(player.velocity.x != 0.0):
		#print("stopping player...")
		var friction = player.friction;
		if not player.is_on_floor():
			friction = player.air_friction
		player.velocity.x = move_toward(player.velocity.x, 0.0, friction * delta)
		player.move_and_slide()

func handleInput(input: InputEvent) -> void:
	if input.is_action_pressed("move_left") or input.is_action_pressed("move_right"):
		state_machine.change_state('runplayerstate')
	elif input.is_action_pressed("jump"):
		state_machine.change_state('jumpplayerstate')
	pass
