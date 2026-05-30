extends Node


func _on_food_can_oppener_leave_oppener() -> void:
	get_parent().queue_free()
	
