extends Node2D

class_name FireballEnemy
var impact_effect = preload("uid://cr0ynj8h1vw8h")
@export var animation_fireball: AnimationPlayer
@export var fireball_sprite: Sprite2D
@export var hitbox: Area2D
@export var fireball_position: Marker2D

var speed: float = 400.0
var direction: float
@export var damage: int = 1;


func _ready() -> void:
	animation_fireball.animation_finished.connect(_on_animation_finished)
	animation_fireball.play("spawn")
	fireball_sprite.flip_h = direction < 0
	hitbox.position.x = fireball_position.position.x * direction
	_init_clear_time()

func _init_clear_time() -> void:
	var timer := Timer.new()
	timer.one_shot = true
	timer.wait_time = 5.0
	timer.timeout.connect(queue_free)
	add_child(timer)
	timer.start()


func _on_animation_finished(anim_name: StringName) -> void:
	print(anim_name);
	if anim_name == "spawn":
		animation_fireball.play("loop")

func _process(delta: float) -> void:
	# sometimes bulet stays need to give the last facing direction
	move_local_x(direction * speed * delta)

func get_bullet_damage() -> int:
	return damage;


func _on_hitbox_body_entered(body: Node2D) -> void:
	print("impact ", body.name)
	fireball_impact()
	pass


func fireball_impact() -> void:
	var impact := impact_effect.instantiate() as FireballImpact
	var offset := fireball_position.position.x * direction;
	impact.global_position = Vector2(global_position.x + offset, global_position.y)
	get_tree().current_scene.add_child(impact)
	queue_free()
