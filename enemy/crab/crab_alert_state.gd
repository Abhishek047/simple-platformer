extends EnemyState

class_name CrabAlertState
var crab: CrabEnemy
var player
var cooldown_timer: Timer;
var move_delta = 50;
var attack_state = "crabattackstate";
var idle_state = "crabidlestate";

func initActor(main_player: BaseActor):
	crab = main_player as CrabEnemy
	_init_cooldown_timer();

func onEnter():
	player = get_tree().get_nodes_in_group('player')[0] as CharacterBody2D
	animation_manager.onPlay(animation_name)
	crab.can_walk = true
	crab.group_detector.change_active_detector('alert')
	cooldown_timer.wait_time = crab.attack_cooldown if state_machine.last_state == attack_state else 0.3
	cooldown_timer.start()

func onExit(next_state: String):
	if(next_state != attack_state):
		crab.group_detector.change_active_detector('patrol')
		crab.player_in_range = false
	crab.can_walk = false;

func _init_cooldown_timer() -> void:
	cooldown_timer = Timer.new();
	cooldown_timer.wait_time = 1;
	cooldown_timer.one_shot = true;
	cooldown_timer.timeout.connect(handle_next_action)
	add_child(cooldown_timer)

func handle_next_action() -> void:
	#check if player in range and view then attack
	print("attack here")
	if (crab.player_in_range):
		state_machine.change_state(attack_state)
	else:
		state_machine.change_state(idle_state)

func updatePhysics(delta: float) -> void:
	# here make it move to ward the player by still keeping a delta between them
	crab.velocity.x = move_toward(crab.velocity.x, 0, crab.SPEED * delta)
