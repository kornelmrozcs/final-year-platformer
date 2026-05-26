extends CanvasLayer
class_name Minimap

@export var minimap_camera_path: NodePath = NodePath("../../MinimapCamera")
@export var viewport_size: Vector2i = Vector2i(220, 140)

@onready var viewport: SubViewport = $Control/PanelContainer/SubViewportContainer/SubViewport
@onready var minimap_camera: Camera2D = $Control/PanelContainer/SubViewportContainer/SubViewport/MinimapCamera


func _ready() -> void:
	visible = GameManager.is_easy_mode()

	if not visible:
		return

	viewport.size = viewport_size

	# use same level world so the minimap shows the current stage
	viewport.world_2d = get_viewport().world_2d
	_update_camera_from_level_marker()


func _update_camera_from_level_marker() -> void:
	var level_camera := get_node_or_null(minimap_camera_path) as Camera2D

	if level_camera == null:
		return

	minimap_camera.global_position = level_camera.global_position
	minimap_camera.zoom = level_camera.zoom
