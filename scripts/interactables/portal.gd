extends Area2D


@export_file("*.tscn") var next_scene_path: String = ""

var is_used: bool = false


func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if is_used:
		return

	if not body.is_in_group("player"):
		return

	if next_scene_path.is_empty():
		push_warning("Portal has no next scene set.")
		return

	is_used = true
	call_deferred("_change_scene")


func _change_scene() -> void:
	get_tree().change_scene_to_file(next_scene_path)