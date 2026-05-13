extends Control
class_name ResultsScreen


@export_file("*.tscn") var restart_scene_path: String = "res://scenes/world/level_1.tscn"

@onready var time_label: Label = $CenterContainer/VBoxContainer/TimeLabel
@onready var deaths_label: Label = $CenterContainer/VBoxContainer/DeathsLabel
@onready var restart_button: Button = $CenterContainer/VBoxContainer/RestartButton
@onready var quit_button: Button = $CenterContainer/VBoxContainer/QuitButton


func _ready() -> void:
	GameManager.stop_run()

	time_label.text = "Time: " + GameManager.get_formatted_time()
	deaths_label.text = "Deaths: " + str(GameManager.death_count)

	if not restart_button.pressed.is_connected(_on_restart_pressed):
		restart_button.pressed.connect(_on_restart_pressed)

	if not quit_button.pressed.is_connected(_on_quit_pressed):
		quit_button.pressed.connect(_on_quit_pressed)


func _on_restart_pressed() -> void:
	GameManager.reset_run()
	get_tree().change_scene_to_file(restart_scene_path)


func _on_quit_pressed() -> void:
	get_tree().quit()
