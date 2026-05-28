extends Control
class_name OptionsMenu

@export_file("*.tscn") var main_menu_path: String = "res://scenes/ui/main_menu.tscn"

@onready var difficulty_label: Label = $CenterContainer/VBoxContainer/DifficultyLabel
@onready var easy_button: Button = $CenterContainer/VBoxContainer/EasyButton
@onready var medium_button: Button = $CenterContainer/VBoxContainer/MediumButton
@onready var hard_button: Button = $CenterContainer/VBoxContainer/HardButton
@onready var description_label: Label = $CenterContainer/VBoxContainer/DescriptionLabel
@onready var back_button: Button = $CenterContainer/VBoxContainer/BackButton


func _ready() -> void:
	_update_difficulty_label()
	_update_description_for_current_difficulty()
	medium_button.grab_focus()

	if not easy_button.pressed.is_connected(_on_easy_pressed):
		easy_button.pressed.connect(_on_easy_pressed)

	if not medium_button.pressed.is_connected(_on_medium_pressed):
		medium_button.pressed.connect(_on_medium_pressed)

	if not hard_button.pressed.is_connected(_on_hard_pressed):
		hard_button.pressed.connect(_on_hard_pressed)

	if not back_button.pressed.is_connected(_on_back_pressed):
		back_button.pressed.connect(_on_back_pressed)

	_connect_description_signals()


func _connect_description_signals() -> void:
	if not easy_button.mouse_entered.is_connected(_show_easy_description):
		easy_button.mouse_entered.connect(_show_easy_description)

	if not medium_button.mouse_entered.is_connected(_show_medium_description):
		medium_button.mouse_entered.connect(_show_medium_description)

	if not hard_button.mouse_entered.is_connected(_show_hard_description):
		hard_button.mouse_entered.connect(_show_hard_description)

	if not easy_button.focus_entered.is_connected(_show_easy_description):
		easy_button.focus_entered.connect(_show_easy_description)

	if not medium_button.focus_entered.is_connected(_show_medium_description):
		medium_button.focus_entered.connect(_show_medium_description)

	if not hard_button.focus_entered.is_connected(_show_hard_description):
		hard_button.focus_entered.connect(_show_hard_description)


func _on_easy_pressed() -> void:
	GameManager.set_difficulty(GameManager.Difficulty.EASY)
	_update_difficulty_label()
	_show_easy_description()


func _on_medium_pressed() -> void:
	GameManager.set_difficulty(GameManager.Difficulty.MEDIUM)
	_update_difficulty_label()
	_show_medium_description()


func _on_hard_pressed() -> void:
	GameManager.set_difficulty(GameManager.Difficulty.HARD)
	_update_difficulty_label()
	_show_hard_description()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(main_menu_path)


func _update_difficulty_label() -> void:
	difficulty_label.text = "Difficulty: " + GameManager.get_difficulty_name()


func _update_description_for_current_difficulty() -> void:
	match GameManager.difficulty:
		GameManager.Difficulty.EASY:
			_show_easy_description()
		GameManager.Difficulty.HARD:
			_show_hard_description()
		_:
			_show_medium_description()


func _show_easy_description() -> void:
	description_label.text = "Easy: minimap is enabled. It shows your position, collectables and the portal."


func _show_medium_description() -> void:
	description_label.text = "Medium: classic experience. No minimap, and collected items stay collected after death."


func _show_hard_description() -> void:
	description_label.text = "Hard: no minimap. Collected items reset after death, so mistakes cost more."