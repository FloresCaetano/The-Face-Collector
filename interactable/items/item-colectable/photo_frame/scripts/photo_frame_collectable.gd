class_name PhotoFrameCollectable
extends Interactable

@export_category("Configuration")
@export var is_on_inventory : bool = true
@export var photo_frame_item : Item

@export_category("dependencies")
@export var collision_shape : CollisionShape3D
@export var audio_stream_player_3d : AudioStreamPlayer3D
@export var animations_player : AnimationPlayer
@onready var inventory : Inventory = PATHS.inventory



func mouse_interaction():
	if Input.is_action_just_released("interact"):
		inventory.add_item(photo_frame_item)
		audio_stream_player_3d.play()
		visible = false
		collision_layer = 0 ; collision_mask = 0

func on_mouse_exited():
	pass

func _on_audio_stream_player_3d_finished() -> void:
	queue_free()