extends CanvasLayer
class_name RespawnFade


## how dark the screen gets during respawn
@export_range(0.0, 1.0, 0.01) var fade_alpha: float = 0.92

## fade out should be quick so death feels responsive
@export var fade_out_time: float = 0.18

## fade in can be slightly slower and smoother
@export var fade_in_time: float = 0.25

@onready var color_rect: ColorRect = $ColorRect

var fade_tween: Tween


func _ready() -> void:
	# keep this over the game but do not block UI or input
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	color_rect.color = Color.BLACK
	color_rect.modulate.a = 0.0
	visible = false


func fade_out() -> void:
	# show dark screen before respawn objects reset
	_start_fade(fade_alpha, fade_out_time, false)


func fade_in() -> void:
	# clear the fade after player and reset objects are ready
	_start_fade(0.0, fade_in_time, true)


func _start_fade(target_alpha: float, duration: float, hide_when_done: bool) -> void:
	visible = true

	if fade_tween != null:
		fade_tween.kill()

	fade_tween = create_tween()
	fade_tween.tween_property(color_rect, "modulate:a", target_alpha, max(duration, 0.01))

	if hide_when_done:
		fade_tween.tween_callback(_hide_after_fade)


func _hide_after_fade() -> void:
	visible = false