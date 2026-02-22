extends Interactable

@export var audio_stream_player : AudioStreamPlayer3D
@onready var inventory : Inventory = PATHS.inventory

@export var tape_item : TapeResource

func mouse_interaction() -> void:
	if Input.is_action_just_pressed("interact"):
		inventory.add_item(tape_item)
		collision_layer = 0 ; collision_mask = 0
		audio_stream_player.play()
		await audio_stream_player.finished
		queue_free()


func on_mouse_exited() -> void:
	pass