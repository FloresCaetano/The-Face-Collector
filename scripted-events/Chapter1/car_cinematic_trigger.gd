extends Node

@onready var transition_controller : TransitionController = PATHS.transition_controller
@export var audio_stream_player : AudioStreamPlayer

func _ready() -> void:
	transition_controller.fade_out(0.0)
	audio_stream_player.play()
	await audio_stream_player.finished
	transition_controller.fade_in(2.0)
	
