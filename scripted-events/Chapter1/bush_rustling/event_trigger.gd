extends EventTrigger

@export var audio_stream_player_3d: AudioStreamPlayer3D

func _on_event_triggered():
	audio_stream_player_3d.play()
