extends CharacterBody2D
class_name PlayerController

@export var move_speed: float = 256.0
@export var horizontal_acceleration: float = 2048.0
@export var horizontal_friction: float = 2048.0
@export var gravity_strength: float = 512.0
@export var max_fall_speed: float = 512.0
@export var jump_velocity: float = -200.0

@export var jump_buffer_time: float = 0.15
@export var coyote_time: float = 0.10

@export var wall_slide_speed: float = 32.0
@export var wall_slide_stick_time: float = 0.12

@onready var state_machine: PlayerStateMachine = $StateMachine

var direction: float = 0.0
var jump_buffer_timer: float = 0.0
var coyote_timer: float = 0.0
var wall_slide_stick_timer: float = 0.0
var is_touching_jumpable_wall: bool = false
var last_wall_normal: Vector2 = Vector2.ZERO


func _ready() -> void:
	add_to_group("player")
	state_machine.init(self)


func _physics_process(delta: float) -> void:
	_update_jump_buffer(delta)
	_update_coyote_timer(delta)
	_update_wall_state(delta)

	state_machine.physics_update(delta)
	move_and_slide()


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


func wants_jump() -> bool:
	return jump_buffer_timer > 0.0


func can_ground_jump() -> bool:
	return is_on_floor() or coyote_timer > 0.0


func has_horizontal_input() -> bool:
	return abs(direction) > 0.01


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

func apply_wall_slide(delta: float) -> void:
	# short cling first, then slow slide down the wall
	if wall_slide_stick_timer > 0.0:
		wall_slide_stick_timer = max(wall_slide_stick_timer - delta, 0.0)
		velocity.y = 0.0
		return

	velocity.y = min(velocity.y, wall_slide_speed)


func can_wall_slide() -> bool:
	return is_touching_jumpable_wall and not is_on_floor() and velocity.y >= 0.0


func _update_wall_state(_delta: float) -> void:
	var was_touching_wall: bool = is_touching_jumpable_wall
	is_touching_jumpable_wall = _is_touching_side_wall()

	if is_on_floor():
		_clear_wall_state()
		return

	if is_touching_jumpable_wall:
		last_wall_normal = get_wall_normal()

		# only start cling when first touching the wall
		if not was_touching_wall and velocity.y >= 0.0:
			wall_slide_stick_timer = wall_slide_stick_time
	else:
		_clear_wall_state()


func _is_touching_side_wall() -> bool:
	if is_on_floor():
		return false

	if not is_on_wall_only():
		return false

	return abs(get_wall_normal().x) > 0.9


func _clear_wall_state() -> void:
	wall_slide_stick_timer = 0.0
	is_touching_jumpable_wall = false
	last_wall_normal = Vector2.ZERO