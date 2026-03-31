class_name Hammer
extends Interactable

@export var item : Item
@export var audio_stream_player_3d : AudioStreamPlayer3D

func mouse_interaction() -> void:
	if Input.is_action_just_pressed("interact") and not is_interacting:
		audio_stream_player_3d.play()
		inventory.add_item(item)
		is_interacting = true
		collision_layer = 0 ; collision_mask = 0
		visible = false

		await get_tree().create_timer(1.0).timeout
		queue_free()

func on_mouse_exited() -> void:
	pass
