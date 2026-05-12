extends Node2D
class_name PlayerAnimationController


@export var player_controller: PlayerController
@export var animation_player: AnimationPlayer
@export var sprite: Sprite2D

var facing_direction: int = 1


func play(animation_name: String) -> void:
	if animation_player == null:
		return

	if animation_player.current_animation == animation_name:
		return

	animation_player.play(animation_name)
	# apply first frame straight away
	animation_player.advance(0.0)


func update_standard_facing() -> void:
	if player_controller == null or sprite == null:
		return

	if abs(player_controller.velocity.x) > 0.01:
		facing_direction = 1 if player_controller.velocity.x > 0.0 else -1

	sprite.flip_h = facing_direction < 0


func update_wall_slide_facing() -> void:
	if player_controller == null or sprite == null:
		return

	if player_controller.last_wall_normal.x > 0.0:
		facing_direction = 1
	elif player_controller.last_wall_normal.x < 0.0:
		facing_direction = -1

	sprite.flip_h = facing_direction < 0