extends Area3D


@export var end_event: Node3D



func _on_body_entered(body: Node3D) -> void:
	var basement_door : MeshInstance3D = get_tree().get_first_node_in_group("basement_door")
	if body is Player and PATHS.inventory.has_item("newspaper"):
		basement_door.close()
		end_event.check_event()
		queue_free()
		
