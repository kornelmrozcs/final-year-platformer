extends Node
## Base state used by the player state machine.
## Child states only override the parts they need.
class_name PlayerState

var player: PlayerController
var state_machine: PlayerStateMachine


func enter(_previous_state: PlayerState) -> void:
	pass


func exit() -> void:
	pass


func physics_update(_delta: float) -> void:
	pass