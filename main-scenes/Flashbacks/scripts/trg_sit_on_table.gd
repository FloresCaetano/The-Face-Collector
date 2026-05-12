extends EventBehavior
@onready var phantom_camera_3d: PhantomCamera3D = $"../../PhantomCamera3D"

@onready var player : Player = PATHS.player
@onready var player_rcam : PlayerRealCamera = PATHS.player_real_camera
@onready var fade_controller : FadeController = PATHS.fade_controller

func execute() -> void:
	player.desactivate()
	await player_rcam.change_state(player_rcam.State.BLOQUED)
	
	fade_controller.transition(0.5, 0.5)
	await fade_controller.fade_in_finished
	
	$"../../FoodCans".visible = true
	
	phantom_camera_3d.priority = 20
	await fade_controller.transition_finished
	
	player_rcam.change_state(player_rcam.State.FOLLOW_CURSOR)
	await get_tree().create_timer(4.0).timeout
	
	fade_controller.fade_in(2.0)
	await fade_controller.fade_in_finished
	await get_tree().create_timer(4.0).timeout
	GAMESTATE.register_event("alice_waits_on_table")
