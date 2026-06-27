extends PlayerState

class_name RunPlayerState

func onEnter():
	animation_manager.onPlay(animation_name)
	pass

func updatePhysics(delta: float) -> void:
	var direction = get_direction()
	
	if direction == 0:
		state_machine.change_state('idleplayerstate')
		return;
	
	player.velocity.x = move_toward(player.velocity.x, player.max_horizontal_speed * direction, player.acceleration * delta * abs(direction))

	if direction != 0:
		animation_manager.flip_animation_horizontal(false if direction > 0 else true)
	
	player.move_and_slide()

func handleInput(input: InputEvent) -> void:
	if input.is_action_pressed("jump"):
		state_machine.change_state('jumpplayerstate')


func get_direction() -> float:
	var direction: float = Input.get_axis("move_left", "move_right")
	return direction;
