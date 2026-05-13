@tool
extends Area2D
class_name MovingSaw


@export var mover_path: NodePath = NodePath("LinearMover")
@export var sprite_path: NodePath = NodePath("AnimatedSprite2D")

@export var active: bool = true:
	set(value):
		active = value
		_apply_mover_settings()

@export var move_offset: Vector2 = Vector2(128.0, 0.0):
	set(value):
		move_offset = value
		_apply_mover_settings()
		queue_redraw()

@export var travel_time: float = 2.0:
	set(value):
		travel_time = value
		_apply_mover_settings()

@export var wait_time: float = 0.15:
	set(value):
		wait_time = value
		_apply_mover_settings()

@export var starts_towards_end: bool = true:
	set(value):
		starts_towards_end = value
		_apply_mover_settings()

@export var show_path_preview: bool = true:
	set(value):
		show_path_preview = value
		queue_redraw()

@export var animation_speed: float = 12.0:
	set(value):
		animation_speed = value
		_apply_animation_settings()

@export var death_reason: String = "saw hazard"

var sprite: AnimatedSprite2D


func _ready() -> void:
	sprite = get_node_or_null(sprite_path) as AnimatedSprite2D

	_apply_mover_settings()
	_apply_animation_settings()
	queue_redraw()

	# connect signal here so the saw works after instancing
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func _draw() -> void:
	if not Engine.is_editor_hint():
		return

	if not show_path_preview:
		return

	# draw movement path while editing the level
	draw_line(Vector2.ZERO, move_offset, Color(1.0, 0.3, 0.3, 0.9), 2.0)
	draw_circle(move_offset, 4.0, Color(1.0, 0.3, 0.3, 0.9))


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


func _apply_animation_settings() -> void:
	if not is_inside_tree():
		return

	if sprite == null:
		sprite = get_node_or_null(sprite_path) as AnimatedSprite2D

	if sprite == null:
		return

	sprite.speed_scale = animation_speed

	if sprite.sprite_frames != null and sprite.sprite_frames.has_animation("spin"):
		sprite.play("spin")


func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return

	if body.has_method("request_respawn"):
		body.request_respawn(death_reason + ": " + name)