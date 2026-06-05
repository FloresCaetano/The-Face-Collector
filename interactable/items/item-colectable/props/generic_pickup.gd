extends Interactable

@export var audio_stream_player : AudioStreamPlayer3D

@export var item : Item

func mouse_interaction() -> void:
	interacted.emit()
	inventory.add_item(item)
	collision_layer = 0 ; collision_mask = 0
	audio_stream_player.play()
	leave_interaction()
	await audio_stream_player.finished
	queue_free()


func on_mouse_exited() -> void:
	pass
