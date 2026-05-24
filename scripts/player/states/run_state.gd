extends PlayerState
## Ground state when the player is moving left or right.


func enter(_previous_state: PlayerState) -> void:
	player.animation_controller.play("Run")


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

	if not player.has_horizontal_input():
		state_machine.transition_to("Idle")