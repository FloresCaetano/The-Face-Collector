extends EventBehavior

@onready var phantom_camera_3d: PhantomCamera3D = $"../PhantomCamera3D"
@onready var player_rcam : PlayerRealCamera = PATHS.player_real_camera

func execute() -> void:
	await player_rcam.change_state(player_rcam.State.BLOQUED)
	phantom_camera_3d.priority = 20
	await phantom_camera_3d.tween_completed
	player_rcam.change_state(player_rcam.State.FOLLOW_CURSOR)

func on_interaction_end() -> void:
	await player_rcam.change_state(player_rcam.State.BLOQUED)
	phantom_camera_3d.priority = 0
	await player_rcam.active_camera.tween_completed
	await player_rcam.change_state(player_rcam.State.IDLE)
