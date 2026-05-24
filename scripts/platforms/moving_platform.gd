@tool
extends AnimatableBody2D
## Moving platform controlled by a child LinearMover.
## Path preview helps when placing platforms in levels.
class_name MovingPlatform


## Child mover node that handles the movement.
@export var mover_path: NodePath = NodePath("LinearMover")

## Allows this platform to be turned off for testing.
@export var active: bool = true:
	set(value):
		active = value
		_apply_mover_settings()

## Distance from the start point to the end point.
@export var move_offset: Vector2 = Vector2(128.0, 0.0):
	set(value):
		move_offset = value
		_apply_mover_settings()
		queue_redraw()

## Time to move across the path.
@export var travel_time: float = 2.0:
	set(value):
		travel_time = value
		_apply_mover_settings()

## Short stop at each end of the path.
@export var wait_time: float = 0.15:
	set(value):
		wait_time = value
		_apply_mover_settings()

## Pick the first movement direction.
@export var starts_towards_end: bool = true:
	set(value):
		starts_towards_end = value
		_apply_mover_settings()

## Shows the movement path in the editor.
@export var show_path_preview: bool = true:
	set(value):
		show_path_preview = value
		queue_redraw()


func _ready() -> void:
	_apply_mover_settings()
	queue_redraw()


func _draw() -> void:
	if not Engine.is_editor_hint():
		return

	if not show_path_preview:
		return

	# show where the platform will move in the editor
	draw_line(Vector2.ZERO, move_offset, Color(0.2, 0.8, 1.0, 0.9), 2.0)
	draw_circle(move_offset, 4.0, Color(0.2, 0.8, 1.0, 0.9))


func _apply_mover_settings() -> void:
	if not is_inside_tree():
		return

	var mover: LinearMover = get_node_or_null(mover_path) as LinearMover

	if mover == null:
		return

	mover.target_path = NodePath("..")
	mover.use_end_point = false
	mover.move_offset = move_offset
	mover.active = active
	mover.travel_time = travel_time
	mover.wait_time = wait_time
	mover.starts_towards_end = starts_towards_end

	if not Engine.is_editor_hint():
		mover.refresh_positions()