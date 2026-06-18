extends Area3D





func _on_body_entered(body: Node3D) -> void:
	var basement_door : MeshInstance3D = get_tree().get_first_node_in_group("basement_door")
	if body is Player:
		basement_door.close()
		queue_free()
		
