extends TileMap
## TileMap used for spike and deadly floor tiles.
## PlayerController checks this through the hazard group.
class_name DeadlySurfaces


## Turn this off if a test level needs safe hazard tiles.
@export var hazard_enabled: bool = true


func _ready() -> void:
	if hazard_enabled:
		add_to_group("hazard")