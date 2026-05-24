extends Control
## Simple start screen before the main run begins.
class_name MainMenu


## First level loaded after pressing Start Game.
@export_file("*.tscn") var first_level_path: String = "res://scenes/world/level_1.tscn"

@onready var start_button: Button = $CenterContainer/VBoxContainer/StartButton
@onready var quit_button: Button = $CenterContainer/VBoxContainer/QuitButton


func _ready() -> void:
	GameManager.stop_run()

	if not start_button.pressed.is_connected(_on_start_pressed):
		start_button.pressed.connect(_on_start_pressed)

	if not quit_button.pressed.is_connected(_on_quit_pressed):
		quit_button.pressed.connect(_on_quit_pressed)

	start_button.grab_focus()


func _on_start_pressed() -> void:
	GameManager.reset_run()
	get_tree().change_scene_to_file(first_level_path)


func _on_quit_pressed() -> void:
	get_tree().quit()
