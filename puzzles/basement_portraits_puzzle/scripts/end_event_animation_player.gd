extends AnimationPlayer

@onready var player : Player = PATHS.player
@onready var player_rcam : PlayerRealCamera = PATHS.player_real_camera
@onready var fade_controller : FadeController = PATHS.fade_controller

@export var wake_up: AnimationPlayer

@onready var collector_model : Node3D = preload("uid://deken5phg1fdy").instantiate() #TODO change this to be loaded when the player arrives the basement 

func execute_collector_screamer():
	player.desactivate()
	player_rcam.change_state(player_rcam.State.BLOQUED)
	player.add_child(collector_model)
	collector_model.position = Vector3(0.0, -0.954, 0.09)
	collector_model.rotation = Vector3(0.0, 180.0, 0.0)
	collector_model.scale = Vector3(0.35, 0.35, 0.35)
	collector_model.get_node("AnimationPlayer").play("screamer")
	var screamer_player : AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	collector_model.add_child(screamer_player)
	screamer_player.stream = load("uid://dgfnjucuqk5x")
	screamer_player.play()
	await get_tree().create_timer(0.5).timeout
	fade_in()
	await get_tree().create_timer(2.0).timeout
	end_event()

func fade_in():
	fade_controller.fade_in(0.01)
	fade_controller.blur_in(0.01)

func end_event():
	await get_tree().create_timer(2.0).timeout
	player.position = Vector3(102.611, -0.66, -63.345)
	player.rotation = Vector3(0.0, -125.5, 0.0)
	player_rcam.pivot.rotation = Vector3.ZERO
	collector_model.queue_free()
	var basement_door : MeshInstance3D = get_tree().get_first_node_in_group("basement_door")
	basement_door.open()
	
	$"../EndCinematic/PhantomCamera3D".priority = 20
	
	fade_controller.fade_out(1.0)
	fade_controller.blur_out(2.0)
	await fade_controller.blur_out_finished
	
	
	wake_up.play("WakeUp")
	await wake_up.animation_finished
	$"../EndCinematic/PhantomCamera3D".priority = 0
	await player_rcam.active_camera.tween_completed
	
	PATHS.get_door("17").rotation = Vector3.ZERO
	player.activate()
	player_rcam.change_state(player_rcam.State.IDLE)
	
	
	
	
