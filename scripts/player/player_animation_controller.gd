extends Node2D
## Small wrapper around AnimationPlayer and sprite facing.
## Keeps animation choice away from the movement physics.
class_name PlayerAnimationController


## Player script used for velocity and wall direction.
@export var player_controller: PlayerController
## AnimationPlayer with Idle, Run, Jump, Fall and WallSlide animations.
@export var animation_player: AnimationPlayer
## Sprite that gets flipped when the player turns.
@export var sprite: Sprite2D

var facing_direction: int = 1


## Plays a named animation if it is not already active.
func play(animation_name: String) -> void:
	if animation_player == null:
		return

	if animation_player.current_animation == animation_name:
		return

	animation_player.play(animation_name)
	# apply first frame straight away
	animation_player.advance(0.0)


## Uses horizontal velocity to face left or right.
func update_standard_facing() -> void:
	if player_controller == null or sprite == null:
		return

	if abs(player_controller.velocity.x) > 0.01:
		facing_direction = 1 if player_controller.velocity.x > 0.0 else -1

	sprite.flip_h = facing_direction < 0


## Faces the wall while sliding so the pose reads correctly.
func update_wall_slide_facing() -> void:
	if player_controller == null or sprite == null:
		return

	if player_controller.last_wall_normal.x > 0.0:
		facing_direction = 1
	elif player_controller.last_wall_normal.x < 0.0:
		facing_direction = -1

	sprite.flip_h = facing_direction < 0