extends PlayerState


func enter(_previous_state: PlayerState) -> void:
	print("Fall")


func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.move_horizontal(delta)

	if player.wants_jump() and player.can_ground_jump():
		state_machine.transition_to("Jump")
		return

	if player.can_wall_slide():
		state_machine.transition_to("WallSlide")
		return

	if not player.is_on_floor():
		return

	if player.has_horizontal_input():
		state_machine.transition_to("Run")
	else:
		state_machine.transition_to("Idle")