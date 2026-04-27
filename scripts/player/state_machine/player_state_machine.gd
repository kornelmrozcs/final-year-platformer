extends Node
class_name PlayerStateMachine

var player: PlayerController
var current_state: PlayerState
var states: Dictionary = {}


func init(player_ref: PlayerController) -> void:
	player = player_ref
	states.clear()

	for child in get_children():
		var state := child as PlayerState

		if state == null:
			continue

		state.player = player
		state.state_machine = self
		states[child.name] = state

	transition_to("Idle")


func physics_update(delta: float) -> void:
	if current_state == null:
		return

	current_state.physics_update(delta)


func transition_to(state_name: String) -> void:
	if not states.has(state_name):
		push_warning("State does not exist: " + state_name)
		return

	var next_state: PlayerState = states[state_name]

	if next_state == current_state:
		return

	var previous_state := current_state

	if current_state != null:
		current_state.exit()

	current_state = next_state
	current_state.enter(previous_state)
