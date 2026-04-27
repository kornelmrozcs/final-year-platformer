extends CharacterBody2D
class_name PlayerController

@export var move_speed = 300.0
@export var acceleration = 2200.0
@export var friction = 2200.0
@export var jump_velocity = -400.0
@export var max_fall_speed = 700.0

@onready var state_machine: PlayerStateMachine = $StateMachine

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 0.0


func _ready() -> void:
	add_to_group("player")
	state_machine.init(self)


func _physics_process(delta: float) -> void:
	state_machine.physics_update(delta)
	move_and_slide()


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_fall_speed)


func move_horizontal(delta: float) -> void:
	direction = Input.get_axis("move_left", "move_right")

	var target_speed = direction * move_speed
	var used_acceleration = acceleration

	if direction == 0.0:
		used_acceleration = friction

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