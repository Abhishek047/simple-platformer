extends PlayerState

class_name RunPlayerState
var landed_from_fall: bool = false
func onEnter():
	animation_manager.onPlay(animation_name)
	if player.player_is_shooting():
		state_machine.change_state("shootrunplayerstate")
	landed_from_fall = state_machine.last_state == "fallplayerstate"
	pass

func updatePhysics(delta: float) -> void:
	var direction = player.get_direction()
	var acceleration: float = player.acceleration
	if landed_from_fall:
		acceleration = player.acceleration * 0.4;
	
	if direction != 0 and sign(player.velocity.x) != direction:
		acceleration = player.air_turn_acceleration

	if direction == 0:
		state_machine.change_state('idleplayerstate')
		return;
	
	player.velocity.x = move_toward(player.velocity.x, player.max_ground_speed * direction, player.acceleration * delta * abs(direction))
	if abs(player.velocity.x) >= player.max_ground_speed * 0.9:
		landed_from_fall = false

func handleInput(input: InputEvent) -> void:
	if input.is_action_pressed("jump"):
		state_machine.change_state('jumpplayerstate')
	if input.is_action_pressed("shoot"):
		state_machine.change_state("shootrunplayerstate")
