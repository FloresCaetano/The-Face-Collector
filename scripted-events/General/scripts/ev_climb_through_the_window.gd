extends EventBehavior
@export var last_player_position: Marker3D
@export var window_open_sound : AudioStream
@export var window_close_sound : AudioStream
@export var enviroment : Environment
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $"../../AudioStreamPlayer3D"
@onready var world_environment: WorldEnvironment = %WorldEnvironment

func execute() -> void:
	audio_stream_player_3d.stream = window_open_sound
	audio_stream_player_3d.play()
	
	PATHS.fade_controller.fade_in(0.5); await PATHS.fade_controller.fade_in_finished
	
	world_environment.environment = enviroment
	audio_stream_player_3d.stream = window_close_sound
	audio_stream_player_3d.play()
	await get_tree().create_timer(0.5).timeout
	
	PATHS.player.global_position = last_player_position.global_position
	get_parent().is_interacting = false
	PATHS.fade_controller.fade_out(0.5)
