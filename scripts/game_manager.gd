extends Node


enum Difficulty {
	EASY,
	MEDIUM,
	HARD,
}

signal deaths_changed(death_count: int)
signal difficulty_changed(difficulty: int)

var run_time: float = 0.0
var death_count: int = 0
var timer_running: bool = false
var difficulty: int = Difficulty.MEDIUM

const GAME_MUSIC: AudioStream = preload("res://assets/audio/background_music.mp3")
const RESULTS_SOUND: AudioStream = preload("res://assets/audio/portal_open.mp3")

var music_player: AudioStreamPlayer
var result_audio_player: AudioStreamPlayer
var music_was_playing_before_pause: bool = false


func _ready() -> void:
	_setup_audio_players()


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


func set_difficulty(new_difficulty: int) -> void:
	if difficulty == new_difficulty:
		return

	difficulty = new_difficulty
	difficulty_changed.emit(difficulty)


func is_easy_mode() -> bool:
	return difficulty == Difficulty.EASY


func is_hard_mode() -> bool:
	return difficulty == Difficulty.HARD


func get_difficulty_name() -> String:
	match difficulty:
		Difficulty.EASY:
			return "Easy"
		Difficulty.HARD:
			return "Hard"
		_:
			return "Medium"


func play_game_music() -> void:
	_setup_audio_players()

	if music_player.playing and not music_player.stream_paused:
		return

	music_player.stream_paused = false
	music_player.play()


func stop_game_music() -> void:
	if music_player == null:
		return

	music_player.stop()
	music_player.stream_paused = false
	music_was_playing_before_pause = false


func pause_game_music() -> void:
	if music_player == null:
		return

	music_was_playing_before_pause = music_player.playing and not music_player.stream_paused

	if music_was_playing_before_pause:
		music_player.stream_paused = true


func resume_game_music() -> void:
	if music_player == null:
		return

	if music_was_playing_before_pause:
		music_player.stream_paused = false

	music_was_playing_before_pause = false


func play_results_sound() -> void:
	_setup_audio_players()
	result_audio_player.pitch_scale = randf_range(0.96, 1.04)
	result_audio_player.play()


func _setup_audio_players() -> void:
	if music_player == null:
		music_player = AudioStreamPlayer.new()
		music_player.name = "MusicPlayer"
		music_player.stream = GAME_MUSIC
		music_player.volume_db = -22.0
		music_player.bus = "Music" if AudioServer.get_bus_index("Music") != -1 else "Master"
		add_child(music_player)
		_set_music_looping(music_player.stream)

	if result_audio_player == null:
		result_audio_player = AudioStreamPlayer.new()
		result_audio_player.name = "ResultAudioPlayer"
		result_audio_player.stream = RESULTS_SOUND
		result_audio_player.volume_db = -24.0
		add_child(result_audio_player)


func _set_music_looping(stream: AudioStream) -> void:
	if stream is AudioStreamMP3:
		var mp3_stream := stream as AudioStreamMP3
		mp3_stream.loop = true
	elif stream is AudioStreamOggVorbis:
		var ogg_stream := stream as AudioStreamOggVorbis
		ogg_stream.loop = true


func get_formatted_time() -> String:
	var total_seconds: int = int(run_time)
	var minutes: int = floori(run_time / 60.0)
	var seconds: int = total_seconds % 60
	var milliseconds: int = int((run_time - float(total_seconds)) * 100.0)

	return "%02d:%02d.%02d" % [minutes, seconds, milliseconds]
