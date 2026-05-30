extends Interactable

@export var item : Item
@export var audio_stream : AudioStream = load("uid://cwljb2nauk53b")

func mouse_interaction() -> void:
	var audio_stream_player := AudioStreamPlayer3D.new()
	add_child(audio_stream_player)
	audio_stream_player.play()
	inventory.add_item(item)
	is_interacting = true
	collision_layer = 0 ; collision_mask = 0
	visible = false
	await audio_stream_player.finished
	leave_interaction()
	queue_free()

func on_mouse_exited() -> void:
	pass
