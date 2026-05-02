@tool
extends Node2D
class_name Water

## width of the water in pixels
@export_range(128.0, 10000.0, 16.0, "suffix:px") var water_width: float = 3000.0:
	set(value):
		water_width = value
		_update_water()

## geight of the visible water area
@export_range(16.0, 512.0, 8.0, "suffix:px") var water_height: float = 96.0:
	set(value):
		water_height = value
		_update_water()

## tickness of the top water line
@export_range(1.0, 8.0, 1.0, "suffix:px") var surface_line_width: float = 2.0:
	set(value):
		surface_line_width = value
		_update_water()

## small delay before another splash can trigger
@export_range(0.0, 1.0, 0.05, "suffix:s") var splash_cooldown_time: float = 0.20

## yop line colour
@export var surface_color: Color = Color(0.35, 0.75, 1.0, 1.0):
	set(value):
		surface_color = value
		_update_water()

## fill colour under the surface.
@export var fill_color: Color = Color(0.1, 0.35, 0.55, 0.55):
	set(value):
		fill_color = value
		_update_water()

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var surface_line: Line2D = $Line2D
@onready var fill_polygon: Polygon2D = $Polygon2D

var can_splash: bool = true


func _ready() -> void:
	_update_water()

	if Engine.is_editor_hint():
		return

	if not area_2d.body_entered.is_connected(_on_body_entered):
		area_2d.body_entered.connect(_on_body_entered)


func _update_water() -> void:
	# can run in editor before child nodes are ready
	if not is_inside_tree():
		return

	var line := get_node_or_null("Line2D") as Line2D
	var polygon := get_node_or_null("Polygon2D") as Polygon2D
	var shape_node := get_node_or_null("Area2D/CollisionShape2D") as CollisionShape2D

	if line == null or polygon == null or shape_node == null:
		return

	var water_size := Vector2(water_width, water_height)

	# visible surface of the water
	line.width = surface_line_width
	line.default_color = surface_color
	line.points = PackedVector2Array([
		Vector2.ZERO,
		Vector2(water_size.x, 0.0)
	])

	# simple fill for now, later this can follow wave points
	polygon.color = fill_color
	polygon.polygon = PackedVector2Array([
		Vector2(0.0, 0.0),
		Vector2(water_size.x, 0.0),
		Vector2(water_size.x, water_size.y),
		Vector2(0.0, water_size.y)
	])

	# this only detects splash, death is handled by FallDeath
	var rectangle := RectangleShape2D.new()
	rectangle.size = water_size
	shape_node.shape = rectangle
	shape_node.position = water_size * 0.5


func _on_body_entered(body: Node) -> void:
	if Engine.is_editor_hint():
		return

	if not body.is_in_group("player"):
		return

	# do not splash when player is being moved back by respawn
	if body is PlayerController and body.is_respawning:
		return

	if not can_splash:
		return

	_make_splash(body)
	_start_splash_cooldown()


func _make_splash(body: Node) -> void:
	# placeholder for now, later this will move water points
	print("splash at ", body.global_position)


func _start_splash_cooldown() -> void:
	can_splash = false

	await get_tree().create_timer(splash_cooldown_time).timeout

	can_splash = true