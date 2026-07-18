extends AnimatedSprite2D

class_name BulletImpact

func _ready() -> void:
	play("bullet-impact")
	await animation_finished
	queue_free()
