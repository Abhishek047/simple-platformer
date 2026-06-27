extends Node

class_name StateAnimationManager

@export var animation_sprite_2d: AnimatedSprite2D:
	set(value):
		animation_sprite_2d = value
		update_configuration_warnings()

func _ready() -> void:
	hasAnimation()

func onPlay(animation_name: String) -> void:
	if(animation_sprite_2d.sprite_frames.has_animation(animation_name) == null):
		print("No animation found on %s with name %s", [animation_sprite_2d.name, animation_name])
		return;
	animation_sprite_2d.play(animation_name)

func flip_animation_horizontal(flip: bool) -> void:
	animation_sprite_2d.flip_h = flip

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()

	if animation_sprite_2d == null:
		warnings.append("Please assign a Sprite2D for animations.")

	return warnings

func hasAnimation() -> bool:
	assert(animation_sprite_2d != null, "Please assign a Sprite2D for animations.")
	return animation_sprite_2d != null
