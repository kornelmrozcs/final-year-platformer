extends PlayerState
## Jump state for normal jumps and wall jumps.


func enter(_previous_state: PlayerState) -> void:
	player.animation_controller.play("Jump")

	if player.can_wall_jump():
		player.wall_jump()
	else:
		player.jump()


func physics_update(delta: float) -> void:
	player.animation_controller.update_standard_facing()
	player.apply_gravity(delta)
	player.move_horizontal(delta)

	if player.can_wall_slide():
		state_machine.transition_to("WallSlide")
		return

	if player.velocity.y >= 0.0:
		state_machine.transition_to("Fall")