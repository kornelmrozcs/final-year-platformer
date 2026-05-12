extends Node


signal deaths_changed(death_count: int)

var run_time: float = 0.0
var death_count: int = 0
var timer_running: bool = false


func _process(delta: float) -> void:
	if timer_running:
		run_time += delta


func reset_run() -> void:
	run_time = 0.0
	death_count = 0
	timer_running = false
	deaths_changed.emit(death_count)


func start_run() -> void:
	timer_running = true


func stop_run() -> void:
	timer_running = false


func add_death() -> void:
	death_count += 1
	deaths_changed.emit(death_count)


func get_formatted_time() -> String:
	var total_seconds: int = int(run_time)
	var minutes: int = floori(run_time / 60.0)
	var seconds: int = total_seconds % 60
	var milliseconds: int = int((run_time - float(total_seconds)) * 100.0)

	return "%02d:%02d.%02d" % [minutes, seconds, milliseconds]