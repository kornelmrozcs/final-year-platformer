extends CharacterBody2D
class_name PlayerController

@export var move_speed = 300.0
@export var jump_velocity = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 0.0


func _physics_process(delta):
	# gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# jump (basic)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# movement left/right
	direction = Input.get_axis("move_left", "move_right")

	if direction != 0:
		velocity.x = direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)

	move_and_slide()

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