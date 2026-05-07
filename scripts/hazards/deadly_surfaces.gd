extends TileMap
class_name DeadlySurfaces


@export var hazard_enabled: bool = true


func _ready() -> void:
	if hazard_enabled:
		add_to_group("hazard")