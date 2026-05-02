extends Node2D
class_name Water

@export var water_size: Vector2 = Vector2(30.0, 96.0)
@export var surface_color: Color = Color(0.35, 0.75, 1.0, 1.0)
@export var fill_color: Color = Color(0.1, 0.35, 0.55, 0.55)

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var surface_line: Line2D = $Line2D
@onready var fill_polygon: Polygon2D = $Polygon2D


func _ready() -> void:
	_setup_visuals()
	_setup_collision()

	if not area_2d.body_entered.is_connected(_on_body_entered):
		area_2d.body_entered.connect(_on_body_entered)


func _setup_visuals() -> void:
	# simple water line for now, physics waves can be added later
	surface_line.width = 2.0
	surface_line.default_color = surface_color
	surface_line.points = PackedVector2Array([
		Vector2.ZERO,
		Vector2(water_size.x, 0.0)
	])

	fill_polygon.color = fill_color
	fill_polygon.polygon = PackedVector2Array([
		Vector2(0.0, 0.0),
		Vector2(water_size.x, 0.0),
		Vector2(water_size.x, water_size.y),
		Vector2(0.0, water_size.y)
	])


func _setup_collision() -> void:
	var shape := RectangleShape2D.new()
	shape.size = water_size
	collision_shape.shape = shape
	collision_shape.position = water_size * 0.5


func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return

	_make_splash(body)

	if body.has_method("request_respawn"):
		body.request_respawn()


func _make_splash(body: Node) -> void:
	# placeholder for now, later this will move water points
	print("splash at ", body.global_position)