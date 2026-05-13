extends Area2D


func _ready() -> void:
	# connect here so I do not need to wire the signal by hand every time, cant wrap my head around signals now
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return

	if body.has_method("request_respawn"):
		body.request_respawn("fall death area: " + str(name))
