@abstract
class_name EventTrigger
extends Area3D

func _ready() -> void:
	collision_layer = 0
	collision_mask = 0b1000
	body_entered.connect(_on_body_entered)

func _on_body_entered(body : Node3D):
	if body is Player:
		await _on_event_triggered()
		queue_free()

@abstract
func _on_event_triggered()
