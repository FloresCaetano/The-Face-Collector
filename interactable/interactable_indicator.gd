class_name InteractableIndicator
extends MeshInstance3D

var animation_time : float = 0.08
@export var audio_stream_player_3d: AudioStreamPlayer3D

func grow(_scale : Vector3 = Vector3.ONE):
	audio_stream_player_3d.play()
	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", _scale, animation_time)
	await tween.finished

func shrink():
	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector3.ZERO, animation_time)
	await tween.finished
