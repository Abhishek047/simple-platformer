extends AnimatedSprite2D

class_name FireballImpact

func _ready() -> void:
	play("fireball-impact");
	await animation_finished
	queue_free()
