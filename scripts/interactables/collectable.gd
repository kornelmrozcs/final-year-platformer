extends Area2D
class_name Collectable

signal collected(collectable: Collectable)

## Lowest random pitch for the pickup sound.
@export var min_pitch_scale: float = 0.95

## Highest random pitch for the pickup sound.
@export var max_pitch_scale: float = 1.05

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var is_collected: bool = false
var rng: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	# random seed for slightly different pickup pitch each time
	rng.randomize()

	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	# stop this from triggering more than once
	if is_collected:
		return

	# only player should be able to collect this
	if not body.is_in_group("player"):
		return

	_collect()


func _collect() -> void:
	is_collected = true
	collected.emit(self)

	# disable collision safely after physics query flush
	collision_shape.set_deferred("disabled", true)

	# hide the visual once picked up
	animated_sprite.visible = false

	# slightly random pitch makes repeated pickups sound less identical
	audio_player.pitch_scale = rng.randf_range(min_pitch_scale, max_pitch_scale)
	audio_player.play()


func reset_for_respawn() -> void:
	if not is_collected:
		return

	is_collected = false
	animated_sprite.visible = true
	collision_shape.set_deferred("disabled", false)
