extends Node

@export var on_player_leaves_bedroom: Area3D
@export var collector_appearance: Node3D

func _on_tape_interacted() -> void:
	collector_appearance.visible = true
	on_player_leaves_bedroom.monitoring = true
