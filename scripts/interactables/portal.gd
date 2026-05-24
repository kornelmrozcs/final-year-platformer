extends Area2D
## Level exit. It stays closed until all collectables are picked up.
class_name Portal

signal player_entered_portal

## Useful for test scenes with no collectables.
@export var starts_open: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var is_open: bool = false
var is_used: bool = false

var closed_region: Rect2 = Rect2(0, 0, 32, 32)
var open_region: Rect2 = Rect2(32, 0, 32, 32)


func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

	if starts_open:
		open(false)
	else:
		close()


## Opens the portal and optionally plays the open sound.
func open(play_sound: bool = true) -> void:
	if is_open:
		return

	is_open = true
	sprite.region_rect = open_region

	if play_sound:
		audio_player.play()


## Closes the portal and lets it be used again.
func close() -> void:
	is_open = false
	is_used = false
	sprite.region_rect = closed_region


func _on_body_entered(body: Node) -> void:
	if is_used:
		return

	if not body.is_in_group("player"):
		return

	if not is_open:
		return

	is_used = true
	player_entered_portal.emit()