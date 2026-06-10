extends Node


func _on_look_at_trigger_entered_view() -> void:
	await get_tree().create_timer(0.5).timeout
	$"../..".start_animation("Screamer")
	$"..".queue_free()
