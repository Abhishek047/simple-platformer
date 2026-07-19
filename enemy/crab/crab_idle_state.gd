extends EnemyState

class_name CrabIdleState
var crab: CrabEnemy

func initActor(main_player: BaseActor):
	crab = main_player as CrabEnemy

func onEnter():
	animation_manager.onPlay(animation_name)
	pass

func updatePhysics(delta: float) -> void:
	crab.velocity.x = move_toward(crab.velocity.x, 0, crab.SPEED * delta)
