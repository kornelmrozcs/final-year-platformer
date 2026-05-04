extends PlayerState


func enter(_previous_state: PlayerState) -> void:
	print("WallSlide")
	player.animation_controller.play("WallSlide")

func physics_update(delta: float) -> void:
	player.animation_controller.update_wall_slide_facing()
	player.apply_gravity(delta)
	player.apply_wall_slide(delta)
	player.move_horizontal(delta)

	if player.wants_jump() and player.can_wall_jump():
		state_machine.transition_to("Jump")
		return

	if player.is_on_floor():
		if player.has_horizontal_input():
			state_machine.transition_to("Run")
		else:
			state_machine.transition_to("Idle")
		return

	if not player.can_wall_slide():
		state_machine.transition_to("Fall")