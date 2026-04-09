extends GPUParticles3D

@export var player: Player
@export var speed: float = 0.1
@export var track : LabeledTrack

func _ready() -> void:
	await PATHS.audio_controller.ready
	PATHS.audio_controller.append_selected_track(track)
	PATHS.audio_controller.start_layer(track.label)

func _process(delta: float) -> void:
	var target_pos : Vector3 = player.global_position
	global_position.x = lerp(global_position.x, target_pos.x, speed * delta)
	global_position.z = lerp(global_position.z, target_pos.z, speed * delta)
	
	
