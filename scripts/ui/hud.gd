extends CanvasLayer
class_name HUD


@onready var timer_label: Label = $Control/VBoxContainer/TimerLabel
@onready var deaths_label: Label = $Control/VBoxContainer/DeathsLabel
@onready var collectables_label: Label = $Control/VBoxContainer/CollectablesLabel


func _ready() -> void:
	update_deaths(GameManager.death_count)
	update_collectables(0, 0)

	if not GameManager.deaths_changed.is_connected(update_deaths):
		GameManager.deaths_changed.connect(update_deaths)


func _process(_delta: float) -> void:
	timer_label.text = "Time: " + GameManager.get_formatted_time()


func update_deaths(deaths: int) -> void:
	deaths_label.text = "Deaths: " + str(deaths)


func update_collectables(collected: int, total: int) -> void:
	collectables_label.text = "Collectables: %d / %d" % [collected, total]
