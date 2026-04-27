extends PlayerState


func enter(_previous_state: PlayerState) -> void:
	print("Fall")


func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.move_horizontal(delta)

	if not player.is_on_floor():
		return

	if player.has_horizontal_input():
		state_machine.transition_to("Run")
	else:
		state_machine.transition_to("Idle")