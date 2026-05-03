extends Node2D
class_name LevelController


@export var portal_path: NodePath = NodePath("Portal")
@export_file("*.tscn") var next_scene_path: String = ""

@onready var portal: Portal = get_node_or_null(portal_path) as Portal

var total_collectables: int = 0
var collected_count: int = 0


func _ready() -> void:
	_setup_portal()
	_setup_collectables()

	if portal == null:
		push_warning("Level has no portal set.")
		return

	if total_collectables <= 0:
		portal.open(false)
	else:
		portal.close()


func _setup_portal() -> void:
	if portal == null:
		return

	if not portal.player_entered_portal.is_connected(_on_player_entered_portal):
		portal.player_entered_portal.connect(_on_player_entered_portal)


func _setup_collectables() -> void:
	var collectables: Array[Collectable] = []
	_find_collectables(self, collectables)

	total_collectables = collectables.size()
	collected_count = 0

	for collectable in collectables:
		if not collectable.collected.is_connected(_on_collectable_collected):
			collectable.collected.connect(_on_collectable_collected)


func _find_collectables(parent: Node, result: Array[Collectable]) -> void:
	for child in parent.get_children():
		if child is Collectable:
			result.append(child)

		_find_collectables(child, result)


func _on_collectable_collected(_collectable: Collectable) -> void:
	collected_count += 1

	if collected_count >= total_collectables:
		_open_portal()


func _open_portal() -> void:
	if portal == null:
		return

	portal.open()


func _on_player_entered_portal() -> void:
	if next_scene_path.is_empty():
		push_warning("Level has no next scene set.")
		return

	call_deferred("_change_scene")


func _change_scene() -> void:
	get_tree().change_scene_to_file(next_scene_path)