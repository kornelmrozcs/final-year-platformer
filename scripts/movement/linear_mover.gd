extends Node
## Reusable helper for simple back and forth movement.
## Platforms and saws use this so the movement settings stay in one place.
class_name LinearMover


## Node that will actually be moved.
@export var target_path: NodePath = NodePath("..")
## Optional marker used when use_end_point is true.
@export var end_point_path: NodePath = NodePath("../EndPoint")

## Use an EndPoint marker instead of move_offset.
@export var use_end_point: bool = false
## Offset used for the end position when no marker is used.
@export var move_offset: Vector2 = Vector2(128.0, 0.0)

## Stops the movement without removing the node.
@export var active: bool = true
## Time for one half of the movement loop.
@export var travel_time: float = 2.0
## Wait time after reaching either end.
@export var wait_time: float = 0.15
## Starting direction for the first movement.
@export var starts_towards_end: bool = true

var target: Node2D
var start_position: Vector2
var end_position: Vector2
var moving_towards_end: bool = true
var wait_timer: float = 0.0


func _ready() -> void:
	refresh_positions()


## Re-checks start and end positions after moving things in the editor.
func refresh_positions() -> void:
	target = get_node_or_null(target_path) as Node2D

	if target == null:
		push_warning("LinearMover has no target.")
		return

	start_position = target.global_position
	end_position = _get_end_position()
	moving_towards_end = starts_towards_end
	wait_timer = 0.0


func _physics_process(delta: float) -> void:
	if not active:
		return

	if target == null:
		return

	if wait_timer > 0.0:
		wait_timer = max(wait_timer - delta, 0.0)
		return

	var destination: Vector2 = end_position if moving_towards_end else start_position
	var distance: float = start_position.distance_to(end_position)

	if distance <= 0.0:
		return

	var speed: float = distance / max(travel_time, 0.01)
	target.global_position = target.global_position.move_toward(destination, speed * delta)

	if target.global_position.distance_to(destination) <= 0.5:
		target.global_position = destination
		moving_towards_end = not moving_towards_end
		wait_timer = wait_time


func _get_end_position() -> Vector2:
	if use_end_point:
		var end_point: Node2D = get_node_or_null(end_point_path) as Node2D

		if end_point != null:
			return end_point.global_position

	return start_position + move_offset