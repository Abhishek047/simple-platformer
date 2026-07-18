extends Node

class_name HealthComponent

signal health_changed(current: int, max: int)
signal died

@export var max_health: int = 1

var health: int

func _ready() -> void:
	health = max_health

func hit(damage: int = 1) -> void:
	health = clamp(health - damage, 0, max_health)
	health_changed.emit(health, max_health)

	if health == 0:
		died.emit()

func heal(amount: int = 1) -> void:
	health = clamp(health + amount, 0, max_health)
	health_changed.emit(health, max_health)
