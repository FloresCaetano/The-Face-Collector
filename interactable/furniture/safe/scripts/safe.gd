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
@export var camera_reference : Marker3D

@onready var camera : Camera = PATHS.camera
@onready var player : Player = PATHS.player
@onready var inventory : Inventory = PATHS.inventory


var code_input : String = ""

#FLAGS
var can_use_keypad = false

func _ready() -> void:
	set_process_input(false)
	for key in keys:
		key.key_pressed.connect(_on_key_pressed)

func mouse_interaction() -> void:
	if Input.is_action_just_pressed("interact") and not is_interacting:
		player.desactivate()
		set_process_input(true)
		is_interacting = true

		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		inventory.can_be_opened = false

		camera.transition(camera_reference.global_transform, 0.5)
		await camera.finished_transition
		can_use_keypad = true

func on_mouse_exited() -> void:
	pass

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("scape") and is_interacting:
		leave_interaction()

func leave_interaction() -> void:
		player.activate()
		camera.return_to_original_pos(0.5)
		is_interacting = false
		can_use_keypad = false
		set_process_input(false)
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		inventory.reset_vars()

func open_safe() -> void:
	audio_stream_player_3d.stream = open_safe_audio_stream
	audio_stream_player_3d.play()
	animation_player.play("DoorAction")

	collision_layer = 0 ; collision_mask = 0
	for key in keys: key.queue_free()
	
	leave_interaction()

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
