extends EnemyState

class_name CrabAttackState
var crab: CrabEnemy
var player
var is_attacking: bool = false;
#var cooldown_timer: Timer;

func initActor(main_player: BaseActor):
	crab = main_player as CrabEnemy
	#_init_cooldown_timer();

func onEnter():
	player = get_tree().get_nodes_in_group('player')[0] as CharacterBody2D
	animation_manager.onPlay(animation_name)
	animation_manager.animation_sprite_2d.frame_changed.connect(_frame_changed)
	animation_manager.animation_sprite_2d.animation_finished.connect(_on_finish_attack)
	crab.can_walk = false
	pass

func onExit(_next_state: String):
	animation_manager.animation_sprite_2d.frame_changed.disconnect(_frame_changed)
	animation_manager.animation_sprite_2d.animation_finished.disconnect(_on_finish_attack)
	player = null;

func _init_cooldown_timer() -> void:
	#cooldown_timer = Timer.new();
	#cooldown_timer.wait_time = crab.attack_cooldown || 1.2;
	#cooldown_timer.one_shot = true;
	#add_child(cooldown_timer)
	pass

func _on_finish_attack() -> void:
	state_machine.change_state("crabalertstate")
	pass;

func _initate_attack() -> void:
	# this will handle how what attack to do
	_shoot_fireball()
	pass


func _shoot_fireball() -> void:
	if(player):
		if(crab.get_direction() < 0):
			crab.projectile_genrator.position.x = crab.base_projectile_position.x
		else:
			crab.projectile_genrator.position.x = -crab.base_projectile_position.x
		var fireball_instance = crab.projectile.instantiate() as Node2D;
		fireball_instance.global_position = crab.global_position
		fireball_instance.global_position.y = crab.base_projectile_position.y
		fireball_instance.direction = crab.get_direction()
		get_tree().current_scene.add_child(fireball_instance)
		#cooldown_timer.start();

func _frame_changed() -> void:
	if(animation_manager.animation_sprite_2d.frame == 2):
		_initate_attack()

func updatePhysics(delta: float) -> void:
	crab.velocity.x = move_toward(crab.velocity.x, 0, crab.SPEED * delta)
