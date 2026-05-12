extends CharacterBody2D
class_name PlayerController

## max left/right speed
@export var move_speed: float = 256.0

## how fast player reaches max speed
@export var horizontal_acceleration: float = 2048.0

## how fast player stops after letting go
@export var horizontal_friction: float = 4096.0

## custom gravity for this controller, easier to tune than project gravity
@export var gravity_strength: float = 512.0

## stops fall speed from getting too high
@export var max_fall_speed: float = 512.0

## jump force, negative because up is -Y in Godot
@export var jump_velocity: float = -200.0

## remember jump input for a short moment before landing
@export var jump_buffer_time: float = 0.15

## still allow jump shortly after leaving ground
@export var coyote_time: float = 0.10

## fall speed while sliding on a wall
@export var wall_slide_speed: float = 32.0

## allow wall slide slightly before the player starts falling
@export var wall_slide_start_velocity: float = -64.0

## short stick to the wall when first touching it
@export var wall_slide_stick_time: float = 0.12

## stops player from sitting on the same wall forever
@export var wall_slide_max_time: float = 0.35

## keeps wall slide stable across tiny tile gaps
@export var wall_contact_grace_time: float = 0.08

## still allow wall jump shortly after leaving wall
@export var wall_coyote_time: float = 0.10

## side push when jumping away from wall
@export var wall_jump_push: float = 256.0

## place where the player comes back after dying
@export var respawn_position: Vector2 = Vector2(26, 706)

## short wait before player appears again
@export var respawn_delay: float = 0.5

## small safety time after respawn
@export var respawn_recover_time: float = 0.15

## tilemaps and objects in this group can kill the player
@export var hazard_group_name: StringName = &"hazard"

## stops deaths from respawning the player while testing
@export var debug_death_mode: bool = false

## allow debug death mode to be toggled while the game is running
@export var allow_debug_death_toggle: bool = true

@export var debug_death_toggle_action: StringName = &"toggle_debug_death_mode"
@export var debug_manual_respawn_action: StringName = &"debug_manual_respawn"

## stops hazard tiles printing every frame
@export var debug_death_message_cooldown: float = 0.25

@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animation_controller: PlayerAnimationController = $PlayerAnimation

var direction: float = 0.0

var jump_buffer_timer: float = 0.0
var coyote_timer: float = 0.0

var wall_coyote_timer: float = 0.0
var wall_slide_stick_timer: float = 0.0
var wall_slide_timer: float = 0.0
var wall_contact_gap_timer: float = 0.0

var last_wall_normal: Vector2 = Vector2.ZERO
var tracked_wall_side: int = 0

var is_touching_jumpable_wall: bool = false
var wall_slide_exhausted: bool = false
var was_touching_jumpable_wall: bool = false

var is_respawning: bool = false
var debug_death_message_timer: float = 0.0

func _ready() -> void:
	add_to_group("player")
	state_machine.init(self)


func _physics_process(delta: float) -> void:
	_handle_debug_inputs()
	_update_debug_death_message_timer(delta)
	if is_respawning:
		state_machine.physics_update(delta)
		return

	_update_jump_buffer(delta)
	_update_coyote_timer(delta)
	_update_wall_state(delta)

	state_machine.physics_update(delta)
	move_and_slide()
	_check_hazard_collisions()


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, max_fall_speed, gravity_strength * delta)


func move_horizontal(delta: float) -> void:
	direction = Input.get_axis("move_left", "move_right")

	var target_speed: float = direction * move_speed
	var used_acceleration: float = horizontal_acceleration

	# use friction when player stops pressing movement
	if direction == 0.0:
		used_acceleration = horizontal_friction

	velocity.x = move_toward(velocity.x, target_speed, used_acceleration * delta)


func jump() -> void:
	velocity.y = jump_velocity
	jump_buffer_timer = 0.0
	coyote_timer = 0.0


func wall_jump() -> void:
	velocity.y = jump_velocity
	velocity.x = last_wall_normal.x * wall_jump_push

	jump_buffer_timer = 0.0
	coyote_timer = 0.0
	_clear_wall_state()


func wants_jump() -> bool:
	return jump_buffer_timer > 0.0


func can_ground_jump() -> bool:
	return is_on_floor() or coyote_timer > 0.0


func can_wall_jump() -> bool:
	return (
		not is_on_floor()
		and abs(last_wall_normal.x) > 0.9
		and (is_touching_jumpable_wall or wall_coyote_timer > 0.0)
	)


func has_horizontal_input() -> bool:
	return abs(direction) > 0.01


func apply_wall_slide(delta: float) -> void:
	wall_slide_timer += delta

	# stop player staying on one wall forever
	if wall_slide_timer >= wall_slide_max_time:
		wall_slide_stick_timer = 0.0
		wall_slide_exhausted = true
		return

	# small cling when first landing on a wall
	if wall_slide_stick_timer > 0.0:
		wall_slide_stick_timer = max(wall_slide_stick_timer - delta, 0.0)
		velocity.y = 0.0
		return

	velocity.y = min(velocity.y, wall_slide_speed)


func can_wall_slide() -> bool:
	return (
		is_touching_jumpable_wall
		and not is_on_floor()
		and velocity.y >= wall_slide_start_velocity
	)

func _update_jump_buffer(delta: float) -> void:
	# remember jump input for a short moment
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	elif jump_buffer_timer > 0.0:
		jump_buffer_timer = max(jump_buffer_timer - delta, 0.0)


