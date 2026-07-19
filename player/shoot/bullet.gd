extends AnimatedSprite2D

class_name Bullet
var bullet_impact_effect = preload("uid://dyoxaywm5d7ga")

var speed: float = 400.0
var direction: float
@export var damage: int = 1;

func _ready() -> void:
	var timer := Timer.new()
	timer.one_shot = true
	timer.wait_time = 5.0
	timer.timeout.connect(queue_free)
	add_child(timer)
	timer.start()

func _physics_process(delta: float) -> void:
	# sometimes bulet stays need to give the last facing direction
	move_local_x(direction * speed * delta)


func _on_hitbox_body_entered(body: Node2D) -> void:
	bullet_impact()

func get_bullet_damage() -> int:
	return damage;

func _on_hitbox_area_entered(area: Area2D) -> void:
	print("hitbox area entered")

func bullet_impact() -> void:
	var impact := bullet_impact_effect.instantiate() as BulletImpact
	impact.global_position = global_position
	get_tree().current_scene.add_child(impact)
	queue_free()
