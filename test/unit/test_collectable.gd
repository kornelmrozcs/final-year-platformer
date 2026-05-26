extends GutTest


func test_collectable_can_reset_after_pickup() -> void:
	var scene := load("res://scenes/interactables/collectable.tscn")
	var collectable := scene.instantiate() as Collectable

	add_child(collectable)
	await wait_idle_frames(1)

	collectable._collect()

	assert_true(collectable.is_collected, "collectable should be marked as collected")
	assert_false(collectable.animated_sprite.visible, "collectable should hide after pickup")

	collectable.reset_for_respawn()
	await wait_idle_frames(1)

	assert_false(collectable.is_collected, "collectable should reset collected state")
	assert_true(collectable.animated_sprite.visible, "collectable should show again after reset")

	collectable.queue_free()