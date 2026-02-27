extends Node3D

@onready var door_10: Door = %Door10
@export var audio_stream_player_3d : AudioStreamPlayer3D
@export var trg_kitchen_arrive : Area3D
@export var trg_kitchen_leaves : Area3D

func _on_trg_kitchen_arrive_body_entered(body: Node3D) -> void:
	if body is Player:
		door_10.locked_anim()
		await get_tree().create_timer(1.0).timeout
		door_10.locked_anim()
		await get_tree().create_timer(0.4).timeout
		door_10.locked_anim()
		await get_tree().create_timer(0.4).timeout
		audio_stream_player_3d.play()
		await audio_stream_player_3d.finished
		trg_kitchen_arrive.queue_free()

func _on_trg_kitchen_leaves_body_entered(body: Node3D) -> void:
	if body is Player:
		door_10.open()
		door_10.is_locked = true
		trg_kitchen_leaves.queue_free()
