extends Node

var current_chapter : String = "1"
var events_registry : Dictionary = {}

func register_event(event_id : String) -> void:
	events_registry[current_chapter].append(event_id)

func is_event_registered(event_id : String) -> bool:
	return events_registry[current_chapter].has(event_id)
