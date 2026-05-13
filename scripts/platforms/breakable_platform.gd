extends CharacterBody2D
class_name BreakablePlatform


## delay after player steps on the platform
@export var break_delay: float = 0.35

## how quickly the platform speeds up while falling
@export var fall_acceleration: float = 900.0

## stops the platform falling too fast
@export var max_fall_speed: float = 360.0

## keep this true so the platform comes back after player death
@export var reset_on_player_respawn: bool = true

## only trigger when the player is above the platform
@export var require_player_above: bool = true

## names must match animations in AnimatedSprite2D
@export var idle_animation_name: StringName = &"idle"
@export var break_animation_name: StringName = &"break"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var player_detector: Area2D = $PlayerDetector
@onready var detector_shape: CollisionShape2D = $PlayerDetector/CollisionShape2D

var start_position: Vector2 = Vector2.ZERO
var is_triggered: bool = false
var is_falling: bool = false
var is_hidden_until_respawn: bool = false

var fall_velocity: float = 0.0
var reset_version: int = 0


func _ready() -> void:
	start_position = global_position

	if reset_on_player_respawn:
		# LevelController resets nodes in this group when the player dies
		add_to_group("reset_on_respawn")

	# connect detector here so each platform instance works on its own
	if not player_detector.body_entered.is_connected(_on_player_detector_body_entered):
		player_detector.body_entered.connect(_on_player_detector_body_entered)

	_reset_platform_state()


func _physics_process(delta: float) -> void:
	if not is_falling:
		return

	# platform starts falling slowly and then speeds up
	fall_velocity = min(fall_velocity + fall_acceleration * delta, max_fall_speed)

	var motion: Vector2 = Vector2.DOWN * fall_velocity * delta
	var collision: KinematicCollision2D = move_and_collide(motion)

	if collision == null:
		return

	# hide platform after it hits solid ground
	_hide_until_respawn()


func _on_player_detector_body_entered(body: Node) -> void:
	if is_triggered:
		return

	if is_hidden_until_respawn:
		return

	if not body.is_in_group("player"):
		return

	if require_player_above and not _is_body_above_platform(body):
		return

	_start_break_delay()


func _start_break_delay() -> void:
	is_triggered = true
	var current_reset_version: int = reset_version

	# wait first, so the player has a short warning window
	await get_tree().create_timer(max(break_delay, 0.0)).timeout

	# stop old delay if player already respawned
	if current_reset_version != reset_version:
		return

	if is_hidden_until_respawn:
		return

	_start_falling()


func _start_falling() -> void:
	is_falling = true
	fall_velocity = 0.0

	# break animation starts exactly when the platform begins to fall
	_play_animation(break_animation_name)

	# stop more triggers while this platform is already falling
	_set_detector_enabled(false)


func _hide_until_respawn() -> void:
	is_falling = false
	is_hidden_until_respawn = true
	velocity = Vector2.ZERO

	# hide both visuals and collision, but keep the node alive for reset
	visible = false
	collision_shape.set_deferred("disabled", true)
	_set_detector_enabled(false)
	set_physics_process(false)


func reset_for_respawn() -> void:
	reset_version += 1
	_reset_platform_state()


func _reset_platform_state() -> void:
	is_triggered = false
	is_falling = false
	is_hidden_until_respawn = false

	fall_velocity = 0.0
	velocity = Vector2.ZERO
	global_position = start_position

	visible = true
	set_physics_process(true)

	# deferred changes avoid physics callback warnings
	collision_shape.set_deferred("disabled", false)
	_set_detector_enabled(true)

	_play_animation(idle_animation_name)


func _set_detector_enabled(enabled: bool) -> void:
	if detector_shape != null:
		detector_shape.set_deferred("disabled", not enabled)

	if player_detector != null:
		player_detector.set_deferred("monitoring", enabled)
		player_detector.set_deferred("monitorable", enabled)


func _is_body_above_platform(body: Node) -> bool:
	if not body is Node2D:
		return false

	# player origin should be above the platform origin when standing on it
	return body.global_position.y < global_position.y


func _play_animation(animation_name: StringName) -> void:
	if animated_sprite == null:
		return

	if animated_sprite.sprite_frames == null:
		return

	if not animated_sprite.sprite_frames.has_animation(animation_name):
		push_warning("BreakablePlatform missing animation: " + str(animation_name))
		return

	animated_sprite.play(animation_name)
