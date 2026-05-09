extends Area3D



func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		PATHS.scene_manager.instantiate_flashsback("")
