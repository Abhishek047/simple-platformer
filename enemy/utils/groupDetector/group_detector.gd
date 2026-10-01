class_name GroupDetector
extends Area2D

@export var group_name: StringName
@export var active_detector_name: StringName
signal custom_body_entered(body: Node2D)
signal custom_body_exited(body: Node2D)
var active_detector: String;
var detectors:Dictionary[String, CollisionShape2D] = {}

func _ready() -> void:
	for i in get_children().size():
		var child = get_child(i);
		if child is CollisionShape2D:
			detectors[child.name] = child;
			if child.name != active_detector_name:
				child.set_deferred("disabled", true)
			else:
				active_detector = child.name
				print(child.name, " is active detector")
	body_entered.connect(_on_area_body_entered)
	body_exited.connect(_on_area_body_exited)


func change_active_detector(new_active_detector: String) -> void:
	if not detectors.has(new_active_detector):
		return

	if active_detector and detectors.has(active_detector):
		detectors[active_detector].set_deferred("disabled", true)

	detectors[new_active_detector].set_deferred("disabled", false)
	active_detector = new_active_detector


func _on_area_body_entered(body: Node2D) -> void:
	if body.is_in_group(group_name):
		custom_body_entered.emit(body)


func _on_area_body_exited(body: Node2D) -> void:
	if body.is_in_group(group_name):
		custom_body_exited.emit(body)
