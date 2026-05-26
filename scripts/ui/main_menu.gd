extends Control
class_name MainMenu

@export_file("*.tscn") var first_level_path: String = "res://scenes/world/level_1.tscn"
@export_file("*.tscn") var options_menu_path: String = "res://scenes/ui/options_menu.tscn"

@onready var start_button: Button = $CenterContainer/VBoxContainer/StartButton
@onready var options_button: Button = $CenterContainer/VBoxContainer/OptionsButton
@onready var quit_button: Button = $CenterContainer/VBoxContainer/QuitButton


func _ready() -> void:
	start_button.grab_focus()

	if not start_button.pressed.is_connected(_on_start_pressed):
		start_button.pressed.connect(_on_start_pressed)

	if not options_button.pressed.is_connected(_on_options_pressed):
		options_button.pressed.connect(_on_options_pressed)

	if not quit_button.pressed.is_connected(_on_quit_pressed):
		quit_button.pressed.connect(_on_quit_pressed)


func _on_start_pressed() -> void:
	# start fresh but keep selected difficulty
	GameManager.reset_run()
	get_tree().change_scene_to_file(first_level_path)


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file(options_menu_path)


func _on_quit_pressed() -> void:
	get_tree().quit()
