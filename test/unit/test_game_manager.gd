extends GutTest


func before_each() -> void:
	GameManager.reset_run()
	GameManager.set_difficulty(GameManager.Difficulty.MEDIUM)


func after_each() -> void:
	GameManager.stop_run()


func test_reset_run_clears_timer_and_deaths() -> void:
	GameManager.run_time = 12.5
	GameManager.death_count = 4
	GameManager.timer_running = true

	GameManager.reset_run()

	assert_eq(GameManager.run_time, 0.0, "run time should reset")
	assert_eq(GameManager.death_count, 0, "death count should reset")
	assert_false(GameManager.timer_running, "timer should stop after reset")


func test_timer_increases_when_running() -> void:
	GameManager.start_run()

	await wait_seconds(0.2)

	assert_true(GameManager.run_time > 0.0, "timer should increase while running")


func test_timer_stops_when_stop_run_is_called() -> void:
	GameManager.start_run()

	await wait_seconds(0.2)

	GameManager.stop_run()
	var stopped_time := GameManager.run_time

	await wait_seconds(0.2)

	assert_true(absf(GameManager.run_time - stopped_time) < 0.05, "timer should not keep increasing after stop")


func test_death_counter_can_increase_many_times() -> void:
	for i in range(1000):
		GameManager.add_death()

	assert_eq(GameManager.death_count, 1000, "death counter should handle repeated deaths")


func test_difficulty_helpers_return_correct_values() -> void:
	GameManager.set_difficulty(GameManager.Difficulty.EASY)
	assert_true(GameManager.is_easy_mode(), "easy mode should be active")
	assert_false(GameManager.is_hard_mode(), "hard mode should not be active")

	GameManager.set_difficulty(GameManager.Difficulty.HARD)
	assert_true(GameManager.is_hard_mode(), "hard mode should be active")
	assert_false(GameManager.is_easy_mode(), "easy mode should not be active")

	GameManager.set_difficulty(GameManager.Difficulty.MEDIUM)
	assert_false(GameManager.is_easy_mode(), "medium should not be easy")
	assert_false(GameManager.is_hard_mode(), "medium should not be hard")


func test_large_run_time_still_formats_correctly() -> void:
	GameManager.run_time = 3661.25

	assert_eq(GameManager.get_formatted_time(), "61:01.25", "large timer value should still format")


func test_death_counter_handles_large_values() -> void:
	GameManager.reset_run()
	GameManager.death_count = 9999999999

	GameManager.add_death()

	assert_eq(GameManager.death_count, 10000000000, "death counter should handle very large values")


func test_timer_handles_large_values() -> void:
	GameManager.reset_run()
	GameManager.run_time = 999999.99

	var formatted_time := GameManager.get_formatted_time()

	assert_true(formatted_time.length() > 0, "large timer should still return text")