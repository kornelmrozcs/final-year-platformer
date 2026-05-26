extends CanvasLayer
class_name Minimap

const DEFAULT_LAYER_MASK: int = 1
const MINIMAP_LAYER_MASK: int = 1 << 1

@export var viewport_size: Vector2i = Vector2i(220, 140)
@export var panel_offset: Vector2 = Vector2(16.0, 16.0)
@export var view_area_path: NodePath = NodePath("../../MinimapViewArea")

@onready var control: Control = $Control
@onready var black_background: ColorRect = $Control/BlackBackground
@onready var viewport_container: SubViewportContainer = $Control/PanelContainer/SubViewportContainer
@onready var viewport: SubViewport = $Control/PanelContainer/SubViewportContainer/SubViewport
@onready var minimap_camera: Camera2D = $Control/PanelContainer/SubViewportContainer/SubViewport/MinimapCamera


func _ready() -> void:
	visible = GameManager.is_easy_mode()

	if not visible:
		return

	_apply_panel_size()
	_setup_viewport()
	_setup_minimap_layers()
	_update_camera_view()
	minimap_camera.make_current()


func _apply_panel_size() -> void:
	var width := float(viewport_size.x)
	var height := float(viewport_size.y)

	control.offset_left = -(width + panel_offset.x)
	control.offset_top = panel_offset.y
	control.offset_right = -panel_offset.x
	control.offset_bottom = panel_offset.y + height

	black_background.custom_minimum_size = Vector2(width, height)
	viewport_container.custom_minimum_size = Vector2(width, height)


func _setup_viewport() -> void:
	# use the level world but only draw minimap marked objects
	viewport.world_2d = get_viewport().world_2d
	viewport.canvas_cull_mask = MINIMAP_LAYER_MASK
	viewport.transparent_bg = true
	viewport_container.stretch = false
	viewport.size = viewport_size


func _update_camera_view() -> void:
	var view_area := get_node_or_null(view_area_path) as MinimapViewArea

	if view_area == null:
		return

	var safe_size := Vector2(
		maxf(view_area.view_size.x, 1.0),
		maxf(view_area.view_size.y, 1.0)
	)
	var zoom_x := float(viewport_size.x) / safe_size.x
	var zoom_y := float(viewport_size.y) / safe_size.y
	var zoom_value := minf(zoom_x, zoom_y)

	minimap_camera.global_position = view_area.global_position
	minimap_camera.zoom = Vector2(zoom_value, zoom_value)


func _setup_minimap_layers() -> void:
	var level_root := get_tree().current_scene

	if level_root == null:
		level_root = owner

	if level_root == null:
		return

	_remove_minimap_layer(level_root)
	_add_minimap_layer_to_item(level_root)

	var gameplay_paths: Array[String] = [
		"Geometry",
		"Player",
		"FallDeath",
		"Water",
		"Interactables",
		"Platforms",
		"Hazards",
	]

	for path in gameplay_paths:
		var node := level_root.get_node_or_null(path)

		if node != null:
			_add_minimap_layer(node)


func _add_minimap_layer(node: Node) -> void:
	_add_minimap_layer_to_item(node)

	for child in node.get_children():
		_add_minimap_layer(child)


func _add_minimap_layer_to_item(node: Node) -> void:
	if node is CanvasItem:
		var canvas_item := node as CanvasItem
		canvas_item.visibility_layer = canvas_item.visibility_layer | MINIMAP_LAYER_MASK


func _remove_minimap_layer(node: Node) -> void:
	if node is CanvasItem:
		var canvas_item := node as CanvasItem
		canvas_item.visibility_layer = canvas_item.visibility_layer & ~MINIMAP_LAYER_MASK

	for child in node.get_children():
		_remove_minimap_layer(child)
