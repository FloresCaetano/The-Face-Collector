class_name InteractionTrigger
extends Interactable

@export var event_behavior: EventBehavior

func mouse_interaction() -> void:
	if not event_behavior:
		push_error("InteractionTrigger: No event behavior assigned.")
		return
	event_behavior.execute()

func on_mouse_exited() -> void:
	is_interacting = false
