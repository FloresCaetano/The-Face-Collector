class_name Safe
extends Interactable

@export var correct_code : String = "123456"
@export var keys : Array[SafeKey]

@export_category("Dependencies")
@export var animation_player : AnimationPlayer
@export var audio_stream_player_3d : AudioStreamPlayer3D
@export var correct_code_audio_stream : AudioStream
@export var wrong_code_audio_stream : AudioStream
@export var open_safe_audio_stream : AudioStream
@export var camera_reference : PhantomCamera3D



var code_input : String = ""
var is_open := false

#FLAGS
var can_use_keypad = false

func _ready() -> void:
	set_process_input(false)
	for key in keys:
		key.key_pressed.connect(_on_key_pressed)

func mouse_interaction() -> void:
	player.desactivate()
	
	camera_reference.priority = 20
	await camera_reference.tween_completed
	can_use_keypad = true
	PATHS.player_real_camera.change_state(PlayerRealCamera.State.FOLLOW_CURSOR)

func on_mouse_exited() -> void:
	pass

func on_leave_interaction() -> void:
	await PATHS.player_real_camera.change_state(PlayerRealCamera.State.BLOQUED)
	camera_reference.priority = 0
	can_use_keypad = false
	await PATHS.player_real_camera.active_camera.tween_completed
	await PATHS.player_real_camera.change_state(PlayerRealCamera.State.IDLE)
	player.activate()
	if not is_open:
		collision_layer = 0b1 ; collision_mask = 0b1

func open_safe() -> void:
	audio_stream_player_3d.stream = open_safe_audio_stream
	audio_stream_player_3d.play()
	animation_player.play("DoorAction")
	is_open = true
	collision_layer = 0 ; collision_mask = 0
	for key in keys: key.queue_free()
	

func _on_key_pressed(number : String) -> void:
	code_input += number
	check_code()

func check_code() -> void:
	if code_input.length() == correct_code.length():
		if code_input == correct_code:
			audio_stream_player_3d.stream = correct_code_audio_stream
			audio_stream_player_3d.play()
			open_safe()
		else:
			code_input = ""
			audio_stream_player_3d.stream = wrong_code_audio_stream
			audio_stream_player_3d.play()
