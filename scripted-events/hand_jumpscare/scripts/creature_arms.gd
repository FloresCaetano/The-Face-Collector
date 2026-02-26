extends Node3D
@onready var stinger_stream : AudioStream = load("uid://b0rs4s4y85ed8")

#FLAGS
var already_played := false
func _process(_delta: float) -> void:
	if $OnScreenNotifier.get_distance() < 2 and not already_played:
		$AnimationPlayer.play("normal")
		already_played = true
		PATHS.audio_controller.simple_play(stinger_stream)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
