class_name InteractionTrigger
extends Interactable

@export var event_behavior: EventBehavior
@export var can_leave := false

func _ready() -> void:
	if event_behavior:
		event_behavior.event_finished.connect(_on_event_finished)
		return

func mouse_interaction() -> void:
	if not event_behavior:
		push_error("InteractionTrigger: No event behavior assigned.")
		return
	event_behavior.execute()

func _on_event_finished() -> void:
	leave_interaction()
	event_behavior.on_interaction_end()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("scape") and is_interacting and can_leave:
		event_behavior.event_finished.emit()

func on_mouse_exited() -> void:
	pass
