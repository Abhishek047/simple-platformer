extends AnimatedSprite2D

class_name DeathEffect

func _ready() -> void:
	play("death")
	await animation_finished
	queue_free()
