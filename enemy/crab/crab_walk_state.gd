extends EnemyState

class_name CrabWalkState
var crab: CrabEnemy

func initActor(main_player: BaseActor):
	crab = main_player as CrabEnemy

func onEnter():
	animation_manager.onPlay(animation_name)
	pass

func updatePhysics(delta: float) -> void:
	if !crab.can_walk:
		return;
	if abs(crab.position.x - crab.patrol_points_location[crab.current_pos].x) > 0.5:
		crab.velocity.x = state_machine.direction.x * crab.SPEED * delta
	else: 
		crab.current_pos += 1;
		crab.current_pos %= crab.patrol_points_location.size()
		
		if crab.patrol_points_location[crab.current_pos].x > crab.position.x:
			state_machine.direction = Vector2.RIGHT
		else:
			state_machine.direction = Vector2.LEFT
		crab.can_walk = false;
		state_machine.change_state("crabidlestate")
		crab.patrol_timer.start()
