@tool
extends Node2D
class_name TutorialText

@export_multiline var message: String = "[center]Wall jump[/center]":
	set(value):
		message = value
		_apply_settings()

@export var box_size: Vector2 = Vector2(220.0, 72.0):
	set(value):
		box_size = value
		_apply_settings()

@export var text_color: Color = Color(0.85, 1.0, 1.0, 1.0):
	set(value):
		text_color = value
		_apply_settings()

@export var outline_color: Color = Color(0.0, 0.45, 0.9, 1.0):
	set(value):
		outline_color = value
		_apply_settings()

@export var background_color: Color = Color(0.0, 0.0, 0.0, 0.55):
	set(value):
		background_color = value
		_apply_settings()

@export var outline_size: int = 2:
	set(value):
		outline_size = value
		_apply_settings()

@export var font_size: int = 13:
	set(value):
		font_size = value
		_apply_settings()

@onready var background: ColorRect = $Background
@onready var rich_text_label: RichTextLabel = $RichTextLabel


func _ready() -> void:
	_apply_settings()


func _apply_settings() -> void:
	var background_node := get_node_or_null("Background") as ColorRect
	var label_node := get_node_or_null("RichTextLabel") as RichTextLabel

	if background_node == null or label_node == null:
		return

	background_node.position = -box_size * 0.5
	background_node.size = box_size
	background_node.color = background_color

	label_node.position = -box_size * 0.5
	label_node.size = box_size
	label_node.scale = Vector2.ONE
	label_node.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	label_node.bbcode_enabled = true
	label_node.fit_content = false
	label_node.scroll_active = false
	label_node.text = message

	label_node.add_theme_font_size_override("normal_font_size", font_size)
	label_node.add_theme_color_override("default_color", text_color)
	label_node.add_theme_color_override("font_outline_color", outline_color)
	label_node.add_theme_color_override("font_shadow_color", outline_color)
	label_node.add_theme_constant_override("outline_size", outline_size)
	label_node.add_theme_constant_override("shadow_offset_x", 2)
	label_node.add_theme_constant_override("shadow_offset_y", 2)