func _update_coyote_timer(delta: float) -> void:
	# still allow jump shortly after leaving ground
	if is_on_floor():
		coyote_timer = coyote_time
	elif coyote_timer > 0.0:
		coyote_timer = max(coyote_timer - delta, 0.0)


func _update_wall_state(delta: float) -> void:
	var raw_touching_wall: bool = _is_touching_side_wall()
	var raw_wall_normal: Vector2 = Vector2.ZERO
	var raw_wall_side: int = 0
	var had_recent_same_wall: bool = false

	if raw_touching_wall:
		raw_wall_normal = get_wall_normal()
		raw_wall_side = _get_wall_side(raw_wall_normal)

		# keeps wall slide stable across tiny tile gaps
		had_recent_same_wall = (
			raw_wall_side != 0
			and raw_wall_side == tracked_wall_side
			and wall_contact_gap_timer > 0.0
			and wall_contact_gap_timer <= wall_contact_grace_time
		)

	_update_wall_session(delta, raw_touching_wall, raw_wall_side)
	is_touching_jumpable_wall = raw_touching_wall and not wall_slide_exhausted

	if is_touching_jumpable_wall:
		last_wall_normal = raw_wall_normal
		wall_coyote_timer = wall_coyote_time

		# only start cling on new wall contact
		if _should_start_wall_cling(had_recent_same_wall):
			wall_slide_stick_timer = wall_slide_stick_time
			wall_slide_timer = 0.0
	else:
		wall_coyote_timer = max(wall_coyote_timer - delta, 0.0)
		wall_slide_stick_timer = 0.0

		if wall_coyote_timer <= 0.0:
			last_wall_normal = Vector2.ZERO

	if is_on_floor():
		_clear_wall_state()

	was_touching_jumpable_wall = is_touching_jumpable_wall


func _update_wall_session(delta: float, raw_touching_wall: bool, raw_wall_side: int) -> void:
	if raw_touching_wall:
		# reset wall session if player changes side
		if raw_wall_side != 0 and raw_wall_side != tracked_wall_side:
			wall_slide_timer = 0.0
			wall_slide_stick_timer = 0.0
			wall_slide_exhausted = false

		tracked_wall_side = raw_wall_side
		wall_contact_gap_timer = 0.0
		return

	if tracked_wall_side == 0:
		return

	wall_contact_gap_timer += delta

	if wall_contact_gap_timer > wall_contact_grace_time:
		wall_slide_timer = 0.0
		wall_slide_stick_timer = 0.0
		wall_slide_exhausted = false
		tracked_wall_side = 0


func _should_start_wall_cling(had_recent_same_wall: bool) -> bool:
	return (
		not wall_slide_exhausted
		and not was_touching_jumpable_wall
		and not had_recent_same_wall
		and velocity.y >= 0.0
	)


func _is_touching_side_wall() -> bool:
	if is_on_floor():
		return false

	if not is_on_wall_only():
		return false

	return abs(get_wall_normal().x) > 0.9


func _get_wall_side(wall_normal: Vector2) -> int:
	return int(sign(wall_normal.x))


func _clear_wall_state() -> void:
	wall_coyote_timer = 0.0
	wall_slide_stick_timer = 0.0
	wall_slide_timer = 0.0
	wall_contact_gap_timer = 0.0

	last_wall_normal = Vector2.ZERO
	tracked_wall_side = 0

	is_touching_jumpable_wall = false
	wall_slide_exhausted = false
	was_touching_jumpable_wall = false

func _handle_debug_inputs() -> void:
	if not allow_debug_death_toggle:
		return

	if InputMap.has_action(debug_death_toggle_action) and Input.is_action_just_pressed(debug_death_toggle_action):
		debug_death_mode = not debug_death_mode
		print("[Debug] death mode: " + ("ON" if debug_death_mode else "OFF"))

	if debug_death_mode and InputMap.has_action(debug_manual_respawn_action) and Input.is_action_just_pressed(debug_manual_respawn_action):
		request_respawn("manual debug respawn", true)


func _update_debug_death_message_timer(delta: float) -> void:
	if debug_death_message_timer > 0.0:
		debug_death_message_timer = max(debug_death_message_timer - delta, 0.0)


func _print_death_debug_message(death_reason: String) -> void:
	if debug_death_message_timer > 0.0:
		return

	debug_death_message_timer = debug_death_message_cooldown
	print("[Death Debug] " + death_reason)

func _check_hazard_collisions() -> void:
	if is_respawning:
		return

	for i in range(get_slide_collision_count()):
		var collision: KinematicCollision2D = get_slide_collision(i)
		var collider := collision.get_collider()

		if collider == null:
			continue

		# solid hazard tiles use this group
		if collider is Node and collider.is_in_group(hazard_group_name):
			request_respawn("hazard collision: " + str(collider.name))
			return

func request_respawn(death_reason: String = "death", force_respawn: bool = false) -> void:
	if is_respawning:
		return

	if debug_death_mode and not force_respawn:
		_print_death_debug_message(death_reason)
		return

	if not force_respawn and GameManager != null:
		GameManager.add_death()

	state_machine.transition_to("Respawn")


func start_respawn() -> void:
	is_respawning = true
	_reset_movement_state()

	# hide player during respawn
	visible = false

	# safer than changing collision during physics callback
	collision_shape.set_deferred("disabled", true)


func finish_respawn() -> void:
	# show player again after position reset
	visible = true
	collision_shape.set_deferred("disabled", false)


func _reset_movement_state() -> void:
	velocity = Vector2.ZERO

	jump_buffer_timer = 0.0
	coyote_timer = 0.0

	_clear_wall_state()

