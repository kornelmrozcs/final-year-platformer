extends PlayerState


func enter(_previous_state: PlayerState) -> void:
	player.start_respawn()

	await player.get_tree().create_timer(player.respawn_delay).timeout

	player.global_position = player.respawn_position
	player.velocity = Vector2.ZERO

	await player.get_tree().physics_frame

	player.finish_respawn()

	await player.get_tree().create_timer(player.respawn_recover_time).timeout

	player.is_respawning = false
	state_machine.transition_to("Idle")


func physics_update(_delta: float) -> void:
	# no movement while respawning
	player.velocity = Vector2.ZERO