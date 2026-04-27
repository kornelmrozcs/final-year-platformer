extends CharacterBody2D
class_name PlayerController

@export var move_speed: float = 256.0
@export var horizontal_acceleration: float = 2048.0
@export var horizontal_friction: float = 2048.0
@export var gravity_strength: float = 512.0
@export var max_fall_speed: float = 512.0
@export var jump_velocity: float = -200.0

@onready var state_machine: PlayerStateMachine = $StateMachine

var direction: float = 0.0


func _ready() -> void:
	add_to_group("player")
	state_machine.init(self)


func _physics_process(delta: float) -> void:
	state_machine.physics_update(delta)
	move_and_slide()


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, max_fall_speed, gravity_strength * delta)


func move_horizontal(delta: float) -> void:
	direction = Input.get_axis("move_left", "move_right")

	var target_speed: float = direction * move_speed
	var used_acceleration: float = horizontal_acceleration

	# when there is no input, use friction instead of acceleration
	if direction == 0.0:
		used_acceleration = horizontal_friction

	velocity.x = move_toward(velocity.x, target_speed, used_acceleration * delta)


func jump() -> void:
	velocity.y = jump_velocity


func wants_jump() -> bool:
	return Input.is_action_just_pressed("jump")


func has_horizontal_input() -> bool:
	return abs(direction) > 0.01
	# TODO / PLAN (state machine)

# na razie jest jeden script z ifami, ale później to przerobić na state machine

# planowane stany:
# - idle (stoi na ziemi, brak inputu)
# - run (ruch po ziemi)
# - jump (idzie do góry)
# - fall (spada)
# - wall slide (ślizga się po ścianie)
# - respawn (brak kontroli, reset)

# pomysł:
# każdy state osobny plik
# np. idle_state.gd, run_state.gd itd.

# player_controller będzie tylko:
# - trzymał velocity, gravity itd.
# - zmieniał aktualny state

# później do tego podpiąć animacje zamiast robić if velocity.y < 0 itd.

# dodatkowe rzeczy do dodania później:
# - coyote time
# - jump buffer
# - wall jump
# - hazards / respawn
# - collectables