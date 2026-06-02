extends Interactable

@export var item : Item
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D


func mouse_interaction() -> void:
	interacted.emit()
	audio_stream_player_3d.play()
	inventory.add_item(item)
	is_interacting = true
	collision_layer = 0 ; collision_mask = 0
	visible = false
	await audio_stream_player_3d.finished
	leave_interaction()
	queue_free()

func on_mouse_exited() -> void:
	pass
