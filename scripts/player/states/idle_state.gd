extends PlayerState


func enter(_previous_state: PlayerState) -> void:
	print("Idle")
	player.animation_controller.play("Idle")

func physics_update(delta: float) -> void:
	player.animation_controller.update_standard_facing()
	player.apply_gravity(delta)
	player.move_horizontal(delta)

	if player.wants_jump() and player.can_ground_jump():
		state_machine.transition_to("Jump")
		return

	if not player.is_on_floor():
		state_machine.transition_to("Fall")
		return

	if player.has_horizontal_input():
		state_machine.transition_to("Run")
