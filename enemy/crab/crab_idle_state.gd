extends EnemyState

class_name CrabIdleState
var crab: CrabEnemy
var patrol_timer: Timer;
var patrol_timer_value: int = 2

func initActor(main_player: BaseActor):
	crab = main_player as CrabEnemy
	init_patrol_timer()

func init_patrol_timer() -> void:
	patrol_timer = Timer.new();
	patrol_timer.one_shot = true;
	patrol_timer.wait_time = patrol_timer_value;
	patrol_timer.timeout.connect(_on_timer_timeout);
	add_child(patrol_timer);
	patrol_timer.start()

func _on_timer_timeout() -> void:
	crab.start_walk()


func onEnter():
	animation_manager.onPlay(animation_name)
	crab.can_walk = false
	patrol_timer.start()

func onExit(_next_state: String):
	patrol_timer.stop()

func updatePhysics(delta: float) -> void:
	crab.velocity.x = move_toward(crab.velocity.x, 0, crab.SPEED * delta)
