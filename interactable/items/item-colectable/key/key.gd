class_name Key
extends Interactable

@export var item : KeyResource
@export var audio_stream_player : AudioStreamPlayer3D

func mouse_interaction() -> void:
	PATHS.inventory.add_item(item)
	collision_layer = 0; collision_mask = 0
	audio_stream_player.play()
	interacted.emit()
	await audio_stream_player.finished
	queue_free()

func on_mouse_exited() -> void:
	pass
