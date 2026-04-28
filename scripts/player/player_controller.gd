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

@onready var state_machine: PlayerStateMachine = $StateMachine

var direction: float = 0.0
var jump_buffer_timer: float = 0.0
var coyote_timer: float = 0.0


func _ready() -> void:
	add_to_group("player")
	state_machine.init(self)


func _physics_process(delta: float) -> void:
	_update_jump_buffer(delta)
	_update_coyote_timer(delta)

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