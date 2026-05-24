extends CanvasLayer
class_name PauseMenu


@onready var resume_button: Button = $Overlay/CenterContainer/VBoxContainer/ResumeButton
@onready var quit_button: Button = $Overlay/CenterContainer/VBoxContainer/QuitButton

var is_open: bool = false
var was_timer_running: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

	if not resume_button.pressed.is_connected(_on_resume_pressed):
		resume_button.pressed.connect(_on_resume_pressed)

	if not quit_button.pressed.is_connected(_on_quit_pressed):
		quit_button.pressed.connect(_on_quit_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.echo:
		return

	if event.is_action_pressed("pause_game") or event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()

		if is_open:
			_resume_game()
		else:
			_pause_game()


func _pause_game() -> void:
	is_open = true
	was_timer_running = GameManager.timer_running
	GameManager.stop_run()
	visible = true
	get_tree().paused = true
	resume_button.grab_focus()


func _resume_game() -> void:
	get_tree().paused = false
	visible = false
	is_open = false

	if was_timer_running:
		GameManager.start_run()


func _on_resume_pressed() -> void:
	_resume_game()


func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()


func _exit_tree() -> void:
	if get_tree() != null:
		get_tree().paused = false
