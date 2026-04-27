extends PlayerState


func enter(_previous_state: PlayerState) -> void:
	print("Run")


func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.move_horizontal(delta)

	if player.wants_jump() and player.is_on_floor():
		state_machine.transition_to("Jump")
		return

	if not player.is_on_floor():
		state_machine.transition_to("Fall")
		return

	if not player.has_horizontal_input():
		state_machine.transition_to("Idle")