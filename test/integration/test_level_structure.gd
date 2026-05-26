extends GutTest


func test_level_1_loads_with_core_nodes() -> void:
	var scene: PackedScene = load("res://scenes/world/level_1.tscn") as PackedScene
	assert_not_null(scene, "level 1 scene should load")

	var level: Node = scene.instantiate()
	add_child(level)
	await wait_idle_frames(2)

	assert_not_null(level.get_node_or_null("UI/HUD"), "level should have HUD")
	assert_not_null(level.get_node_or_null("UI/Minimap"), "level should have minimap")
	assert_not_null(level.get_node_or_null("UI/PauseMenu"), "level should have pause menu")
	assert_not_null(level.get_node_or_null("Player"), "level should have player")
	assert_not_null(level.get_node_or_null("Interactables/Portal"), "level should have portal")
	assert_not_null(level.get_node_or_null("Interactables/Collectables"), "level should have collectables container")
	assert_not_null(level.get_node_or_null("Geometry/TileMap"), "level should have tilemap")
	assert_not_null(level.get_node_or_null("Geometry/DeadlySurfaces"), "level should have deadly surfaces")
	assert_not_null(level.get_node_or_null("Hazards"), "level should have hazards container")
	assert_not_null(level.get_node_or_null("Platforms"), "level should have platforms container")

	level.queue_free()


func test_level_2_loads_with_core_nodes() -> void:
	var scene: PackedScene = load("res://scenes/world/level_2.tscn") as PackedScene
	assert_not_null(scene, "level 2 scene should load")

	var level: Node = scene.instantiate()
	add_child(level)
	await wait_idle_frames(2)

	assert_not_null(level.get_node_or_null("UI/HUD"), "level should have HUD")
	assert_not_null(level.get_node_or_null("Player"), "level should have player")
	assert_not_null(level.get_node_or_null("Interactables/Portal"), "level should have portal")
	assert_not_null(level.get_node_or_null("Interactables/Collectables"), "level should have collectables container")
	assert_not_null(level.get_node_or_null("Geometry/TileMap"), "level should have tilemap")

	level.queue_free()


func test_level_3_loads_with_core_nodes() -> void:
	var scene: PackedScene = load("res://scenes/world/level_3.tscn") as PackedScene
	assert_not_null(scene, "level 3 scene should load")

	var level: Node = scene.instantiate()
	add_child(level)
	await wait_idle_frames(2)

	assert_not_null(level.get_node_or_null("UI/HUD"), "level should have HUD")
	assert_not_null(level.get_node_or_null("Player"), "level should have player")
	assert_not_null(level.get_node_or_null("Interactables/Portal"), "level should have portal")
	assert_not_null(level.get_node_or_null("Interactables/Collectables"), "level should have collectables container")
	assert_not_null(level.get_node_or_null("Geometry/TileMap"), "level should have tilemap")

	level.queue_free()