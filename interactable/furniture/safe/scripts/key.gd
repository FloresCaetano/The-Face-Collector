class_name SafeKey
extends Interactable

@export var asociated_number : String

@export_category("Dependencies")
@export var mesh_instance : MeshInstance3D
@export var audio_stream_player_3d : AudioStreamPlayer3D
@onready var safe : Safe = get_parent() as Safe


#FLAGS
var mouse_is_over = false

signal key_pressed

func mouse_interaction() -> void:
	if not safe.can_use_keypad:
		return

	if not mouse_is_over:
		mouse_is_over = true
		mesh_instance.visible = true

	if Input.is_action_just_pressed("select_item") and not is_interacting:
		is_interacting = true
		audio_stream_player_3d.play()
		key_pressed.emit(asociated_number)
		

func on_mouse_exited() -> void:
	if not safe.can_use_keypad:
		return
	
	mouse_is_over = false
	is_interacting = false
	mesh_instance.visible = false
