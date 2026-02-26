extends Node

@onready var transition_controller : TransitionController = PATHS.transition_controller

func _ready() -> void:
	transition_controller.fade_in(0.0)
	