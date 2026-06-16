extends Area3D

@export var animation_player: AnimationPlayer
@onready var marker_3d: Marker3D = $Marker3D

@export_category("audio_config")
@onready var audio_controller : AudioController = PATHS.audio_controller
@export var stinger_ambience : AudioStream

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		execute()


func _on_look_at_trigger_entered_view() -> void:
	execute()

func execute():
	PATHS.player_real_camera.look_at_target(marker_3d, 0.2, 4.0)
	animation_player.play("climb", -1, 1.3)
	
	audio_controller.simple_play(stinger_ambience)
	
	await animation_player.animation_finished
	
	PATHS.player.activate()
	PATHS.player_real_camera.change_state(PATHS.player_real_camera.State.IDLE)
	get_parent().queue_free()
