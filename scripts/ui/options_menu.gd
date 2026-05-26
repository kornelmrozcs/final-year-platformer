extends Control
class_name OptionsMenu

@export_file("*.tscn") var main_menu_path: String = "res://scenes/ui/main_menu.tscn"

@onready var difficulty_label: Label = $CenterContainer/VBoxContainer/DifficultyLabel
@onready var easy_button: Button = $CenterContainer/VBoxContainer/EasyButton
@onready var medium_button: Button = $CenterContainer/VBoxContainer/MediumButton
@onready var hard_button: Button = $CenterContainer/VBoxContainer/HardButton
@onready var back_button: Button = $CenterContainer/VBoxContainer/BackButton


func _ready() -> void:
	_update_difficulty_label()
	medium_button.grab_focus()

	if not easy_button.pressed.is_connected(_on_easy_pressed):
		easy_button.pressed.connect(_on_easy_pressed)

	if not medium_button.pressed.is_connected(_on_medium_pressed):
		medium_button.pressed.connect(_on_medium_pressed)

	if not hard_button.pressed.is_connected(_on_hard_pressed):
		hard_button.pressed.connect(_on_hard_pressed)

	if not back_button.pressed.is_connected(_on_back_pressed):
		back_button.pressed.connect(_on_back_pressed)


func _on_easy_pressed() -> void:
	GameManager.set_difficulty(GameManager.Difficulty.EASY)
	_update_difficulty_label()


func _on_medium_pressed() -> void:
	GameManager.set_difficulty(GameManager.Difficulty.MEDIUM)
	_update_difficulty_label()


func _on_hard_pressed() -> void:
	GameManager.set_difficulty(GameManager.Difficulty.HARD)
	_update_difficulty_label()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(main_menu_path)


func _update_difficulty_label() -> void:
	difficulty_label.text = "Difficulty: " + GameManager.get_difficulty_name()
