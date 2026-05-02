@tool
extends Node2D
class_name Water

## width of the water in pixels
@export_range(16.0, 10000.0, 2.0, "suffix:px") var water_width: float = 100.0:
	set(value):
		water_width = value
		_rebuild_water()

## height of the visible water area
@export_range(16.0, 512.0, 8.0, "suffix:px") var water_height: float = 96.0:
	set(value):
		water_height = value
		_rebuild_water()

## small pixel offset for the water surface
@export var surface_pos_y: float = 0.5:
	set(value):
		surface_pos_y = value
		_rebuild_water()

## amount of points used for the water surface
@export_range(2, 512, 1) var segment_count: int = 64:
	set(value):
		segment_count = value
		_rebuild_water()

## lowers player velocity before it hits the water
@export var player_splash_multiplier: float = 0.12

## how fast the water simulation moves
@export_range(0.0, 1000.0, 1.0) var water_physics_speed: float = 80.0

## pulls each point back to the surface
@export var water_restoring_force: float = 0.02

## removes energy so waves calm down
@export var wave_energy_loss: float = 0.04

## how much waves affect nearby points
@export var wave_strength: float = 0.25

## more updates makes waves spread smoother
@export_range(1, 64, 1) var wave_spread_updates: int = 8

## thickness of the top water line
@export_range(1.0, 8.0, 1.0, "suffix:px") var surface_line_width: float = 1.0:
	set(value):
		surface_line_width = value
		_update_visuals()

## top line colour
@export var surface_color: Color = Color("3ce1da"):
	set(value):
		surface_color = value
		_update_visuals()

## fill colour under the surface
@export var fill_color: Color = Color("37b0c5"):
	set(value):
		fill_color = value
		_update_visuals()

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var surface_line: Line2D = $Line2D
@onready var fill_polygon: Polygon2D = $Polygon2D

var segment_data: Array = []
var recently_splashed: bool = false


func _ready() -> void:
	_rebuild_water()
	set_process(false)

	if Engine.is_editor_hint():
		return

	if not area_2d.body_entered.is_connected(_on_body_entered):
		area_2d.body_entered.connect(_on_body_entered)

	if not area_2d.body_exited.is_connected(_on_body_exited):
		area_2d.body_exited.connect(_on_body_exited)


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	_update_physics(delta)
	_update_visuals()


func _rebuild_water() -> void:
	# can run before child nodes are ready in editor
	if not is_inside_tree():
		return

	segment_data.clear()

	for _i in range(segment_count):
		segment_data.append({
			"height": surface_pos_y,
			"velocity": 0.0,
			"wave_to_left": 0.0,
			"wave_to_right": 0.0
		})

	_update_collision()
	_update_visuals()


func _update_collision() -> void:
	var shape_node := get_node_or_null("Area2D/CollisionShape2D") as CollisionShape2D

	if shape_node == null:
		return

	var rectangle := RectangleShape2D.new()
	rectangle.size = Vector2(water_width, water_height)

	shape_node.shape = rectangle
	shape_node.position = Vector2(water_width * 0.5, surface_pos_y + water_height * 0.5)


func _update_physics(delta: float) -> void:
	for i in range(segment_count):
		var displacement: float = segment_data[i]["height"] - surface_pos_y
		var acceleration: float = -water_restoring_force * displacement - segment_data[i]["velocity"] * wave_energy_loss

		segment_data[i]["velocity"] += acceleration * delta * water_physics_speed
		segment_data[i]["height"] += segment_data[i]["velocity"] * delta * water_physics_speed

	for _updates in range(wave_spread_updates):
		for i in range(segment_count):
			if i > 0:
				segment_data[i]["wave_to_left"] = (segment_data[i]["height"] - segment_data[i - 1]["height"]) * wave_strength
				segment_data[i - 1]["velocity"] += segment_data[i]["wave_to_left"] * delta * water_physics_speed

			if i < segment_count - 1:
				segment_data[i]["wave_to_right"] = (segment_data[i]["height"] - segment_data[i + 1]["height"]) * wave_strength
				segment_data[i + 1]["velocity"] += segment_data[i]["wave_to_right"] * delta * water_physics_speed

		for i in range(segment_count):
			if i > 0:
				segment_data[i - 1]["height"] += segment_data[i]["wave_to_left"] * delta * water_physics_speed

			if i < segment_count - 1:
				segment_data[i + 1]["height"] += segment_data[i]["wave_to_right"] * delta * water_physics_speed

	# keep the edges flat so water does not open gaps near walls
	if segment_count >= 4:
		segment_data[0]["height"] = surface_pos_y
		segment_data[1]["height"] = surface_pos_y
		segment_data[0]["velocity"] = 0.0
		segment_data[1]["velocity"] = 0.0

		segment_data[segment_count - 1]["height"] = surface_pos_y
		segment_data[segment_count - 2]["height"] = surface_pos_y
		segment_data[segment_count - 1]["velocity"] = 0.0
		segment_data[segment_count - 2]["velocity"] = 0.0

	if recently_splashed:
		recently_splashed = false
		return

	var is_still: bool = true

	for point in surface_line.points:
		if abs(point.y - surface_pos_y) > 0.001:
			is_still = false
			break

	set_process(not is_still)


func _update_visuals() -> void:
	var line := get_node_or_null("Line2D") as Line2D
	var polygon := get_node_or_null("Polygon2D") as Polygon2D

	if line == null or polygon == null:
		return

	if segment_data.size() != segment_count:
		return

	var points: Array[Vector2] = []
	var segment_width: float = water_width / float(segment_count - 1)

	for i in range(segment_count):
		points.append(Vector2(i * segment_width, segment_data[i]["height"]))

	var left_static_point: Vector2 = Vector2(points[0].x, surface_pos_y)
	var right_static_point: Vector2 = Vector2(points[points.size() - 1].x, surface_pos_y)

	var final_points: Array[Vector2] = []
	final_points.append(left_static_point)
	final_points += points
	final_points.append(right_static_point)

	line.width = surface_line_width
	line.default_color = surface_color
	line.points = PackedVector2Array(final_points)

	var bottom_y: float = surface_pos_y + water_height
	final_points.append(Vector2(water_width, bottom_y))
	final_points.append(Vector2(0.0, bottom_y))

	polygon.color = fill_color
	polygon.polygon = PackedVector2Array(final_points)


func splash(splash_pos: Vector2, splash_velocity: float) -> void:
	if segment_data.is_empty():
		return

	var local_x_pos: float = to_local(splash_pos).x
	var segment_width: float = water_width / float(segment_count - 1)
	var index: int = int(clamp(local_x_pos / segment_width, 0.0, float(segment_count - 1)))

	segment_data[index]["velocity"] = splash_velocity
	recently_splashed = true

	set_process(true)


func _on_body_entered(body: Node2D) -> void:
	if Engine.is_editor_hint():
		return

	if not body.is_in_group("player"):
		return

	if body is PlayerController and body.is_respawning:
		return

	if body is CharacterBody2D:
		splash(body.global_position, body.velocity.y * player_splash_multiplier)


func _on_body_exited(body: Node2D) -> void:
	if Engine.is_editor_hint():
		return

	if not body.is_in_group("player"):
		return

	if body is PlayerController and body.is_respawning:
		return

	if body is CharacterBody2D:
		splash(body.global_position, body.velocity.y * player_splash_multiplier)