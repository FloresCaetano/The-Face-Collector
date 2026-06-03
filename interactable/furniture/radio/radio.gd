class_name Radio
extends Interactable

@export var dialogue_reader: DialogueReader

signal radio_finished
func mouse_interaction() -> void:
	dialogue_reader.start()
	

func on_mouse_exited() -> void:
	pass


func _on_dialogue_reader_dialogue_finished() -> void:
	leave_interaction()
	radio_finished.emit()
	
