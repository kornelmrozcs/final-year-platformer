extends Area2D
class_name Portal

signal player_entered_portal

@export var starts_open: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var is_open: bool = false
var is_used: bool = false

var closed_region: Rect2 = Rect2(0, 0, 22, 22)
var open_region: Rect2 = Rect2(22, 0, 22, 22)


func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

	if starts_open:
		open(false)
	else:
		close()


func open(play_sound: bool = true) -> void:
	if is_open:
		return

	is_open = true
	sprite.region_rect = open_region

	if play_sound:
		audio_player.play()


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