class_name DialogueEventTrigger
extends Node

func wait_for_event(event_id: String, interval: float = 0.5) -> void:
	while not GAMESTATE.is_event_registered(event_id):
		await get_tree().create_timer(interval).timeout
		if not is_instance_valid(self):
			return
