extends Node3D
#FLAGS
var already_played := false
func _process(_delta: float) -> void:
	if $OnScreenNotifier.get_distance() < 2 and not already_played:
		$AnimationPlayer.play("normal")
		already_played = true
		get_tree().get_first_node_in_group("audio_player").play_stinger()


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
