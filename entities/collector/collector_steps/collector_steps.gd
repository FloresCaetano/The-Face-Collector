@tool
extends Node3D

@export var threshold_distance: float = 2.0
var last_position: Vector3 = Vector3.ZERO

func _ready() -> void:
	last_position = global_position

func _process(delta: float) -> void:
	check_movement_distance()

func check_movement_distance() -> void:
	var traveled_distance: float = global_position.distance_to(last_position)
	
	if traveled_distance >= threshold_distance:
		trigger_distance_action()
		
		if traveled_distance > 0:
			var direction: Vector3 = (global_position - last_position).normalized()
			last_position += direction * threshold_distance
		else:
			last_position = global_position


func trigger_distance_action() -> void:
	$AudioStreamPlayer3D.play()
