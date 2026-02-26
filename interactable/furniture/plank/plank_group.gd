class_name PlankGroup
extends Node3D

@export var planks : Array[Plank]
@export var looked_door : Door

var planks_to_be_removed

func _ready() -> void:
	planks_to_be_removed = planks.size()
	for plank in planks:
		plank.plank_removed.connect(_on_plank_removed)
	
func _on_plank_removed() -> void:
	planks_to_be_removed -= 1
	if planks_to_be_removed == 0:
		looked_door.is_locked = false

