extends EventBehavior
@export var phantom_camera_3d: PhantomCamera3D

@onready var player : Player = PATHS.player
@onready var player_rcam : PlayerRealCamera = PATHS.player_real_camera
@onready var fade_controller : FadeController = PATHS.fade_controller
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"


func execute() -> void:
	player.desactivate()
	await player_rcam.change_state(player_rcam.State.BLOQUED)
	
	fade_controller.transition(0.5, 0.5)
	await fade_controller.fade_in_finished
	$"../../alice_on_table".visible = true
	$"../../FoodCans".visible = true
	
	phantom_camera_3d.priority = 20
	await phantom_camera_3d.tween_completed
	
	player_rcam.change_state(player_rcam.State.FOLLOW_CURSOR)
	
	for i in range(4):
		animation_player.play("eat")
		await animation_player.animation_finished
	
	
	animation_player.play("sleep")
	await animation_player.animation_finished
	
	fade_controller.fade_in(2.0)
	await fade_controller.fade_in_finished
	await get_tree().create_timer(4.0).timeout
	GAMESTATE.register_event("alice_waits_on_table")
