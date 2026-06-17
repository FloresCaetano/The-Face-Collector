extends AnimationPlayer

@onready var player : Player = PATHS.player
@onready var fade_controller : FadeController = PATHS.fade_controller

func execute_collector_screamer():
	var collector_model : Node3D = load("uid://deken5phg1fdy").instantiate()
	player.add_child(collector_model)
	collector_model.position = Vector3(0.0, -0.954, 0.09)
	collector_model.get_node("AnimationPlayer").play("screamer")

func fade_in():
	fade_controller.fade_in(0.01)

func end_event():
	pass
