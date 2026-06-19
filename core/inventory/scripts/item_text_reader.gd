class_name ItemTextReader
extends Interactable

@export var text : String

func mouse_interaction() -> void:
	inventory.open_text_container(text)
	is_interacting = false

func on_mouse_exited() -> void:
	pass
