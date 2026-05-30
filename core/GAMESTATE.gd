extends Node

var current_chapter : String = "1"
var events_registry : Dictionary = {}

func register_event(event_id : String) -> void:
	if not events_registry.has(current_chapter):
		events_registry[current_chapter] = []
	events_registry[current_chapter].append(event_id)

func is_event_registered(event_id : String) -> bool:
	if not events_registry.has(current_chapter):
		return false
		
	return events_registry[current_chapter].has(event_id)

func wait_for_event(event_id : String) -> void:
	if not is_event_registered(event_id):
		await get_tree().create_timer(0.5).timeout
