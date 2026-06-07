extends Area3D

var times_executed := 0

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		%Door16.open()
		times_executed += 1
		if times_executed >= 2:
			queue_free()
