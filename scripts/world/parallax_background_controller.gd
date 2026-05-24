@tool
extends Node2D
## Controls a group of parallax layers from one parent node.
class_name ParallaxBackgroundController


## Quick toggle for the full background.
@export var background_enabled: bool = true:
	set(value):
		background_enabled = value
		_apply_background()

## Keep this on while placing layers in the editor.
@export var update_in_editor: bool = true


func _ready() -> void:
	_apply_background()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint() and update_in_editor:
		_apply_background()


func _apply_background() -> void:
	if not is_inside_tree():
		return

	visible = background_enabled

	for child in get_children():
		if child is ParallaxBackgroundLayer:
			child.apply_settings()
