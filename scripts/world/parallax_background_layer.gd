@tool
extends Parallax2D
class_name ParallaxBackgroundLayer


@export var layer_enabled: bool = true:
	set(value):
		layer_enabled = value
		apply_settings()

@export_range(0.0, 2.0, 0.01) var horizontal_scroll_scale: float = 0.2:
	set(value):
		horizontal_scroll_scale = value
		apply_settings()

@export var auto_scroll_enabled: bool = false:
	set(value):
		auto_scroll_enabled = value
		apply_settings()

@export var auto_scroll_speed: float = 0.0:
	set(value):
		auto_scroll_speed = value
		apply_settings()

@export var repeat_width: float = 1440.0:
	set(value):
		repeat_width = value
		apply_settings()

@export_range(1, 8, 1) var repeat_count: int = 2:
	set(value):
		repeat_count = value
		apply_settings()

@export var layer_z_index: int = -100:
	set(value):
		layer_z_index = value
		apply_settings()


func _ready() -> void:
	apply_settings()


func apply_settings() -> void:
	visible = layer_enabled
	z_index = layer_z_index

	follow_viewport = true
	ignore_camera_scroll = false

	# only use horizontal parallax 
	scroll_scale = Vector2(horizontal_scroll_scale, 0.0)

	var scroll_speed: float = auto_scroll_speed if auto_scroll_enabled else 0.0
	autoscroll = Vector2(scroll_speed, 0.0)

	# only repeat horizontally
	repeat_size = Vector2(max(repeat_width, 0.0), 0.0)
	repeat_times = max(repeat_count, 1)