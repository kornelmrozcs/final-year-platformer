extends CanvasLayer
class_name Minimap

@export var viewport_size: Vector2i = Vector2i(220, 140)
@export var panel_offset: Vector2 = Vector2(16.0, 16.0)
@export var view_area_path: NodePath = NodePath("../../MinimapViewArea")

@export var player_marker_size: float = 10.0
@export var collectable_marker_size: float = 8.0
@export var portal_marker_size: float = 12.0

@export var player_marker_color: Color = Color(0.2, 1.0, 1.0, 1.0)
@export var collectable_marker_color: Color = Color(1.0, 0.85, 0.2, 1.0)
@export var portal_marker_color: Color = Color(0.8, 0.35, 1.0, 1.0)
@export var open_portal_marker_color: Color = Color(0.25, 1.0, 0.45, 1.0)

@onready var control: Control = $Control
@onready var black_background: ColorRect = $Control/BlackBackground
@onready var viewport_container: SubViewportContainer = $Control/PanelContainer/SubViewportContainer

var marker_layer: Control
var player_marker: ColorRect
var portal_marker: ColorRect
var collectable_markers: Dictionary = {}


func _ready() -> void:
	visible = GameManager.is_easy_mode()

	if not visible:
		set_process(false)
		return

	_apply_panel_size()
	_setup_marker_layer()
	set_process(true)


func _process(_delta: float) -> void:
	_update_player_marker()
	_update_portal_marker()
	_update_collectable_markers()


func _apply_panel_size() -> void:
	var width := float(viewport_size.x)
	var height := float(viewport_size.y)

	# keep minimap locked to top right
	control.anchor_left = 1.0
	control.anchor_top = 0.0
	control.anchor_right = 1.0
	control.anchor_bottom = 0.0

	control.offset_left = -(width + panel_offset.x)
	control.offset_top = panel_offset.y
	control.offset_right = -panel_offset.x
	control.offset_bottom = panel_offset.y + height

	# children should fill the minimap panel
	black_background.anchor_left = 0.0
	black_background.anchor_top = 0.0
	black_background.anchor_right = 1.0
	black_background.anchor_bottom = 1.0
	black_background.offset_left = 0.0
	black_background.offset_top = 0.0
	black_background.offset_right = 0.0
	black_background.offset_bottom = 0.0

	viewport_container.visible = false
	viewport_container.custom_minimum_size = Vector2(width, height)


func _setup_marker_layer() -> void:
	marker_layer = Control.new()
	marker_layer.name = "MarkerLayer"
	marker_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	marker_layer.position = Vector2.ZERO
	marker_layer.size = Vector2(viewport_size)
	marker_layer.clip_contents = true
	control.add_child(marker_layer)

	player_marker = _create_marker(player_marker_size, player_marker_color)
	portal_marker = _create_marker(portal_marker_size, portal_marker_color)


func _update_player_marker() -> void:
	var level_root := _get_level_root()

	if level_root == null:
		player_marker.visible = false
		return

	var player := level_root.get_node_or_null("Player") as Node2D
	_update_marker_position(player_marker, player, player_marker_size)


func _update_portal_marker() -> void:
	var level_root := _get_level_root()

	if level_root == null:
		portal_marker.visible = false
		return

	var portal := level_root.get_node_or_null("Interactables/Portal") as Node2D

	if portal != null and portal.has_method("open"):
		var is_open: bool = portal.get("is_open")
		portal_marker.color = open_portal_marker_color if is_open else portal_marker_color

	_update_marker_position(portal_marker, portal, portal_marker_size)


func _update_collectable_markers() -> void:
	var current_ids: Array[int] = []
	var collectables := _get_collectables()

	for collectable in collectables:
		var id := collectable.get_instance_id()
		current_ids.append(id)

		if not collectable_markers.has(id):
			collectable_markers[id] = _create_marker(collectable_marker_size, collectable_marker_color)

		var marker := collectable_markers[id] as ColorRect
		var is_collected: bool = collectable.is_collected

		if is_collected:
			marker.visible = false
		else:
			_update_marker_position(marker, collectable, collectable_marker_size)

	for id in collectable_markers.keys():
		if not current_ids.has(id):
			var old_marker := collectable_markers[id] as ColorRect
			old_marker.queue_free()
			collectable_markers.erase(id)


func _get_collectables() -> Array[Collectable]:
	var collectables: Array[Collectable] = []
	var level_root := _get_level_root()

	if level_root == null:
		return collectables

	var collectables_root := level_root.get_node_or_null("Interactables/Collectables")

	if collectables_root == null:
		return collectables

	_find_collectables(collectables_root, collectables)
	return collectables


func _find_collectables(node: Node, collectables: Array[Collectable]) -> void:
	if node is Collectable:
		collectables.append(node as Collectable)

	for child in node.get_children():
		_find_collectables(child, collectables)


func _update_marker_position(marker: ColorRect, target: Node2D, marker_size: float) -> void:
	if target == null:
		marker.visible = false
		return

	var marker_position := _world_to_minimap(target.global_position)

	if marker_position.x < 0.0 or marker_position.y < 0.0:
		marker.visible = false
		return

	if marker_position.x > float(viewport_size.x) or marker_position.y > float(viewport_size.y):
		marker.visible = false
		return

	marker.visible = true
	marker.size = Vector2(marker_size, marker_size)
	marker.position = marker_position - Vector2(marker_size, marker_size) * 0.5


func _world_to_minimap(world_position: Vector2) -> Vector2:
	var view_area := get_node_or_null(view_area_path) as MinimapViewArea

	if view_area == null:
		return Vector2(-1.0, -1.0)

	var safe_size := Vector2(
		maxf(view_area.view_size.x, 1.0),
		maxf(view_area.view_size.y, 1.0)
	)
	var top_left := view_area.global_position - safe_size * 0.5
	var local_position := world_position - top_left
	var normalized := Vector2(local_position.x / safe_size.x, local_position.y / safe_size.y)

	return Vector2(
		normalized.x * float(viewport_size.x),
		normalized.y * float(viewport_size.y)
	)


func _create_marker(marker_size: float, marker_color: Color) -> ColorRect:
	var marker := ColorRect.new()
	marker.color = marker_color
	marker.size = Vector2(marker_size, marker_size)
	marker.mouse_filter = Control.MOUSE_FILTER_IGNORE
	marker.visible = false
	marker_layer.add_child(marker)
	return marker


func _get_level_root() -> Node:
	var level_root := get_tree().current_scene

	if level_root != null:
		return level_root

	return owner
