class_name LightSwitch
extends Interactable


@export var lamp : CeilingLamp

@export_category("Dependencies")
@export var audio_stream_player_3d: AudioStreamPlayer3D

func mouse_interaction() -> void:
	if Input.is_action_just_pressed("interact"):
		audio_stream_player_3d.play()
		if lamp.is_on:
			lamp.turn_off()
		else:
			lamp.turn_on()

func on_mouse_exited() -> void:
	pass
