extends Node2D
class_name LevelController


@export var portal_path: NodePath = NodePath("Portal")
@export_file("*.tscn") var next_scene_path: String = ""
@export var reset_run_on_start: bool = false
@export var start_timer_on_ready: bool = true
@export var hud_path: NodePath = NodePath("HUD")
@export var player_path: NodePath = NodePath("player")
@export var resettable_group_name: StringName = &"reset_on_respawn"
@export var respawn_fade_path: NodePath = NodePath("RespawnFade")

@onready var portal: Portal = get_node_or_null(portal_path) as Portal
@onready var hud: HUD = get_node_or_null(hud_path) as HUD
@onready var player: PlayerController = get_node_or_null(player_path) as PlayerController
@onready var respawn_fade: RespawnFade = get_node_or_null(respawn_fade_path) as RespawnFade

var total_collectables: int = 0
var collected_count: int = 0
var collectables: Array[Collectable] = []


func _ready() -> void:
	if reset_run_on_start:
		GameManager.reset_run()

	if start_timer_on_ready:
		GameManager.start_run()

	_setup_portal()
	_setup_player_respawn_reset()
	_setup_collectables()
	_update_hud_collectables()

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
	collectables.clear()
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
	_update_hud_collectables()

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

func _update_hud_collectables() -> void:
	if hud == null:
		return

	hud.update_collectables(collected_count, total_collectables)

func _setup_player_respawn_reset() -> void:
	if player == null:
		push_warning("Level has no player set.")
		return

	if not player.respawn_started.is_connected(_on_player_respawn_started):
		player.respawn_started.connect(_on_player_respawn_started)

	if not player.respawn_position_reached.is_connected(_on_player_respawn_position_reached):
		player.respawn_position_reached.connect(_on_player_respawn_position_reached)


func _on_player_respawn_started() -> void:
	if respawn_fade == null:
		return

	# fade starts straight away, but reset happens later
	respawn_fade.fade_out()


func _on_player_respawn_position_reached() -> void:
	# reset platforms only after player is back at respawn position
	_reset_respawn_objects()

	if GameManager.is_hard_mode():
		_reset_collectables_for_respawn()

	if respawn_fade == null:
		return

	respawn_fade.fade_in()


func _reset_respawn_objects() -> void:
	for node in get_tree().get_nodes_in_group(resettable_group_name):
		if not is_ancestor_of(node):
			continue

		if node.has_method("reset_for_respawn"):
			node.reset_for_respawn()

func _reset_collectables_for_respawn() -> void:
	collected_count = 0

	for collectable in collectables:
		if collectable != null and collectable.has_method("reset_for_respawn"):
			collectable.reset_for_respawn()

	if total_collectables > 0 and portal != null:
		portal.close()

	_update_hud_collectables()
