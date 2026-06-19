extends Area3D

@export var animation_player: AnimationPlayer
@onready var marker_3d: Marker3D = $Marker3D

@export_category("audio_config")
@onready var audio_controller : AudioController = PATHS.audio_controller
@export var stinger_ambience : AudioStream
@export var blood_wall: BloodWall

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		execute()


func _on_look_at_trigger_entered_view() -> void:
	start_screamer()

func execute():
	PATHS.player_real_camera.look_at_target(marker_3d, 0.2, 4.0, false)
	blood_wall.set_blood_amount(0.0, 0.8, 2.0)
	audio_controller.simple_play(stinger_ambience)
	$"../LookAtTrigger".is_active = true
	

func start_screamer():
	$"../first_appearance".visible = true
	animation_player.play("climb", -1, 1.3)
	await animation_player.animation_finished
	
	PATHS.player.activate()
	PATHS.player_real_camera.change_state(PATHS.player_real_camera.State.IDLE)
	get_parent().queue_free()
