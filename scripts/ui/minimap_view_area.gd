@tool
extends Node2D
class_name MinimapViewArea

@export var view_size: Vector2 = Vector2(1400.0, 900.0):
	set(value):
		view_size = value
		queue_redraw()

@export var border_width: float = 2.0:
	set(value):
		border_width = value
		queue_redraw()

@export var border_color: Color = Color(0.2, 0.8, 1.0, 0.9):
	set(value):
		border_color = value
		queue_redraw()


func _draw() -> void:
	if not Engine.is_editor_hint():
		return

	var rect := Rect2(-view_size * 0.5, view_size)
	draw_rect(rect, border_color, false, border_width)
