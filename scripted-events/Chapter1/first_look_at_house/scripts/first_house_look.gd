extends Node3D

@onready var audio_controller : AudioController = PATHS.audio_controller

func _on_look_at_trigger_entered_view() -> void:
	var stream : AudioStream = load("uid://bik6t7syfjsb4")
	audio_controller.simple_play(stream)
	queue_free()
